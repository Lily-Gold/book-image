// app/javascript/controllers/chart_controller.js
import { Controller } from "@hotwired/stimulus";
import Chart from "chart.js/auto";

export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    labels: Array,
    counts: Array,
    colors: Array,
  };

  connect() {
    if (!this.hasLabelsValue || this.countsValue.length === 0) return;

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
        plugins: {
          legend: { display: false },
        },
      },
    });
  }

  disconnect() {
    this.chart?.destroy();
  }
}
