<template>
  <section class="card">
    <p class="label">About this demo</p>
    <h2>Client-side routing, Rails-backed data</h2>
    <p>
      Rails only serves the initial HTML shell and JSON endpoints under <code>/api</code>.
      After boot, Vue Router handles navigation between routes like <code>/</code> and <code>/about</code>.
    </p>
    <p>
      This is the recommended SPA boundary for <code>rails_vue_vite</code>: keep Rails focused on APIs and the initial shell,
      and let Vue own the page body.
    </p>
  </section>
</template>

<style scoped>
.card {
  padding: 1.5rem;
  border-radius: 1.5rem;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 20px 60px rgba(34, 52, 43, 0.08);
}

.label {
  margin: 0;
  color: #5d655d;
}

h2 {
  margin-top: 0.4rem;
}

p {
  line-height: 1.6;
}
</style>
