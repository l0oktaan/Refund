<template>
    <div class="animated fadeIn">
        <b-row>
             <b-col>
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
                        v-for="rule in showRule"
                        :key="rule.id"
                        :rule="rule"
                        :form_id="form_id"
                        @editRule="editRule2"
                        @addSubRule="addSubRule"
                        @fetchRule="fetchData"
                    >
                    </rule-cover>
                    
                    <!--b-table striped hover :items="rules" :fields="tableFileds">
                        <template slot="index" slot-scope="data">
                            {{ data.index + 1 }}
                        </template>
                        <template slot="show_details" slot-scope="row">
                            <b-button size="sm" @click="row.toggleDetails" class="mr-2">
                            {{ row.detailsShowing ? 'Hide' : 'Show'}} Details
                            </b-button>




                        </template>

                        <template slot="manage" slot-scope="data">
                            <div>
                                <b-button variant="success" class="btn-square btn-sm" @click="editRule(data.item.id)"><i class="fas fa-edit"></i></b-button>
                                <b-button variant="danger" class="btn-square btn-sm"><i class="fas fa-trash"></i></b-button>
                            </div>
                        </template>
                        <template slot="condition" slot-scope="data">
                            <b-button block variant="primary" class="btn-square btn-sm" v-if="data.item.rule_type!=1"><i class="far fa-check-circle"></i>&nbsp;เงื่อนไข</b-button>
                        </template>
                    </b-table-->

                 </b-card>
            </b-col>
        </b-row>
        <b-modal id="modalRule"
            ref="modalRule"
            size="lg"
            hide-header hideFooter
            no-close-on-backdrop
            no-close-on-esc
            @hidden="resetModalRule"
            >
            <form-rule
                :form_id = "form_id"
                :rule_id = "rule_id"
                :main_rule = "sub_of"
            ></form-rule>
        </b-modal>

    </div>
</template>
<script>

export default {
    props : ['form_id'],
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
        rules: [],
        fid: 0,
        rule_id: -1,
        sub_of: 0,
        rCount: 0,
        sub_rules:[],
        showRule: [],

      }
    },
    mounted(){
        this.rules = [];
    },
    watch: {
        form_id(){
            this.fid = this.form_id;
            if (this.fid > 0){
                this.fetchData();
                //this.getSubRule();

            }else{
                this.clearData();
            }
        },
        rules(){

        }
    },
    computed: {

    },
    methods: {
        fetchData(){
            var path = `/api/forms/${this.form_id}/form_rules`;
            console.log('path :' + path);
            var sub_rule = [];
            axios.get(path)
            .then(response=>{
                this.rules = response.data.data;
                //this.getSubRule();
                this.$forceUpdate();
            })
            .catch(error=>{
                console.log(error);
            })
            //



        },
        getSubRule(){
            var path = '';
            var id = 0;
            var sub_rule = [];

            this.showRule =[];

            console.log('get sub rule' + this.rules.length);
            for (let i = 0 ; i < this.rules.length ; i++){
                id = this.rules[i].id;
                path = `/api/forms/${this.form_id}/form_rules?sub_of=${id}`;
                console.log('get sub rule path :' + path);
                Object.assign(this.rules[i],{sub_rules: sub_rule});
                axios.get(path)
                .then(response=>{
                    sub_rule = response.data.data;
                    console.log('sub rule ' + id + ': ' + sub_rule.length);

                    if (sub_rule.length > 0){
                        Object.assign(this.rules[i],{_showDetails: true});
                        //this.rules[i] = _.extend({},this.rules[i],{_showDetails: true});
                        //this.rules[i] = _.extend({},this.rules[i],{sub_rules: sub_rule});
                        Object.assign(this.rules[i],{sub_rules: sub_rule});
                        //return sub_rule;
                    }
                    this.showRule = this.rules;
                    this.$forceUpdate();
                })
                .catch(error=>{

                })
            }
        },


        showDetail(row){
            row._showDetails = "true";
        },
        clearData(){
            this.fid = -1;
            this.rules = [];
        },
        editRule2(edit_rule){
            this.rule_id = edit_rule.id;
            this.sub_of = edit_rule.sub_of;
            this.$refs['modalRule'].show();
        },
        editRule(id,sub_of=0){
            this.sub_of = sub_of;
            this.rule_id = id;
            this.$refs['modalRule'].show();
        },
        addRule(){
            this.rule_id = 0;
            this.$refs['modalRule'].show();
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
