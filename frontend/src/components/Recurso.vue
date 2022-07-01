<template>
    <div>

    </div>
</template>

<script>
export default {
    props: {
        nombre: String,
    },
    data() {
        recursoData = {}
    },
    methods: {
        getData() {
            fetch("http://127.0.0.1:5000/" + this.nombre, {
                method: "GET",
                headers: {
                    "Content-Type" : "application/json",
                },
            }).then(res => res.json()).then(function (resJson) {
                this.recursoData = resJson;
                console.log(resJson);
            });
        }
    }
}
</script>