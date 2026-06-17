import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site"
export default class extends Controller {
  static values = { site: Number, level: String, provider: Number, state: Number }
  static targets = ["button"]

  connect() {
  }

  toggleModal(e) {
    if ( this.buttonTarget.ariaExpanded == "true" ) {
      closeModal()
    }
    else {
      //Get data
      //console.log();
      let url = '/site/' + this.siteValue +'/data?level='+ this.levelValue
      this.fetchContent(url)
    }
  }
  closeModal() {
    document.querySelectorAll('button.level[aria-expanded="true"]').forEach(b => {
      b.ariaExpanded = false
    });
    document.getElementById('site-backdrop').style.display = "none"
  }

  getSites() {
    let url = '/sites/' + this.providerValue +'/'+ this.stateValue
    this.fetchContent(url)
  }

  fetchContent(url) {
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
      this.buttonTarget.ariaExpanded = true
      document.getElementById('site-backdrop').style.display = 'flex'
  }

}
