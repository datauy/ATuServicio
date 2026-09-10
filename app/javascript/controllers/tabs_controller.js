import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ['filter1', 'filter2', 'loading']
  
  static loading
  static page
  static stalled

  connect() {
    this.current_tab = 'tab-prestadores'
    this.loading = false
    this.page = 0
    this.stalled = false
    window.addEventListener('scroll', () => {
      
      let inner = document.getElementById(this.current_tab)
      if ( this.loading == false && (inner.offsetTop + inner.offsetHeight - window.innerHeight < window.scrollY) ) {
        console.log("SCROLLING LOAD", this.stalled );
        this.more()
      }
    })
  }
  
  switch_tab(e) {
    console.log("SWITCH to ", e);
    if ( !this.loading ) {
      this.stalled = false
      this.page = 0
      this.loading = true
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
  
  more() {
    if ( this.stalled == false ) {
      this.page += 1
      this.search(null, true)
    }
  }
  search(e, load = false) {
    let url = 0
    if ( !this.loading && ( this.filter1Target.value.length > 2 || this.filter1Target.value.length == 0 || this.filter2Target.value != 0 || load )) {
      this.loading = true
      if ( !load ) {
        this.page = 0
      }
      console.log("SEARCHING", this.filter1Target,this.filter2Target);
      switch(this.current_tab) {
        case 'tab-prestadores':
          url = '/proveedor/?type=summary&page='+this.page
        break
        case 'tab-clinicas':
          url = '/sites?page='+this.page
        break
        case 'tab-vacunatorios':
            url = '/infra?page='+this.page
        break
      }
      url = new URL(url, window.location.origin)
      if ( this.filter1Target.value.length > 2 ) {
        url.searchParams.append('name', this.filter1Target.value)
      }
      if ( this.filter2Target.value ) {
        url.searchParams.append('state', this.filter2Target.value)
      }
      this.render_turbo(url, load)
    }
  }

  render_turbo(url, load = false) {
    this.loadingTarget.style.display = 'flex'
    fetch(url, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
      })
      .then(r => r.text())
      .then(html => {
        console.log("turbo return", html);
        if ( html == 0 ) {
          if ( load ) {
            this.stalled = true
          }
          else {
            console.log("No hay resultados", '#'+this.current_tab+' > turbo-frame');
            document.querySelector('#'+this.current_tab+' > turbo-frame').innerHTML = "No hay resultados para la búsqueda"
          }
        }
        else {
          Turbo.renderStreamMessage(html)
        }
        this.loading = false
        this.loadingTarget.style.display = 'none'
      })
  }
}
