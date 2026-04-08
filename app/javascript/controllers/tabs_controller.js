import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  connect() {
    console.log("CONECT TABS");
    this.current_tab = 'tab-prestadores'
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
    this.current_tab = tid
    document.getElementById(tid).style.display = 'flex'
  }

  search(e) {
    switch(this.current_tab) {
      case 'tab-prestadores':
        fetch('/proveedor/?type=summary&name='+e.target.value, {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html"
        }
      })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      break
    }
    
  }
}
