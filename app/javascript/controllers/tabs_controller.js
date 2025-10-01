import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["prestadores", 'vacunatorios', 'clinicas', 'otros']
  //static values = { tab: Text }
  static last_tab = 'prestadores'
  
  connect() {
    console.log("CONECT TABS");
    
  }
  
  switch_tab() {
    console.log("SWITCH to ");
    
  }
}
