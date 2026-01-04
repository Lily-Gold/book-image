// app/javascript/controllers/profile_tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // 保存されてたタブ index（なければ 0）
    const savedIndex = localStorage.getItem("profileTabIndex")
    const index = savedIndex !== null ? Number(savedIndex) : 0

    this.activate(index)
  }

  switch(event) {
    const index = Number(event.currentTarget.dataset.index)

    // タブ位置を保存
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
      panel.classList.toggle("hidden", i !== index)
    })
  }
}
