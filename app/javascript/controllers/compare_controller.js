import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="compare"
export default class extends Controller {
  connect() {
  }

  searchProvider(e) {
    console.log("SEARCH PROVIDER", e);
    fetch('/provider/get-provider/?name='+e.target.value, {
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
}
