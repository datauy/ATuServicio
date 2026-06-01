import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="map"
import L from "leaflet"
import * as Wkt from "wicket"


export default class extends Controller {
  static targets = ["container", "info"]
  //Change to targets?? TODO
  static values = {geodata: [], sites: []}

  static zonesData
  static firstLevel
  static secondLevel
  static thirdLevel
  static emergency
  static zonesDataLayer
  static firstLevelLayer
  static thirdLevelLayer
  static emergencyLayer
  static icon 
  static userIcon
  static userMarker
  static map
  static layers
  
  connect() {
    //Set initial layers
    this.layers = {
      zonesData: false,
      firstLevel: false,
      secondLevel: true,
      thirdLevel: true,
      emergency: false
    }
    //Initialize variables
    Object.keys(this.layers).forEach( l => {
      this[l] = []
      this[l+'Layer'] = new L.FeatureGroup()
    })
    this.icon = {
      iconUrl: '/images/user.svg',
      iconSize: [37, 45],
      iconAnchor: [18.5, 45],
      popupAnchor: [1, -34],
      tooltipAnchor: [16, -28],
      shadowSize: [60, 60]
    }
    this.userIcon = L.icon(this.icon)
    this.createMap()
    this.map.setView([-32.65,-56.23388], 7)
    this.map.scrollWheelZoom.disable()
    this.loadFeatures()
  }

  createMap() {
    this.map = L.map(this.containerTarget)
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);
    this.map.on("locationfound", (e) => {
      const { latlng, accuracy } = e
      // Create/update marker
      if (!this.userMarker) {
        this.userMarker = L.marker(latlng, {icon: this.userIcon}).addTo(this.map)
      }
      else {
        this.userMarker.setLatLng(latlng)
      }
      this.map.flyTo(latlng,15)
    })
    this.map.on("locationfound", (e) => {
      console.log("LOCATION ERROR", e)
      const { latlng, accuracy } = e;
    })
    this.map.on('click', (e) => {
      if (this.map.scrollWheelZoom.enabled()) {
        this.map.scrollWheelZoom.disable()
      }
      else {
        this.map.scrollWheelZoom.enable()
      }
    });
  }

  loadFeatures() {
    //LOAD DATA
    let wkt = new Wkt.default.Wkt()
    this.geodataValue.forEach(gd => {
      if ( gd.wkt != null && gd.wkt != 0 && gd.site_id == null ) {
        wkt.read(gd.wkt);
        this.zonesData.push({ 
          type: "Feature",
          properties: {
            gId: gd.id,
            gtype: gd.gtype,
            name: gd.name,
            description: gd.description,
            iconUrl: 'zonesData',
          },
          geometry: wkt.toJson() 
        })
      }
    })
    let obj
    let iconUrl
    this.sitesValue.forEach(gd => {
      if ( gd.wkt != null && gd.wkt != 0 ) {
        let count = 0
        wkt.read(gd.wkt);
        switch(gd.level) {
          case 2:
            obj = this.thirdLevel
            iconUrl = 'thirdLevel'
          break
          case 1:
            obj = this.secondLevel
            iconUrl = 'secondLevel'
          break;
          default:
            obj = this.firstLevel
            iconUrl = 'firstLevel'
        }
        let geo = false
        if (gd.geo != null) {
          count += 1
          geo = true
        }
        if ( gd.emergency ) {
          count += 1
        }
        let feature = { 
          type: "Feature",
          properties: {
          gId: gd.id,
          name: gd.name+'<br><b>'+gd.pname+'</b>',
          description: gd.description,
          gtype: "site",
          site_id: gd.id,
          geo: geo,
          iconUrl: iconUrl,
          emergency: gd.emergency ? true : false,
          counter: count
          },
          geometry: wkt.toJson() 
        }
        obj.push(feature)
        if ( gd.emergency ) {
          this.emergency.push(feature)
        }
        if ( gd.geo ) {
          this.zonesData.push(feature)
        }
      }
    })
    //ADD TO MAP
    Object.keys(this.layers).forEach(l => {
      //ICONS
      L.geoJSON(this[l], {
        onEachFeature: (feature, layer) => {
          this.icon.iconUrl = '/images/'+feature.properties.iconUrl+'.svg'
          let icon = L.icon(this.icon)
          if ( feature.properties.counter > 0 ) {
            let ihtml = '<img src="' + this.icon.iconUrl + '" />'
            if ( feature.properties.counter > 1 ) {
              ihtml += '<b>' + feature.properties.counter + '</b>'
            }
            else {
              if (feature.properties.emergency) {
                ihtml += '<b class="emergency"></b>'
              }
              else {
                ihtml += '<b class="vac"></b>'
              }
            }
            icon = L.divIcon({ 
              html: ihtml,
              iconSize: '36px'
            });
          }
          layer.setIcon(icon)
          let popupContent = feature.properties.name
          layer.bindPopup(popupContent);
          layer.on({
            click: (e) => {
              this.showInfo(e.target.feature.properties)
            },
            mouseover: (e) => {
              layer.openPopup(e.latlng)
            },
            mouseout: (e) => {
              layer.closePopup()
            }
          })
        }
      }).addTo(this[l+"Layer"]);
      if ( this.layers[l] ) {
        this[l+"Layer"].addTo(this.map)
      }
      document.getElementById(l).checked = this.layers[l]
    })
  }
  // Info Panel
  showInfo(zone) {
    if ( this.infoTarget.classList.contains('visible') ) {
      this.infoTarget.classList.remove('visible')
      setTimeout( e => {
        this.infoTarget.style.display = 'none'
      }, 330)
    }
    else {
      if ( zone.gtype == 'vacunatorio') {
        this.infoTarget.querySelector('#zone-description').innerHTML = "<h4>"+zone.name+"</h4><p>"+zone.description+"</p>"
        this.infoTarget.style.display = 'flex'
        setTimeout( e => {
          this.infoTarget.classList.add('visible')
        }, 50)
      }
      else {
        fetch('/site/'+zone.site_id+'/summary', {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html"
        }
        })
        .then(r => r.text())
        .then(html => {
          Turbo.renderStreamMessage(html)
          this.infoTarget.style.display = 'flex'
          setTimeout( e => {
            this.infoTarget.classList.add('visible')
          }, 50)
        })
      }
    }
  }

  slideInfo() {
    
  }
  //todo: fix geo
  geoLocate(e) {
    // Leaflet will trigger "locationfound" / "locationerror"
    this.map.locate({
      setView: true,
      maxZoom: 20,
      enableHighAccuracy: true,
      timeout: 12000,
      maximumAge: 0,
    })
  }

  updateMap() {
    console.log("MAP UPDATED SHOWING...")
    
  }
  changeServices(e) {
    let layer = e.target.value+"Layer"
    if ( e.target.checked ) {
      this[layer].addTo(this.map)  
    }
    else {
      this[layer].remove()
    }
  }

  getDescription(gid, gtype) {

  }

  disconnect() {
    this.map.remove();
  }
}
