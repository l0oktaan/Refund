<template>
<div class="animated fadeIn">
    <my-alert :AlertType="alert"></my-alert>
        <b-form @submit="onSubmit">
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
            
            <div class="text-center">
                <b-button type="submit" variant="primary">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseRule">ปิด</b-button>
            </div>
            <!-- <rule-consider v-if="state=='update'" :form_id="form_id" :rule_id="r_id"></rule-consider> -->
        </b-form>
</div>
</template>

<script>
export default {
    props: ['state','rules','rule_id'],
    data(){
        return {
            iRule: {},
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
            if (this.rule_id >= 0){
                if (this.rule_id == 0){
                    //this.state = 'new';
                    this.clearData();
                    this.getMainRule();
                    if (this.main_rule != 0){
                    this.r_rule_type = 2;
                    this.r_sub_of = this.main_rule;
                }
                }else{
                    this.state = 'update';
                    this.r_id = this.rule_id;
                    this.getMainRule();
                    this.fetchData();
                }
            }
        },

    },
    
    methods: {
        createArrayOrder(){

        },
        fetData(){
            this.createArrayOrder();
        },
        onSubmit(e){
            e.preventDefault();
        },
        toCloseRule(){
            //this.clearData();
            //this.$v.reset;
            this.$root.$emit('bv::hide::modal','modalRule');
            this.$root.$emit('fetchData');
        }
    }
}
</script>

<style>

</style>