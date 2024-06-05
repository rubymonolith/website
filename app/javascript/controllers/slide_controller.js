// app/javascript/controllers/slide_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { next: String, previous: String }

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this);
    document.addEventListener("keydown", this.handleKeydown);
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown);
  }

  handleKeydown(event) {
    if (event.key === "ArrowRight") {
      this.goToNextSlide();
    } else if (event.key === "ArrowLeft") {
      this.goToPreviousSlide();
    }
  }

  goToNextSlide() {
    if (this.nextValue) {
      Turbo.visit(this.nextValue, { action: "replace" });
    }
  }

  goToPreviousSlide() {
    if (this.previousValue) {
      Turbo.visit(this.previousValue, { action: "replace" });
    }
  }
}
