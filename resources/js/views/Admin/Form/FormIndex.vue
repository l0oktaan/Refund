<template>
    <div class="animated fadeIn">
        <div class="text-right">
            <router-link to="/admin/forms/add">
                <b-button variant="outline-success">
                <i class="fas fa-plus-circle fa-2x"></i>&nbsp;<span>เพิ่มแบบฟอร์ม</span>
            </b-button>
            </router-link>

            <b-button variant="outline-primary">
                <i class="fas fa-search fa-2x"></i>&nbsp;<span>ค้นหา</span>
            </b-button>

        </div>
        <h2>รายการแบบฟอร์ม</h2>
        <p>{{fCount}}</p>
        <b-row>
            <form-cover @onShowForm = "showForm"
                v-for = "form in forms"
                :key = "form.id"
                :form_id = "form.id"
                :name1 = "form.name1"
                :name3 = "form.name3"
                :order = "form.order"
                @fetchForm = "fetchData"

            ></form-cover>
        </b-row>
        <b-modal id="modalForm"
            ref="modalForm"
            size="xl"
            hide-header hideFooter
            no-close-on-backdrop
            no-close-on-esc
            @hidden="resetModalForm"
            >
            <!-- <form-detail
                :form_id = "form_id"
                :fCount = "fCount"
            ></form-detail> -->
        </b-modal>
        <b-modal id="modalRule"
            ref="modalRule"
            size="lg"
            @hide-header="true" hideFooter
            no-close-on-backdrop
            no-close-on-esc>
            <h2>Modal Rule</h2>
        </b-modal>
    </div>

</template>
<script>
import {mapActions} from 'vuex'
export default {
    data(){
        return{
            id: 1,
            form_id: -1,
            forms : [],
            fCount: 0
        }
    },
    methods: {
        ...mapActions([
            'fetch_form'
        ]),
        showForm(id){
            //console.log('show :' + id);
            //this.form_id = id;
            //this.$refs['modalForm'].show();
            this.$router.push({name: 'edit',params: { id: id }})  ;
        },
        resetModalForm(){
            this.form_id = -1;
            this.fetchData();
        },
        fetchData(){
            console.log('EMIT')
            this.fetch_form();
            this.forms = this.$store.state.forms;
            // axios.get('/api/forms')
            // .then(response=>{
            //     this.forms = response.data.data;
            //     this.fCount = this.forms.length;
            //     this.$store.commit('SET_FORMS',this.forms);
            //     console.log(this.forms);
            // })
        }
    },
    mounted(){
        this.fetchData();
    }
}
</script>
<style scoped>
.btnAdd{
    border-radius: 50%;
    width: 45px;
    height: 45px;
    padding: 0px;
    vertical-align: middle;
}
.btn{
    padding-top: 15px!important;
    padding-bottom: 15px!important;
}
i{
    vertical-align: middle!important;
}
</style>
