import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="map"
import L from "leaflet"
import * as Wkt from "wicket"


export default class extends Controller {
  static targets = ["container"]
  //Change to targets?? TODO
  static values = {geodata: [], "first_level": {}, "vacunatorios": {}, "third_level": {}}

  static vacunatoriosLayer
  static firstLevelLayer
  static thirdLevelLayer
  static userMarker
  
  connect() {
    console.log("CONNECT MAP", this.geodataValue, this.prestadoresValue)
    this.vacunatoriosLayer = new L.FeatureGroup()
    this.firstLevelLayer = new L.FeatureGroup()
    this.thirdLevelLayer = new L.FeatureGroup()
    this.createMap()
    this.map.setView([-32.65,-56.23388], 7)
    this.loadFeatures()
    this.map.on("locationfound", (e) => {
      const { latlng, accuracy } = e;
      // Create/update marker
      if (!this.userMarker) {
        this.userMarker = L.marker(latlng).addTo(this.map);
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
    let wkt = new Wkt.default.Wkt()
    let zonesData = []
    this.geodataValue.forEach(gd => {
      if ( gd.wkt !== null ) {
        wkt.read(gd.wkt);
        zonesData.push({ 
          "type": "Feature",
          'properties': {
            gId: gd.id,
            gtype: gd.gtype
          }, "geometry": wkt.toJson() 
        })
      }
    })
    let zonesIcon = L.icon({
      iconUrl: '/images/vacunatorios.svg',
      iconSize: [37, 45],
      iconAnchor: [18.5, 45],
      popupAnchor: [1, -34],
      tooltipAnchor: [16, -28],
      shadowSize: [60, 60]
    });
    L.geoJSON(zonesData, {
      fillColor: 'violet',
      color: 'violet',
      onEachFeature: (feature, layer) => {
        layer.setIcon(zonesIcon)
        layer.on({
          click: (e) => {
            console.log("PIN CLICK", e.target.feature.properties)
          }            
        })
      }
    }).addTo(this.vacunatoriosLayer);
    this.vacunatoriosLayer.addTo(this.map)
  }

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
