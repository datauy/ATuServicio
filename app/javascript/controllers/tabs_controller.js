import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ['filter1', 'filter2', 'loading']
  
  static loading

  connect() {
    this.current_tab = 'tab-prestadores'
    this.loading = false
  }
  
  switch_tab(e) {
    console.log("SWITCH to ", e);
    if ( !this.loading ) {
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
          this.render_turbo('/sites')
        }
      }
      if ( tid == 'tab-vacunatorios' ) {
        if ( document.getElementById('infra_grid').innerHTML  == "" ) {
          this.render_turbo('/infra')
        }
      }
      tab.style.display = 'flex'
    }
  }

  search(e) {
    let url = 0
    if ( !this.loading && ( this.filter1Target.value.length > 2 || this.filter2Target.value )) {
      console.log("SEARCHING", this.filter1Target.value,this.filter2Target.value);
      switch(this.current_tab) {
        case 'tab-prestadores':
          url = '/proveedor/?type=summary'
        break
        case 'tab-clinicas':
          url = '/sites'
        break
        case 'tab-vacunatorios':
            url = '/infra'
        break
      }
      url = new URL(url, window.location.origin)
      if ( this.filter1Target.value.length > 2 ) {
        url.searchParams.append('name', this.filter1Target.value)
      }
      if ( this.filter2Target.value ) {
        url.searchParams.append('state', this.filter2Target.value)
      }
      this.render_turbo(url)
    }
  }

  render_turbo(url) {
    this.loading == true
    this.loadingTarget.style.display = 'flex'
    fetch(url, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
      })
      .then(r => r.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
        this.loading == false
        this.loadingTarget.style.display = 'none'
      })
  }
}
