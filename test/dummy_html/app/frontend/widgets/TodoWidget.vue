<script setup>
import { ref } from "vue";

const props = defineProps({
  items: {
    type: Array,
    default: () => [],
  },
});

const todos = ref([...props.items]);
const title = ref("");
const saving = ref(false);
const deletingIds = ref([]);

async function addTodo() {
  const trimmed = title.value.trim();
  if (!trimmed) return;

  saving.value = true;

  const response = await fetch("/api/widget_todos", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ title: trimmed }),
  });

  const payload = await response.json();
  todos.value.push(payload.todo);
  title.value = "";
  saving.value = false;
}

async function deleteTodo(todoToDelete) {
  deletingIds.value.push(todoToDelete.id);

  await fetch(`/api/widget_todos/${todoToDelete.id}`, {
    method: "DELETE",
    headers: {
      Accept: "application/json",
    },
  });

  todos.value = todos.value.filter((todo) => todo.id !== todoToDelete.id);
  deletingIds.value = deletingIds.value.filter((id) => id !== todoToDelete.id);
}
</script>

<template>
  <section class="widget">
    <p class="eyebrow">Vue island</p>
    <h2>Embedded todo widget</h2>
    <form class="widget-form" @submit.prevent="addTodo">
      <input v-model="title" type="text" placeholder="Add an item" />
      <button type="submit" :disabled="saving">{{ saving ? "Saving..." : "Add" }}</button>
    </form>

    <ul>
      <li v-for="todo in todos" :key="todo.id">
        <span>{{ todo.title }}</span>
        <button
          type="button"
          class="delete-button"
          :disabled="deletingIds.includes(todo.id)"
          @click="deleteTodo(todo)"
        >
          {{ deletingIds.includes(todo.id) ? "Deleting..." : "Delete" }}
        </button>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.widget {
  margin-top: 2rem;
  max-width: 42rem;
  padding: 1.5rem;
  border: 1px solid rgba(15, 23, 42, 0.08);
  border-radius: 1.25rem;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 60px rgba(15, 23, 42, 0.08);
  font-family: "Avenir Next", "Segoe UI", "Helvetica Neue", Arial, sans-serif;
}

.eyebrow {
  margin: 0;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: #4b5563;
}

h2 {
  margin-top: 0.4rem;
}

.widget-form {
  display: flex;
  gap: 0.75rem;
  margin-top: 1rem;
}

input,
button {
  font: inherit;
}

input {
  flex: 1;
  padding: 0.8rem 0.95rem;
  border: 1px solid rgba(15, 23, 42, 0.12);
  border-radius: 0.85rem;
  background: #ffffff;
}

button {
  padding: 0.8rem 0.95rem;
  border: 0;
  border-radius: 0.85rem;
  background: #0f172a;
  color: #f8fafc;
}

ul {
  margin: 1rem 0 0;
  padding: 0;
  list-style: none;
  display: grid;
  gap: 0.75rem;
}

li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 0.85rem 1rem;
  border-radius: 1rem;
  background: #eff6ff;
}

.delete-button {
  background: #ffffff;
  color: #991b1b;
  border: 1px solid rgba(153, 27, 27, 0.12);
}
</style>
