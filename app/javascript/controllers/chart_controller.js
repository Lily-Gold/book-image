import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    labels: Array,
    counts: Array,
    colors: Array,
  }

  connect() {
    this.beforeCache = this.beforeCache.bind(this)
    document.addEventListener("turbo:before-cache", this.beforeCache)
  }

  renderIfNeeded() {
    if (this.chart) return

    this.chart = new Chart(this.canvasTarget, {
      type: "pie",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            data: this.countsValue,
            backgroundColor: this.colorsValue,
          },
        ],
      },
      options: {
        responsive: true,
        animation: {
          duration: 800,
          animateRotate: true,
        },
        plugins: {
          legend: { display: false },
        },
      },
    })
  }

  beforeCache() {
    this.chart?.destroy()
    this.chart = null
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.beforeCache)
    this.chart?.destroy()
    this.chart = null
  }
}
