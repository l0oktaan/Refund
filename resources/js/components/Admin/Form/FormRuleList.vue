<template>
    <div class="animated fadeIn">
        <b-row class="justify-content-md-center">

             <b-col cols="8">
                 <b-card>
                     <div slot="header" class="navbar">
                         <ul class="nav navbar-nav d-md-down-none">
                            <li class="nav-item px-3">
                                <i class='fa fa-align-justify'></i>
                                    หลักเกณฑ์เงื่อนไข
                            </li>
                        </ul>
                        <ul class="nav navbar-nav ml-auto">
                            <li class="nav-item px-3">
                                <b-button variant="outline-success" @click="addRule">
                                    <i class="fas fa-plus-circle fa-2x"></i>&nbsp;<span>เพิ่มหลักเกณฑ์</span>
                                </b-button>
                            </li>
                        </ul>
                    </div>
                    <rule-cover
                        ref="cover"
                        v-for="rule in rules" :key="rule.id"
                        :rule="rule"
                        :rules="rules"
                        :form_id="form_id"
                        @editRule="editRule2"
                        @addSubRule="addSubRule"
                        @fetchRule="fetchData"
                    >
                    </rule-cover>

                 </b-card>
            </b-col>
        </b-row>


    </div>
</template>
<script>
import {mapActions} from 'vuex'
export default {
    props : ['form_id','rules'],
    data() {
      return {
        // Note `isActive` is left out and will not appear in the rendered table
        tableFileds: [
            {key:'order', label: 'ลำดับ'},
            {key:'name' ,label: 'ชื่อเกณฑ์'},
            {key:'manage', label:'จัดการ'},
            {key:'condition', label:'เงื่อนไข'}
        ],

        items: [],

        rule: {},
        fid: 0,
        rule_id: -1,
        sub_of: 0,

        sub_rules:[],
        showRule: [],
        state: 'new'

      }
    },
    mounted(){
        // this.rules = [];
        // this.fid = this.form_id;
        //     if (this.fid > 0){
        //         this.fetchData();
        //         //this.getSubRule();

        //     }else{
        //         this.clearData();
        //     }
    },


    computed: {

    },
    methods: {
        ...mapActions([
            'fetch_form'
        ]),
        fetchData(){
            this.fetch_form;

            this.$emit('toRefresh');
            this.$forceUpdate();
        },


        showDetail(row){
            row._showDetails = "true";
        },
        clearData(){
            this.fid = -1;
            this.rules = [];
        },
        editRule2(rule_id){
            // this.rule_id = edit_rule.id;
            // this.sub_of = edit_rule.sub_of;
            this.state = "edit"
            this.rule_id = rule_id;
            this.$refs['modalRule'].show();
        },
        addRule(){
            this.rule_id = 0;
            this.$refs.cover.modalRule.show();
        },
        addSubRule(sub_of){
            this.rule_id = 0;
            this.sub_of = sub_of;
            this.$refs['modalRule'].show();
        },
        resetModalRule(){
            this.rule_id = -1;
            this.sub_of = 0;
            this.fetchData();
        },
        isSingleRule(id){
            var path = `/api/forms/${this.form_id}/form_rules?sub_of=${id}`;
            var rules = [];
            axios.get(path)
            .then(response=>{
                rules = response.data.data;

                if (rules.length == 0){
                    console.log('rule id :' + id + 'is single');
                    return true;
                }else{
                    return false;
                }
            })
        }
    }
}
</script>
<style scoped>
.card-body{
    padding: 0px!important;
}
.btn{
    padding-top: 5px!important;
    padding-bottom: 5px!important;
    vertical-align: middle!important;
}
i{
    vertical-align: middle!important;
}
.card-header{
    padding: 5px!important;
}
</style>
