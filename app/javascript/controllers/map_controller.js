import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="map"
import L from "leaflet"
import * as Wkt from "wicket"


export default class extends Controller {
  static targets = ["container"]
  //Change to targets?? TODO
  static values = {geodata: [], sites: []}

  static zonesData
  static firstLevel
  static secondLevel
  static thirdLevel
  static zonesDataLayer
  static firstLevelLayer
  static thirdLevelLayer
  static icon 
  static userIcon
  static userMarker
  
  connect() {
    console.log("CONNECT MAP", this.geodataValue, this.sitesValue)
    this.zonesData = []
    this.firstLevel = []
    this.secondLevel = []
    this.thirdLevel = []
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
    this.createMap()
    this.map.setView([-32.65,-56.23388], 7)
    this.loadFeatures()
    this.map.on("locationfound", (e) => {
      const { latlng, accuracy } = e;
      // Create/update marker
      if (!this.userMarker) {
        this.userMarker = L.marker(latlng, {icon: this.userIcon}).addTo(this.map);
      }
      else {
        this.userMarker.setLatLng(latlng);
      }
    })
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
          },
          geometry: wkt.toJson() 
        })
      }
    })
    let obj
    
    this.sitesValue.forEach(gd => {
      if ( gd.wkt !== null ) {
        wkt.read(gd.wkt);
        switch(gd.level) {
          case 1:
            obj = this.secondLevel
          break;
          case 2:
            obj = this.thirdLevel
          break
          default:
            obj = this.firstLevel
          }
          obj.push({ 
            type: "Feature",
            properties: {
            gId: gd.id,
            gtype: "site",
            site_id: gd.id,
            geo: gd.geo != null ? gd.geo.join('-') : ''
          },
          geometry: wkt.toJson() 
        })
      }
    })
    console.log("LEVEL", this['thirdLevel']);
    //ADD TO MAP
    ['zonesData', 'firstLevel', 'secondLevel', 'thirdLevel'].forEach(l => {
      //ICONS
      this.icon.iconUrl = '/images/'+l+'.svg'
      let icon = L.icon(this.icon);
      L.geoJSON(this[l], {
        onEachFeature: (feature, layer) => {
          if ( feature.properties.geo != undefined && feature.properties.geo != '' ) {
            console.log("ICON GEO", feature.properties.geo);
            this.icon.iconUrl = '/images/'+l+'-vacunatorio.svg'
            layer.setIcon(L.icon(this.icon))
          }
          else {
            
            layer.setIcon(icon)
          }
          layer.on({
            click: (e) => {
              this.showInfo(e.target.feature.properties)
            }            
          })
        }
      }).addTo(this[l+"Layer"]);
    this[l+"Layer"].addTo(this.map)
    })    
  }
  // Info Panel
  showInfo(props) {
    console.log("SHOW INFO", props)
    
  }
  //todo: fix geo
  geoLocate() {
    // Leaflet will trigger "locationfound" / "locationerror"
    this.map.locate({
      setView: true,
      maxZoom: 16,
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
