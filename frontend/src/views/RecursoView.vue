<template>
    <div class="home">
    <button v-for="(tabla,index) in tablas" :key="index" @click.prevent="cambiarNombre(tabla)">{{ tabla }}</button>
    <div v-if="nombre">
        <Recurso :nombre="nombre"/>
    </div>
  </div>
</template>


<script>
import Recurso from "@/components/Recurso.vue"
export default {
    name: "RecursoView",
    components: {
        Recurso,
    },
    data() {
        return {
            tablas: null,
            nombre: null,
        }
    },
    mounted() {
        fetch("http://127.0.0.1:5000/tablas", {
            method: "GET",
            headers: {
                "Content-Type" : "application/json",
            },
        }).then(res => res.json()).then(resJson => {
            this.tablas = resJson['recurso'];
        });
    },
    methods: {
        cambiarNombre(nombre) {
            this.nombre = nombre;
        }
    }
};
</script>

<style>

</style>