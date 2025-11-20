// profile_tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switch(event) {
    const index = event.currentTarget.dataset.index

    this.tabTargets.forEach((tab, i) => {
      if (i == index) {
        tab.classList.add(
          "bg-[#004865]",
          "text-white",
          "font-medium"
        )
        tab.classList.remove(
          "bg-white",
          "text-gray-600",
          "font-normal"
        )
      } else {
        tab.classList.remove(
          "bg-[#004865]",
          "text-white",
          "font-medium"
        )
        tab.classList.add(
          "bg-white",
          "text-gray-600",
          "font-normal"
        )
      }
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i != index)
    })
  }
}
