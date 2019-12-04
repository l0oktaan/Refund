<template>
<div class="animated fadeIn">
    <my-alert :AlertType="alert"></my-alert>
        <b-form >
            <b-form-group>
                <label for="name">ชื่อหลักเกณฑ์</label>
                <b-form-input type="text"
                    placeholder="ชื่อหลักเกณฑ์"
                    name="name"
                    v-model = "iRule.name"
                    >
                </b-form-input>

            </b-form-group>
            <b-row>
                <b-col sm="4">
                    <b-form-group label="ตัวเลือกหลักเกณฑ์">
                        <b-form-radio-group
                            v-model="iRule.rule_type"
                            :options="arr_rule_type"
                            name="ruleOption"
                            :disabled="state == 'update' || sub_of != 0"
                        ></b-form-radio-group>
                    </b-form-group>

                </b-col>
                <b-col sm="8">
                    <b-form-group v-if="iRule.rule_type == 2">
                        <label for="mainRule">หลักเกณฑ์หลัก</label>
                        <b-form-select
                            v-model="iRule.sub_of"
                            :plain="true"
                            name="mainRule"
                            :options="arr_main_rule"
                            :disabled="state == 'update' || sub_of != 0"
                        >
                        </b-form-select>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col sm="4" >
                    <b-form-group>
                        <label for="order">ลำดับหลักเกณฑ์</label>
                        <b-form-select
                            v-model="iRule.order"
                            name="order"
                            :plain="true"
                            :options="arr_rule_order"
                        >
                        </b-form-select>
                    </b-form-group>
                </b-col>
            </b-row>

            <div class="text-center">
                <b-button variant="primary" @click="toSubmit">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseRule">ปิด</b-button>
            </div>
            <rule-consider v-if="status=='update'" :form_id="form_id" :rule_id="r_id"></rule-consider>
        </b-form>
    </div>
</template>

<script>

export default {
    props: ['form_id','rules','rule_id','sub_of','state'],
    data(){
        return {
            status: 'new',
            r_id: -1,
            iRule: {
                name: '',
                rule_type: 0,
                sub_of: 0,
                order: 0
            },
            rules_count: 0,
            arr_rule_type: [
                {value: 1, text: 'หลักเกณฑ์หลัก'},
                {value: 2, text: 'หลักเกณฑ์ย่อย'}
            ],
            arr_main_rule: [],
            arr_rule_order: [],
            alert: ''
        }
    },
    watch: {
        rule_id(newVal,oldVar){
            if (newVal > 0){
                this.getRule();
            }
        },

        'iRule.rule_type' : function(newVal,oldVal){
            if (newVal == 1){
                this.create_rule_order();
            }else if (newVal == 2) {
                this.arr_rule_order = [];
                this.create_main_rule();
            }
        },
        'iRule.sub_of' : function(newVal,oldVal){
            if (newVal > 0){
                this.getRulesCount(newVal);
                this.create_rule_order(newVal);
                this.$forceUpdate();
            }else{
                this.arr_rule_order = [];
            }


        }
    },
    methods: {
        onLoad(){
            // this.create_main_rule();
            // this.create_rule_order(this.r_id);
            // if (this.state == 'new'){
            //     this.iRule.name = '';
            //     this.iRule.rule_type = 0;
            //     this.iRule.sub_of = 0;
            //     this.iRule.order = 0;
            // }
        },
        toSubmit(){
            //e.preventDefault();
            var path = `/api/forms/${this.form_id}/form_rules`;
            var rule = {};
            console.log('update rule id:' + this.rule_id + ' ' + path + ' ' + this.status);
            if (this.status == 'new'){
                axios.post(path,{
                    order: this.iRule.order,
                    name: this.iRule.name,
                    rule_type: this.iRule.rule_type,
                    sub_of: (this.iRule.rule_type == 1) ? 0 : this.iRule.sub_of,
                    result_type: 0,
                    status: 1
                })
                .then(response=>{
                    this.alert = "success"
                    this.status = 'update';
                    this.iRule = response.data.data;
                    this.r_id = this.iRule.id;
                    this.$emit("fetchRule");
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }else if (this.status == 'update'){
                console.log('update rule id:' + this.rule_id);

                path = `${path}/${this.rule_id}`;
                axios.put(`${path}`,{
                    order: this.iRule.order,
                    name: this.iRule.name,
                    status: 1
                })
                .then(response=>{
                    this.alert = "success"
                    this.status = 'update';
                    this.iRule = response.data.data;
                    this.r_id = this.iRule.id;
                    this.$emit("fetchRule");
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }
        },
        getRule(){
            if (this.sub_of == 0){
                    this.iRule = _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.r_id)]);
                    this.rules_count = this.rules.length;
                }else{
                    var rule =  _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.sub_of)]['sub_rules']);
                    this.rules_count = rule.length;
                    this.iRule = _.cloneDeep(rule[rule.findIndex(i => i.id == this.r_id)]);
                }
        },
        getRulesCount(id = 0){
            if (id > 0){
                var rule =  _.cloneDeep(this.rules[this.rules.findIndex(i => i.id ==id)]['sub_rules']);
                return  rule.length;
            }else{
                return this.rules.length;
            }
        },
        create_rule_order(id = 0){
            this.arr_rule_order = [];
            var max = this.getRulesCount(id);

            console.log('rules length : ' + this.rules_count + ' : ' + this.rules.length);
            if (this.status == 'new'){
                max = max + 1;
            }
            this.arr_rule_order.push({value: 0,text: 'ลำดับ'});

            for (let i=1 ; i <= max ; i++){
                this.arr_rule_order.push({value: i, text: i});
            }

            this.$forceUpdate();
        },
        create_main_rule(){
            this.arr_main_rule = [];
            this.arr_main_rule.push({value: 0,text: 'หลักเกณฑ์หลัก'});
            for (let i=0; i < this.rules.length; i++){
                this.arr_main_rule.push({value: this.rules[i]['id'], text: this.rules[i]['name']});
            }
            this.$forceUpdate();
        },
        toCloseRule(){
            this.clearData();
            this.$root.$emit('bv::hide::modal','modalRule');

        },
        clearData(){
            this.arr_main_rule = [];
            this.arr_rule_order = [];
            this.status = 'new';
            this.rid = -1;
            this.iRule.name = '';
            this.iRule.order = 0;
            this.iRule.rule_type = 0;
            this.iRule.sub_of = 0;
        }
    }
}
</script>

<style>

</style>
