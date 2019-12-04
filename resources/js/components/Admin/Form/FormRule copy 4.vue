<template>
<div class="animated fadeIn">
    <my-alert :AlertType="alert"></my-alert>
        <b-form>
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
                            :disabled="status == 'update' || sub_of != 0"
                        ></b-form-radio-group>
                    </b-form-group>

                </b-col>
                <b-col sm="8">
                    <b-form-group v-if="iRule.rule_type == 2" >
                        <label for="mainRule">หลักเกณฑ์หลัก</label>
                        <b-form-select
                            v-model="iRule.sub_of"
                            :plain="true"
                            name="mainRule"
                            :options="arr_main_rule"
                            :disabled="status == 'update' || sub_of != 0"
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
            <p>rule_id : {{rule_id}}</p>
            <p>{{rules_count}}</p>
            {{iRule}}
            <p>{{arr_rule_order}}</p>
            <div class="text-center">
                <b-button variant="primary" @click="toSubmit">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseRule">ปิด</b-button>
            </div>
            <rule-consider v-if="status=='update'" :form_id="form_id" :rule_id=rule_id></rule-consider>
        </b-form>
</div>
</template>

<script>
export default {
    props: ['form_id','state','rules','rule_id','sub_of'],
    data(){
        return {
            iRule: {
                name: '',
                rule_type: 0,
                sub_of: 0,
                order: 0
            },
            alert: '',
            status: 'new',
            arr_rule_type: [
                {value: 1, text: 'หลักเกณฑ์หลัก'},
                {value: 2, text: 'หลักเกณฑ์ย่อย'}
            ],
            arr_main_rule: [],
            arr_rule_order: [],
            rules_count: 0
        }
    },
    watch:{
        rule_id(newVal, oldVal){
            if (newVal > 0){

                this.initData();
                //this.create_main_rule();

                if (this.sub_of > 0){
                    this.iRule.rule_type = 2;
                    this.iRule.sub_of = this.sub_of;
                    this.getRulesCount(this.sub_of);
                    this.create_rule_order();
                }else{
                    //this.clearData();
                }
                this.$forceUpdate();
            }


        },
        'iRule.rule_type' : function(newVal,oldVal){
            this.initData();
            if (newVal == 1){
                this.create_rule_order();
                this.$forceUpdate();
            }else if (newVal == 2) {
                this.create_main_rule();
            }

        },
        'iRule.sub_of' : function(newVal,oldVal){
            console.log('event watch sub of ' + newVal);
            if (newVal > 0){
                this.getRulesCount(newVal);
            }else{
                this.getRulesCount();
            }
            this.create_rule_order();
        }
    },
    mounted(){
        //this.initData();
        //console.log("MOUTH FORM RULE");
        //this.create_main_rule();
        //this.create_rule_order();
        // if (this.rule_id > 0){
        //         this.iRule = this.rules[this.rules.findIndex(i => i.id == this.rule_id)];
        //         this.$forceUpdate();
        // }
    },

    methods: {
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
                    this.$emit("fetchRule");
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }
        },

        createArrayOrder(){

        },
        getRulesCount(id = 0){
            if (id > 0){
                var rule =  _.cloneDeep(this.rules[this.rules.findIndex(i => i.id ==id)]['sub_rules']);
                this.rules_count = rule.length;
            }else{
                this.rules_count = this.rules.length;
            }
        },
        initData(){
            if (this.rule_id > 0){
                //this.delivery = _.cloneDeep(item);
                this.status = "update"
                if (this.sub_of == 0){
                    this.iRule = _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.rule_id)]);
                    this.rules_count = this.rules.length;
                }else{
                    var rule =  _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.sub_of)]['sub_rules']);
                    this.rules_count = rule.length;
                    this.iRule = _.cloneDeep(rule[rule.findIndex(i => i.id == this.rule_id)]);
                }

                this.$forceUpdate();
            }else if (this.rule_id == 0){
                this.status = "new";
                this.iRule.name = "";
                this.iRule.order = 0;
                this.arr_rule_order = [];
                console.log('FetchData Rule :' + this.rules.length);
                if (this.sub_of == 0){

                    this.rules_count = this.rules.length;
                }else{ //new sub rule
                    var rule =  _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.sub_of)]['sub_rules']);
                    this.rules_count = rule.length;
                }
                this.$forceUpdate();
            }
            console.log('rules_count :' + this.rules_count);

        },
        fetchOrder(){

        },
        onSubmit(e){
            e.preventDefault();
        },
        toCloseRule(){
            this.clearData();
            //this.$v.reset;
            //this.$emit("toClose");
            //this.$root.$emit('fetchRule');
            this.$root.$emit('bv::hide::modal','modalRule');

        },
        create_rule_order(){
            this.arr_rule_order = [];

            var max = this.rules_count;
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
        clearData(){
            console.log('Clear Rule');
            this.iRule.name = '';
            this.iRule.rule_type = 0;
            this.iRule.sub_of = 0;
            this.iRule.order = 0;
            this.status = 'new';
            //this.iRule = {};
            this.rule_count = 0;
            this.arr_main_rule = [];
            this.arr_rule_order = [];
            this.iRule = {};
            this.$forceUpdate();

        }
    }
}
</script>

<style>

</style>
