import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ['filter1', 'filter2']
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
    let tab = document.getElementById(tid)
    if ( tid == 'tab-clinicas' ) {
      if ( document.getElementById('sites_grid').innerHTML  == "" ) {
        fetch('/sites', {
        method: "GET",
        headers: { Accept: "text/vnd.turbo-stream.html" }
        })
        .then(r => r.text())
        .then(html => {
          Turbo.renderStreamMessage(html)
          tab.style.display = 'flex'    
        })
      }
    }
    if ( tid == 'tab-vacunatorios' ) {
      if ( document.getElementById('infra_grid').innerHTML  == "" ) {
        console.log("GET CONTENT FOR TAB loader?");
        fetch('/infra', {
        method: "GET",
        headers: { Accept: "text/vnd.turbo-stream.html" }
        })
        .then(r => r.text())
        .then(html => {
          Turbo.renderStreamMessage(html)
          tab.style.display = 'flex'    
        })
      }
    }
    tab.style.display = 'flex'
  }

  search(e) {
    console.log("SEARCH TAB", this.current_tab);
    let url = 0
    switch(this.current_tab) {
      case 'tab-prestadores':
        url = '/proveedor/?type=summary'
        if ( this.filter1Target.value.length > 2 ) {
          url = '/proveedor/?type=summary&name='+this.filter1Target.value
        }
        if ( this.filter2Target.value ) {
          url += '&departamento='+this.filter2Target.value
        }
      break
      case 'tab-clinicas':
        if ( this.filter1Target.value.length > 2 ) {
          url = '/sites?name='+this.filter1Target.value
        }
      break
      case 'tab-vacunatorios':
        if ( this.filter1Target.value.length > 2 ) {
          url = '/infra?name='+this.filter1Target.value
        }
      break
    }
    if (url) {
      fetch(url, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
      })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
    }
  }
}
