import { createApp } from "vue";
import TodoWidget from "../widgets/TodoWidget.vue";

document.addEventListener("DOMContentLoaded", () => {
  const element = document.querySelector("[data-vue-widget]");
  if (!element) return;

  const items = JSON.parse(element.dataset.items || "[]");
  createApp(TodoWidget, { items }).mount(element);
});
