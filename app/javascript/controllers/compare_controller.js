import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="compare"
export default class extends Controller {
  static targets = ["bar"]
  static values = { provider: Number }

  initialize() {
    this.providers = [];
    document.querySelectorAll('.provider-selector').forEach(ps => {
      ps.checked = false
    })
  }
  connect() {
    console.log("CONNECT COMPARE");
    
  }

  searchProvider(e) {
    console.log("SEARCH PROVIDER", e);
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

  filterList(e) {
    console.log("FILTER LIST", e);
  }

  addProvider(e) {
    // Add/Remove from array
    if ( e.target.checked ) {
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
      this.removeProvider(e)
    }
  }
  removeProvider(e) {
    let pid = e.target.value 
    let pi = this.providers.indexOf(pid)
    if ( pi > -1 ) {
      this.providers.splice(pi, 1)
      //Remove from display
      document.getElementById("compare-"+pid).remove()
      document.getElementById("provider-selector-"+pid).checked = false
    }
    if ( this.providers.length == 0 ) {
      this.barTarget.style.display = 'none'
    }
  }
  submit() {
    let url = "comparar/"+this.providers.join("/")
    window.location.replace(url)
  }
}
