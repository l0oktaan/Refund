<template>
    <div class="animated fadeIn">
        <form-detail :form_id="form_id"></form-detail>

        <form-rule-list :form_id="form_id" :rules="rules" @toRefresh="fetchData"></form-rule-list>
    </div>
</template>

<script>
import {mapActions} from 'vuex'
export default {

    data(){
        return {
            form_id: this.$route.params.id,
            forms: [],
            rules: []
        }
    },
    mounted(){
        this.fetchData();
    },

    methods: {
        ...mapActions([
            'fetch_form'
        ]),
        fetchData(){
            this.fetch_form();
            this.forms = this.$store.state.forms;
            this.rules = this.forms[this.forms.findIndex(i => i.id == this.form_id)]['rules'];
            this.$forceUpdate();
        }
    }
}
</script>

<style>

</style>
