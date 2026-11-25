import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="compare"
export default class extends Controller {
  static targets = ["bar"]
  static values = { provider: Number, ctype: String, pids: [] }

  static lastSearch
  static lastFilter

  initialize() {
    this.providers = [];
    document.querySelectorAll('.provider-selector').forEach(ps => {
      ps.checked = false
    })
  }
  connect() {
    this.lastFilter = ''
    this.lastSearch = ''
    if (this.hasPidsValue) {
      this.providers = this.pidsValue
    }
  }

  searchProvider(e) {
    if (e.target.value.length > 2) {
      _paq.push(['trackSiteSearch', e.target.value, 'search-provider', 1])
      console.log("SP", _paq);
      
      fetch('/proveedor/?name='+e.target.value, {
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

  searchWrite(e) {
    if ( ( e.target.name == 'provider' && this.lastSearch != e.target.value ) || this.lastFilter != e.target.value ) {
      if ( this.writting ) {
        this.writting.cancel();
      }
      this.writting = this.timeout(1500)
      this.writting.promise.then(() => {
        if ( e.target.name == 'provider' ) {
          this.lastSearch = e.target.value
          this.searchProvider(e)
        }
        else {
          this.lastFilter = e.target.value
          this.filterList(e)
        }
      })
    }
  }

  filterList(e) {
    if ( e.target.value.length > 2 ) {
      _paq.push(['trackSiteSearch', e.target.value, 'filter-list', 1])
      console.log("FL", _paq);
      let val = e.target.value.toLowerCase().normalize('NFD').replace(/\p{Diacritic}/gu, '')
      document.querySelectorAll('.item.label').forEach(i => {
        if (i.innerHTML.toLowerCase().normalize('NFD').replace(/\p{Diacritic}/gu, '').includes(val) ) {
          i.parentNode.style.display = "grid"
          let section = i.closest('.section')
          if ( section.querySelector('.arrow').ariaExpanded == "false" ) {
            section.querySelector('.arrow').ariaExpanded = 'true'
            section.querySelector('.section-content').style.display = 'flex'
          }
        }
        else {
          i.parentNode.style.display = "none"
        }
      })
    }
    else {
      this.clearFiters();
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
  clearFiters() {
    document.querySelectorAll('.section-inner-content .row').forEach( r => {
      r.style.display = "grid"
    })
  }

  addProvider(e) {
    // Add/Remove from array
    let summary = document.getElementById('provider-summary-'+e.target.value)
    if ( e.target.checked ) {
      if ( this.providers.length < 3 ) {
        this.barTarget.style.display = 'flex'
        this.providers.push(e.target.value)
        if ( summary != null ) {
          summary.classList.add('active')
        }
        // Get provider data
        fetch('/proveedor/resumen/'+e.target.value, {
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
      else {
        alert("Máximo de 3 proveedores autorizados")
      }
    }
    else {
      if ( summary != null ) {
        summary.classList.remove('active')
      }
      this.removeProvider(e)
    }
  }
  //
  removeProvider(e) {
    let pid = e.target.value
    if ( this.removeFromList(pid) ) {
      //Remove from display
      document.getElementById("compare-"+pid).remove()
      document.getElementById("provider-selector-"+pid).checked = false
    }
    if ( this.providers.length == 0 ) {
      this.barTarget.style.display = 'none'
    }
  }
  //
  removeFromCompare(e) {
    if ( this.removeFromList(e.target.value) ) {
      this.submit()
    }
  }
  //
  removeFromList(pid) {
    let pi = this.providers.indexOf(pid)
    if ( pi > -1 ) {
      this.providers.splice(pi, 1)
      return true
    }
    return false
  }
  //
  submitWithProvider(e) {
    if ( this.providers.length < 3 ) {
      _paq.push(['trackEvent', 'Provider', 'click', e.target.value]);
      this.providers.push(e.target.value)
      this.submit()
    }
    else {
      alert("Máximo de 3 proveedores autorizados")
    }
  }
  //
  submit() {
    let url = "/comparar/"+this.providers.join("/")
    window.location.replace(url)
  }
  state(e) {
    console.log("Change STATE ", e.target, this.providers);
    let url = '/proveedores/get_state_data?providers='+this.providers.join(',')
    if (e.target.value) {
      url += '&departamento='+e.target.value
    }
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
