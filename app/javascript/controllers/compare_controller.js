import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="compare"
export default class extends Controller {
  static targets = ["bar"]
  static values = { provider: Number, ctype: String, pids: [] }

  initialize() {
    this.providers = [];
    document.querySelectorAll('.provider-selector').forEach(ps => {
      ps.checked = false
    })
  }
  connect() {
    if (this.hasPidsValue) {
      this.providers = this.pidsValue
    }
  }

  searchProvider(e) {
    console.log("SEARCH PROVIDER", e);
    if (e.target.value.length > 2) {
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

  filterList(e) {
    if ( e.target.value.length > 2 ) {
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
  }

  addProvider(e) {
    // Add/Remove from array
    if ( e.target.checked ) {
      if ( this.providers.length < 3 ) {
        this.barTarget.style.display = 'flex'
        this.providers.push(e.target.value)
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
      this.removeProvider(e)
    }
  }
  //
  removeProvider(e) {
    if ( this.removeFromList(e.target.value) ) {
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
}
