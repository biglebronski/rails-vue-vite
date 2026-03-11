<script setup>
import { computed, onMounted, ref } from "vue";

const todos = ref([]);
const title = ref("");
const saving = ref(false);
const deletingIds = ref([]);
const loading = ref(true);

const remainingCount = computed(() => todos.value.filter((todo) => !todo.completed).length);

async function loadTodos() {
  loading.value = true;

  const response = await fetch("/api/todos");
  const payload = await response.json();
  todos.value = payload.todos;
  loading.value = false;
}

async function addTodo() {
  const trimmed = title.value.trim();
  if (!trimmed) return;

  saving.value = true;

  const response = await fetch("/api/todos", {
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

async function deleteTodo(id) {
  deletingIds.value.push(id);

  await fetch(`/api/todos/${id}`, {
    method: "DELETE",
    headers: {
      Accept: "application/json",
    },
  });

  todos.value = todos.value.filter((todo) => todo.id !== id);
  deletingIds.value = deletingIds.value.filter((value) => value !== id);
}

onMounted(loadTodos);
</script>

<template>
  <section class="card">
    <div class="card-header">
      <div>
        <p class="label">List manager</p>
        <h2>Todos</h2>
      </div>
      <p class="meta">{{ remainingCount }} open item<span v-if="remainingCount !== 1">s</span></p>
    </div>

    <form class="todo-form" @submit.prevent="addTodo">
      <input v-model="title" type="text" placeholder="Add a new task" />
      <button type="submit" :disabled="saving">{{ saving ? "Saving..." : "Add todo" }}</button>
    </form>

    <p v-if="loading">Loading todos...</p>

    <ul v-else class="todo-list">
      <li v-for="todo in todos" :key="todo.id">
        <span>{{ todo.title }}</span>
        <button
          type="button"
          class="delete-button"
          :disabled="deletingIds.includes(todo.id)"
          @click="deleteTodo(todo.id)"
        >
          {{ deletingIds.includes(todo.id) ? "Removing..." : "Delete" }}
        </button>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.card {
  padding: 1.5rem;
  border-radius: 1.5rem;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 20px 60px rgba(34, 52, 43, 0.08);
}

.card-header {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: end;
}

.label,
.meta {
  margin: 0;
  color: #5d655d;
}

h2 {
  margin: 0.3rem 0 0;
}

.todo-form {
  display: flex;
  gap: 0.75rem;
  margin-top: 1.5rem;
}

input,
button {
  font: inherit;
}

input {
  flex: 1;
  padding: 0.85rem 1rem;
  border-radius: 0.9rem;
  border: 1px solid rgba(29, 29, 27, 0.14);
  background: #fffdfa;
}

button {
  padding: 0.85rem 1.1rem;
  border: 0;
  border-radius: 0.9rem;
  background: #1d1d1b;
  color: #fffdf8;
}

.todo-list {
  margin: 1.25rem 0 0;
  padding: 0;
  list-style: none;
  display: grid;
  gap: 0.75rem;
}

.todo-list li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 0.9rem 1rem;
  border-radius: 1rem;
  background: #f4efe3;
}

.delete-button {
  padding: 0.55rem 0.8rem;
  border: 1px solid rgba(29, 29, 27, 0.12);
  border-radius: 999px;
  background: #fffdfa;
  color: #8a2f2f;
}
</style>
