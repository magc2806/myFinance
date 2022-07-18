import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  connect() {
    console.log("hello")
    this.modal = new bootstrap.Modal(this.element)
    console.log(this.modal)
    this.modal.show()
  }

  disconect(){
    this.modal.hide()
  }
  submitEnd(e){
    console.log(e)
  }
}
