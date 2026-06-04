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
      iconSize: [36, 36],
      iconAnchor: [18, 36],
      popupAnchor: [1, -36],
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
    this.map = L.map(this.containerTarget, {gestureHandling: true})
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
    let level
    this.sitesValue.forEach(gd => {
      if ( gd.wkt != null && gd.wkt != 0 ) {
        let count = 0
        wkt.read(gd.wkt);
        switch(gd.level) {
          case 2:
            obj = this.thirdLevel
            iconUrl = 'thirdLevel'
            level = 'Hospital'
          break
          case 1:
            obj = this.secondLevel
            iconUrl = 'secondLevel'
            level = 'Centro de salud'
          break;
          default:
            obj = this.firstLevel
            iconUrl = 'firstLevel'
            level = 'Policlínica'
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
          name: gd.name,
          pname: gd.pname,
          description: gd.description,
          gtype: "site",
          site_id: gd.id,
          geo: geo,
          level: level,
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
              iconSize: 36,
              iconAnchor: [18, 36],
              popupAnchor: [1, -36],
            });
          }
          layer.setIcon(icon)
          let popupContent = this.buildPopUp(feature.properties)
          layer.bindPopup(popupContent);
          layer.on({
            click: (e) => {
              this.showInfo(e.target.feature.properties)
            },
            mouseover: (e) => {
              layer.openPopup(e.latlng)
            },
            mouseout: (e) => {
              //layer.closePopup()
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
  //
  buildPopUp(feature) {
    let popup = '<div class="popup"><h4>'+feature.name+'</h4>'
    if ( feature.pname ) {
      popup += '<span class="subtitle">'+feature.pname+'</span><div class="break">Servicios:</div><div class="tags">'
    }
    if ( feature.level != null ) {
      popup += '<div class="tag '+feature.iconUrl+'">'+feature.level+'</div>'
      if (feature.geo) {
        popup += '<div class="tag vac">Vacunatorio</div>'
      }
      if (feature.emergency) {
        popup += '<div class="tag emergency">Puerta de emergencia</div>'
      }
    }
    else {
      popup += '<div class="tag vac">Vacunatorio</div>'
    }
    popup += '</div></div></div>'
    return popup
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
