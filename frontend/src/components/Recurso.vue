<template>
    <div v-if="recursos">
        <h1>Recurso</h1>
        <table class="styled-table">
        <thead>
            <tr>
                <td v-for="titulo in recursos[0]">{{ titulo }}</td>
            </tr>
        </thead>
        <tbody>
            <!-- {% for objeto in objetos %}
                <tr>
                    {% for i in range(20) %}
                    {% if objeto[i] %}
                    <td>{{ objeto[i] }}</td>
                    {% endif %}
                    {% endfor %}
                </tr>
            {% endfor %} -->
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
            recursos: null
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
                this.recursos = resJson;
            });
        }
    },
    mounted() {
        this.getData();
    }
};
</script>