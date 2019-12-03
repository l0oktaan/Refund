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
                            :disabled="status === 'update'"
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
                            :disabled="status === 'update'"
                        >
                        </b-form-select>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col sm="4">
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
            {{status}}
            <div class="text-center">
                <b-button variant="primary" @click="toSubmit">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseRule">ปิด</b-button>
            </div>
            <!-- <rule-consider v-if="state=='update'" :form_id="form_id" :rule_id="r_id"></rule-consider> -->
        </b-form>
</div>
</template>

<script>
export default {
    props: ['form_id','state','rules','rule_id'],
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
        }
    },
    watch:{
        rule_id(){
            this.create_main_rule();
            this.create_rule_order();
            if (this.rule_id > 0){
                //this.delivery = _.cloneDeep(item);
                this.status = "update"
                this.iRule = _.cloneDeep(this.rules[this.rules.findIndex(i => i.id == this.rule_id)]);
                this.$forceUpdate();
            }else{
                this.status = "new";
            }
        }
    },
    mounted(){
        // this.create_main_rule();
        // this.create_rule_order();
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
        fetchData(){
            this.createArrayOrder();
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
            var max = this.rules.length;
            console.log('rules length : ' + this.rules.length);
            if (this.state == 'new'){
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
            // this.iRule.name = '';
            // this.iRule.rule_type = 0;
            // this.iRule.sub_of = 0;
            // this.iRule.order = 0;
            // this.status = 'new';
            this.iRule = {};

        }
    }
}
</script>

<style>

</style>
