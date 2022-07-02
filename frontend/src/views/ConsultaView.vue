<template>
  <div class="home">
    <h2>Consultas</h2>
    <button @click.prevent="cambiarConsulta('consulta1')">Consulta1</button>
    <button @click.prevent="cambiarConsulta('consulta2')">Consulta2</button>
    <button @click.prevent="cambiarConsulta('consulta3')">Consulta3</button>
    <div v-if="nombre">
      <Recurso :nombre="nombre" />
    </div>
  </div>
</template>

<script>
import Recurso from "@/components/Recurso.vue";
export default {
  data() {
    return {
      nombre: null,
    };
  },
  components: {
    Recurso,
  },
  methods: {
    cambiarConsulta(consulta) {
      this.nombre = consulta;
    },
  },
};
</script>

<style>
.home {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
