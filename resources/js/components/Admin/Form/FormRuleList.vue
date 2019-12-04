<template>
    <div class="animated fadeIn">
        <b-row class="justify-content-md-center">
             <b-col cols="8">
                 <b-card>
                     <div slot="header" class="navbar">
                         <ul class="nav navbar-nav d-md-down-none">
                            <li class="nav-item px-3">
                                <i class='fa fa-align-justify'></i>
                                    หลักเกณฑ์เงื่อนไข {{rule_id}}
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
                    <!-- <rule-cover
                        ref="cover"
                        v-for="rule in rules" :key="rule.id"
                        :rule="rule"
                        :rules="rules"
                        :form_id="form_id"
                        @editRule="editRule2"
                        @addSubRule="addSubRule"
                        @fetchRule="fetchData"
                    >
                    </rule-cover> -->

                    <div v-for="(rule,index) in rules" :key="index">
                        <b-card no-body class="bg-primary">
                            <b-card-body class="pb-0 cover">

                                <b-dropdown class="float-right" variant="transparent p-0" right>
                                <template slot="button-content">
                                    <i class="icon-settings"></i>
                                </template>
                                    <b-dropdown-item @click="addSubRule(rule.id)"><i class="fas fa-plus"></i>&nbsp;เพิ่มหลักเกณฑ์ย่อย</b-dropdown-item>
                                    <b-dropdown-item @click="editRule(rule.id)"><i class="fas fa-edit"></i>&nbsp;แก้ไขหลักเกณฑ์</b-dropdown-item>
                                    <!--b-dropdown-item @click="showCondition(rule.id)" v-if="rule.sub_rules.length == 0"><i class="fas fa-link"></i>&nbsp;ข้อมูลเงื่อนไข</b-dropdown-item-->
                                    <b-dropdown-item @click="delRule(rule.id)"><i class="fas fa-trash"></i>&nbsp;ลบหลักเกณฑ์</b-dropdown-item>
                                </b-dropdown>
                                <b-form-group label="ตัวเลือกหลักย่อย"  class="float-right" v-if="rule.sub_rules.length > 1">
                                    <b-form-radio-group
                                        id="btn-radios-2"
                                        v-model="rule.result_type"
                                        :options="arrResultType"
                                        buttons
                                        button-variant="outline-warning"
                                        name="radio-btn-outline"
                                    ></b-form-radio-group>
                                </b-form-group>
                                <b-row>
                                    <b-col sm="1">
                                        <div class="showSub"  @click="showSub = !showSub">
                                            <i class="fa fa-arrow-circle-right fa-lg mt-4" v-if="!showSub"></i>
                                            <i class="fa fa-arrow-circle-down fa-lg mt-4" v-if="showSub"></i>
                                        </div>
                                    </b-col>
                                    <b-col>
                                        <h4 class="mb-0">ลำดับที่ :{{rule.order}}</h4>
                                        <p>{{rule.name}}</p>

                                    </b-col>
                                </b-row>

                            </b-card-body>
                        </b-card>
                        <div class="animated fadeIn">
                            <b-card no-body class="bg-default sub_rule" v-for="sub_rule in rule.sub_rules" :key="sub_rule.id">
                            <b-card-body class="pb-0 sub_rule">
                                <b-dropdown class="float-right" style="color: #000!important;" variant="transparent p-0" right>
                                <template slot="button-content">
                                    <i class="icon-settings sub_rule"></i>
                                </template>
                                    <b-dropdown-item @click="editSubRule(sub_rule.sub_of, sub_rule.id)"><i class="fas fa-edit"></i>&nbsp;แก้ไขหลักเกณฑ์ย่อย</b-dropdown-item>
                                    <!--b-dropdown-item @click="showCondition(sub_rule.id)"><i class="fas fa-link"></i>&nbsp;ข้อมูลเงื่อนไข</b-dropdown-item-->
                                    <b-dropdown-item @click="delRule(sub_rule.id)"><i class="fas fa-trash"></i>&nbsp;ลบหลักเกณฑ์ย่อย</b-dropdown-item>
                                </b-dropdown>
                                <b-row>
                                    <b-col sm="1">

                                    </b-col>
                                    <b-col>
                                        <h5 class="mb-0">เกณฑ์ย่อย ลำดับที่ :{{sub_rule.order}}</h5>
                                        <p>{{sub_rule.name}}</p>
                                    </b-col>
                                </b-row>
                            </b-card-body>
                        </b-card>
                        </div>
                    </div>
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
                :state = "state"
                :rules = "rules"
                :rule_id = "rule_id"
                :sub_of = "sub_of"
                @fetchRule = "fetchData"
            ></form-rule>
        </b-modal>

    </div>
