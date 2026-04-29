import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site"
export default class extends Controller {
  static values = { site: Number, level: String }
  static targets = ["button", "modal"]

  connect() {
  }

  toggleModal(e) {
    if ( this.buttonTarget.ariaExpanded == "true" ) {
      closeModal()
    }
    else {
      //Get data
      //console.log();
      let url = '/site-data/' + this.siteValue +'?level='+ this.levelValue
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
  closeModal() {
    document.querySelectorAll('button.level[aria-expanded="true"]').forEach(b => {
      b.ariaExpanded = false
    });
    document.getElementById('site-backdrop').style.display = "none"
  }

}
