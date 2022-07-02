<template>
  <div class="main">
    <h1>COMERCIAL JESSICA</h1>
    <nav>
      <router-link to="/recurso">Consultar recurso</router-link> ||
      <router-link to="/consulta">Consultas frecuentes</router-link>
    </nav>
    <router-view />
  </div>
</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 30px;
  background-color: transparent;
}

.main {
  margin-top: 40px;
}
</style>
