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
  
  connect() {
    console.log("CONNECT MAP", this.geodataValue, this.sitesValue)
    this.zonesData = []
    this.firstLevel = []
    this.secondLevel = []
    this.thirdLevel = []
    this.emergency = []
    this.icon = {
      iconUrl: '/images/user.svg',
      iconSize: [37, 45],
      iconAnchor: [18.5, 45],
      popupAnchor: [1, -34],
      tooltipAnchor: [16, -28],
      shadowSize: [60, 60]
    }
    this.userIcon = L.icon(this.icon)
    this.zonesDataLayer = new L.FeatureGroup()
    this.firstLevelLayer = new L.FeatureGroup()
    this.secondLevelLayer = new L.FeatureGroup()
    this.thirdLevelLayer = new L.FeatureGroup()
    this.emergencyLayer = new L.FeatureGroup()
    this.createMap()
    this.map.setView([-32.65,-56.23388], 7)
    this.map.scrollWheelZoom.disable()
    this.loadFeatures()
    this.map.on("locationfound", (e) => {
      console.log("LOCATION FOUND", e)
      
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
    this.map.on('click', function() {
      if (this.map.scrollWheelZoom.enabled()) {
        this.map.scrollWheelZoom.disable()
      }
      else {
        this.map.scrollWheelZoom.enable()
      }
    });
  }

  createMap() {
    this.map = L.map(this.containerTarget)

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);
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
      if ( gd.wkt !== null ) {
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
          iconUrl += '-'+gd.geo.join('-')
          geo = true
        }
        let feature = { 
          type: "Feature",
          properties: {
          gId: gd.id,
          name: gd.name,
          description: gd.description,
          gtype: "site",
          site_id: gd.id,
          geo: geo,
          iconUrl: iconUrl,
          emergency: gd.emergency ? true : false 
        },
        geometry: wkt.toJson() 
        }
        obj.push(feature)
        console.log(gd.emergency);
        
        if ( gd.emergency ) {
          this.emergency.push(feature)
        }
      }
    })
    console.log(this.emergency);
    
    //ADD TO MAP
    ['zonesData', 'firstLevel', 'secondLevel', 'thirdLevel', 'emergency'].forEach(l => {
      //ICONS
      L.geoJSON(this[l], {
        onEachFeature: (feature, layer) => {
          this.icon.iconUrl = '/images/'+feature.properties.iconUrl+'.svg'
          layer.setIcon(L.icon(this.icon))
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
    this[l+"Layer"].addTo(this.map)
    })    
  }
  // Info Panel
  showInfo(zone) {
    console.log("SHOW INFO", zone)
    if ( this.infoTarget.classList.contains('visible') ) {
      console.log("TARGET VISIBLE", this.infoTarget)
      this.infoTarget.classList.remove('visible')
      setTimeout( e => {
        this.infoTarget.style.display = 'none'
      }, 330)
    }
    else {
      console.log("TARGET NOT", this.infoTarget)
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
    console.log("LOCATION", e)
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
