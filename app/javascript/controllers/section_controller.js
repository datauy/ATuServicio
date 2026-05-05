import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="section"
export default class extends Controller {
  static values = { section: Number, question: Number, id: Number, position: Number}
  static targets = ["expand", "content", "infotrigger", "infopanel"]

  connect() {
  }

  toggleInfo() {
    if ( this.infotriggerTarget.ariaExpanded == "true" ) {
      this.infotriggerTarget.ariaExpanded = false
      this.infopanelTarget.style.display = 'none'
    }
    else {
      this.infotriggerTarget.ariaExpanded = true
      this.infopanelTarget.style.display = 'flex'
    }
  }
  toggleVisibility() {
    if ( this.expandTarget.ariaExpanded == "true" ) {
      this.expandTarget.ariaExpanded = false
      this.contentTarget.style.display = 'none'
    }
    else {
      this.expandTarget.ariaExpanded = true
      this.contentTarget.style.display = 'flex'
    }
  }
}
