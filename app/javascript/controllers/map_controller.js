import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="map"
import L from "leaflet"


export default class extends Controller {
  static targets = ["container"]
  //Change to targets?? TODO
  static values = {"prestadores": Boolean, "vacunatorios": Boolean, "clinicas": Boolean, "otros": Boolean}

  connect() {
    console.log("CONNECT MAP");
    
    this.createMap()
    this.map.setView([-32.65,-56.23388], 7);
  }

  createMap() {
    this.map = L.map(this.containerTarget)

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);
  }

  updateMap() {
    console.log("MAP UPDATED SHOWING...");
    
  }

  disconnect() {
    this.map.remove();
  }
}