</template>
<script>
import {mapActions} from 'vuex'
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
        forms: [],
        rules: {},
        rule: {},
        fid: 0,
        rule_id: -1,
        sub_of: 0,
        showRule: [],
        state: 'new',
        arrResultType: [
            {value : 1, text: 'หรือ'},
            {value : 2, text: 'และ'}
        ],
        showSub: false,
        state: 'new'

      }
    },
    mounted(){
        this.fetchData();
    },


    computed: {

    },
    methods: {
        ...mapActions([
            'fetch_form'
        ]),
        fetchData(){
            this.fetch_form();
            this.forms = _.cloneDeep(this.$store.state.forms);
            this.rules = _.cloneDeep(this.forms[this.forms.findIndex(i=>i.id == this.form_id)]['rules']);
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
        editRule(rule_id){
            //this.fetchData();
            this.state = 'update'
            this.sub_of = 0;
            this.rule_id = rule_id;
            this.$forceUpdate();
            this.$refs['modalRule'].show();
        },
        editSubRule(sub_of,rule_id){
            //this.fetchData();
            this.state = 'update'
            this.sub_of = sub_of;
            this.rule_id = rule_id;
            this.$forceUpdate();
            this.$refs['modalRule'].show();
        },
        addRule(){
            //this.fetchData();
            this.rule_id = 0;
            this.sub_of = 0;
            this.state = 'new';
            this.$refs['modalRule'].show();
        },
        addSubRule(sub_of){
            //this.fetchData();
            this.rule_id = 0;
            this.sub_of = sub_of;
            this.state = 'new';
            this.$refs['modalRule'].show();
        },
        resetModalRule(){
            this.rule_id = 0;
            this.sub_of = 0;
            this.state = 'new';

            this.fetchData();
        },
        isSingleRule(id){
            var index = this.rules.findIndex(i=>i.id == id);
            if (index >= 0){
                if (this.rules[index]['sub_rule'].length > 1){
                    return false;
                }else{
                    return true;
                }
            }

        },
        delRule(id){
            this.$swal({
                title: "กรุณายืนยันการลบหลักเกณฑ์",
                text: "หากยืนยันการลบ หลักเกณฑ์ย่อยและเงื่อนไขจะถูกลบไปด้วย",
                icon: "error",
                closeOnClickOutside: false,
                buttons: [
                    'ยกเลิก',
                    'ยืนยัน'
                ],

            }).then(isConfirm =>{
                if (isConfirm){
                    let path = `/api/forms/${this.form_id}/form_rules/${id}`;
                    console.log('Path Delete : ' + path);
                    axios.delete(path)
                    .then(response=>{
                        this.rule_id = 0;
                        this.sub_of = 0;
                        this.state = 'new';
                        this.$emit('toRefresh');
                        this.fetchData();
                    })
                }

            });
        },
    }
}
</script>
<style scoped>
.card-body{
    padding: 0px!important;
}
.card-body.cover{
    padding: 10px!important;
}
.card-body.sub_rule{
    padding: 10px!important;
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
.btn{
    padding-left: 15px!important;
    padding-right: 15px!important;

}
.bg-primary{
    background-color: #20a8d8 !important;
}
.bg-default{
    color: #000!important;
}
.card-body{
    color: #fff!important;
}
.sub_rule{
    color: #000!important;
}
.card{
    margin: 10px!important;
}
.dropdown-item>i{
    color: #000!important;
}
.showSub{
    cursor: pointer;
}
.noSub{
    color: rgb(97, 97, 97)!important;
    cursor: default;
}
.float-right{
    margin-right: 5px;
}
</style>
