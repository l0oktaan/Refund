<template>
    <form-detail
        :form_id="0"
        @toEdit = "toEdit"
    ></form-detail>
</template>

<script>
export default {

    data(){
        return {
            form_id: this.$route.params.id,
        }
    },
    mounted(){

    },

    methods: {
        toEdit(id){
            console.log('to edit :' + id);
            this.$router.push({ name: 'index'});
        }
    }
}
</script>

<style>

</style>
