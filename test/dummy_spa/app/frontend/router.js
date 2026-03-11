import { createRouter, createWebHistory } from "vue-router";
import AboutPage from "./views/AboutPage.vue";
import TodosPage from "./views/TodosPage.vue";

const routes = [
  {
    path: "/",
    name: "todos",
    component: TodosPage,
  },
  {
    path: "/about",
    name: "about",
    component: AboutPage,
  },
];

export default createRouter({
  history: createWebHistory(),
  routes,
});
