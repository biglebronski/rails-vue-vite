<template>
  <div class="shell">
    <header class="masthead">
      <p class="eyebrow">rails_vue_vite demo</p>
      <h1>Todo SPA</h1>
      <p class="dek">Vue Router owns navigation after the first Rails response.</p>
      <nav class="nav">
        <RouterLink to="/">Todos</RouterLink>
        <RouterLink to="/about">About</RouterLink>
      </nav>
    </header>

    <main class="content">
      <RouterView />
    </main>

    <footer class="footer">
      Rails serves the shell. Vue owns layout and navigation. JSON lives under <code>/api</code>.
    </footer>
  </div>
</template>

<style scoped>
.shell {
  min-height: 100vh;
  padding: 3rem 1.5rem;
  background:
    radial-gradient(circle at top, rgba(32, 178, 170, 0.18), transparent 35%),
    linear-gradient(180deg, #fffdf8 0%, #f4efe3 100%);
  color: #1d1d1b;
  font-family: "Avenir Next", "Segoe UI", "Helvetica Neue", Arial, sans-serif;
}

.masthead,
.content,
.footer {
  width: min(48rem, 100%);
  margin: 0 auto;
}

.eyebrow {
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.18em;
  font-size: 0.72rem;
  color: #12665a;
}

h1 {
  margin: 0.35rem 0 0;
  font-size: clamp(2.25rem, 5vw, 4rem);
  line-height: 0.95;
}

.dek {
  max-width: 40rem;
  font-size: 1.05rem;
}

.nav {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

.nav a {
  padding: 0.65rem 1rem;
  border: 1px solid rgba(18, 102, 90, 0.24);
  border-radius: 999px;
  color: #1d1d1b;
  text-decoration: none;
  background: rgba(255, 255, 255, 0.7);
}

.nav a.router-link-active {
  background: #12665a;
  color: #fffdf8;
}

.content {
  margin-top: 2rem;
}

.footer {
  margin-top: 3rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(29, 29, 27, 0.12);
  font-size: 0.95rem;
}
</style>
