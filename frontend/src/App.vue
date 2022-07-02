<template>
  <div>
    <nav>
      <router-link to="/">Hogar</router-link> ||
      <router-link to="/recurso">Recurso</router-link> ||
      <router-link to="/consulta">Consulta</router-link>
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
</style>
