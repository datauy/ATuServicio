import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ['filter1', 'filter2', 'loading']
  
  static loading
  static page
  static stalled
  static writting
  static lastSearch

  connect() {
    this.current_tab = 'tab-prestadores'
    this.loading = false
    this.page = 0
    this.stalled = false
    this.writting = false
    this.lastSearch = ''
    this.render_turbo('/sites')
    this.render_turbo('/infra')
    window.addEventListener('scroll', () => {
      let inner = document.getElementById(this.current_tab)
      if ( this.loading == false && (inner.offsetTop + inner.offsetHeight - window.innerHeight < window.scrollY) ) {
        console.log("SCROLLING LOAD", this.stalled );
        this.more()
      }
    })
  }
  
  switch_tab(e) {
    this.stalled = false
    this.page = 0
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
    tab.style.display = 'flex'
  }
  
  more() {
    if ( this.stalled == false ) {
      this.page += 1
      this.search(null, true)
    }
  }
  searchWrite() {
    if ( this.lastSearch != this.filter1Target.value ) {
      this.lastSearch = this.filter1Target.value
      if ( this.writting ) {
        this.writting.cancel();
      }
      this.writting = this.timeout(1500)
      this.writting.promise.then(() => {
        this.search()
      })
    }
  }
  search(e, load = false) {
    let url = 0
    if ( !this.loading && ( this.filter1Target.value.length > 2 || this.filter1Target.value.length == 0 || this.filter2Target.value != 0 || load )) {
      this.loading = true
      if ( !load ) {
        this.page = 0
      }
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
        _paq.push(['trackSiteSearch', this.filter1Target.value, this.current_tab+'-name', 0])
      }
      if ( this.filter2Target.value > 0) {
        url.searchParams.append('state', this.filter2Target.value)
        _paq.push(['trackSiteSearch', this.filter2Target.value, this.current_tab+'-state', 0])
      }
      this.render_turbo(url, load)
    }
  }

  timeout(ms) {
    var timeout, promise;

    promise = new Promise(function(resolve, reject) {
      timeout = setTimeout(function() {
        resolve('timeout done');
      }, ms)
    })
    return { promise:promise, cancel:function(){clearTimeout(timeout )} }
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
