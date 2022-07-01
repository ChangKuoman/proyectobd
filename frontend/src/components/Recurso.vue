<template>
    <div>
        <h1>Recurso</h1>
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
            info: ""
        }
    },
    methods: {
        async getData() {
            await fetch("http://127.0.0.1:5000/" + this.nombre, {
                method: "GET",
                headers: {
                    "Content-Type" : "application/json",
                },
            }).then(res => res.json()).then(function (resJson) {
                console.log(resJson);
                this.info = "hola";
                console.log(this.info);
                
            });
        }
    },
    mounted() {
        this.getData();
    }
};
</script>