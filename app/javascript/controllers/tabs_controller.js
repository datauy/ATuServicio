import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  connect() {
    console.log("CONECT TABS");
    
  }
  
  switch_tab(e) {
    console.log("SWITCH to ", e);
    // Change tabs headers
    document.querySelector('.tabs-header [aria-expanded="true"').setAttribute('aria-expanded', false)
    e.target.setAttribute('aria-expanded', true)
    //Hide all content
    document.querySelectorAll(".tab-inner").forEach( tab => {
      tab.style.display = 'none'
    })
    //Show content
    let tid = e.target.getAttribute('aria-controls')
    document.getElementById(tid).style.display = 'flex'
  }
}
