import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.onTurboLoad = this.onTurboLoad.bind(this)
    document.addEventListener("turbo:load", this.onTurboLoad)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.onTurboLoad)
  }

  onTurboLoad() {
    const savedIndex = localStorage.getItem("profileTabIndex")
    const index = savedIndex !== null ? Number(savedIndex) : 0

    this.activate(index)
  }

  switch(event) {
    const index = Number(event.currentTarget.dataset.index)
    localStorage.setItem("profileTabIndex", index)
    this.activate(index)
  }

  activate(index) {
    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("bg-[#004865]", "text-white", "font-medium")
        tab.classList.remove("bg-white", "text-gray-600", "font-normal")
      } else {
        tab.classList.remove("bg-[#004865]", "text-white", "font-medium")
        tab.classList.add("bg-white", "text-gray-600", "font-normal")
      }
    })

    this.panelTargets.forEach((panel, i) => {
      const isActive = i === index
      panel.classList.toggle("hidden", !isActive)

      if (!isActive) return

      const chartElement = panel.querySelector('[data-controller="chart"]')
      if (!chartElement) return

      const chartController =
        this.application.getControllerForElementAndIdentifier(
          chartElement,
          "chart"
        )

      if (!chartController) return

      requestAnimationFrame(() => {
        chartController.renderIfNeeded()
      })
    })
  }
}
