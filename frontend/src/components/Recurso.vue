<template>
    <div v-if="recursos">
        <h1>Recurso: {{ nombre }}</h1>
        <table class="styled-table">
        <thead>
            <th v-for="titulo in titulos" :key="titulo">{{ titulo }}</th>
        </thead>
        <tbody>
            <tr v-for="(objeto,index) in recursos" :key="index">
                <td v-for="(valor,index2) in objeto" :key="index2">{{ valor }}</td>
            </tr>
        </tbody>
        </table>
    </div>
</template>

<script>
export default {
    name: "Recurso",
    props: {
        nombre: {
            type: String,
            required: true
        },
    },
    data() {
        return {
            recursos: null,
            titulos: null,
        }
    },
    methods: {
        getData() {
            fetch("http://127.0.0.1:5000/" + this.nombre, {
                method: "GET",
                headers: {
                    "Content-Type" : "application/json",
                },
            }).then(res => res.json()).then(resJson => {
                this.recursos = resJson['recurso'];
                this.titulos = resJson['titulos'];
            });
        }
    },
    mounted() {
        this.getData();
    },
    watch: {
        nombre: function(newVal, oldVal) {
            this.getData();
        }
    }
};
</script>