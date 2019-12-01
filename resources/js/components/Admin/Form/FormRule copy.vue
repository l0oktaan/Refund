<template>
    <div class="animated fadeIn">
        <my-alert :AlertType="alert"></my-alert>
        <b-form @submit="onSubmit">
            <b-form-group :class="{'form-group-error': $v.r_name.$error }" >
                <label for="name">ชื่อหลักเกณฑ์</label>
                <b-form-input type="text"
                    placeholder="ชื่อหลักเกณฑ์"
                    name="name"
                    v-model = "r_name"
                    @blur="$v.r_name.$touch()"
                    >
                </b-form-input>
                <div class="error" v-if="!$v.r_name.required">กรุณากรอกข้อมูล</div>
                <div class="error" v-if="!$v.r_name.minLength">กรุณากรอกข้อมูลความยาวไม่น้อยกว่า {{$v.r_name.$params.minLength.min}} ตัวอักษร.</div>
            </b-form-group>
            <b-row>
                <b-col sm="4">
                    <b-form-group label="ตัวเลือกหลักเกณฑ์">
                        <b-form-radio-group
                            v-model="r_rule_type"
                            :options="arr_rule_type"
                            name="ruleOption"
                            :disabled="state === 'update'"
                        ></b-form-radio-group>
                    </b-form-group>
                </b-col>
                <b-col sm="8">
                    <b-form-group v-if="r_rule_type == 2" >
                        <label for="mainRule">หลักเกณฑ์หลัก</label>
                        <b-form-select
                            v-model="r_sub_of"
                            :plain="true"
                            name="mainRule"
                            :options="arr_main_rule"
                            :disabled="state === 'update'"
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
                            v-model="r_order"
                            name="order"
                            :plain="true"
                            :options="arr_rule_order"
                        >
                        </b-form-select>

                    </b-form-group>
                </b-col>
            </b-row>
            <!--
            <b-form-group>
                <label for="name">รายละเอียดเงื่อนไข</label>
                <b-form-input type="text"
                    placeholder="รายละเอียดเงื่อนไข"
                    name="name"
                    v-model = "c_name"

                    >
                </b-form-input>

            </b-form-group>
            <b-form-group>
                <label for="description">คำอธิบาย</label>
                <b-form-input type="text"
                    placeholder="คำอธิบาย"
                    name="description"
                    v-model = "c_description"
                    >
                </b-form-input>
            </b-form-group>
            <b-row>
                <b-col sm="6">
                    <b-form-group label="ประเภทเงื่อนไข">
                        <b-form-radio-group
                            v-model="c_type"
                            :options="arr_c_type"
                            name="c_type"
                        ></b-form-radio-group>
                    </b-form-group>
                </b-col>
            </b-row>
            -->
            <div class="text-center">
                <b-button type="submit" variant="primary">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseRule">ปิด</b-button>
            </div>
            <rule-consider v-if="state=='update'" :form_id="form_id" :rule_id="r_id"></rule-consider>
        </b-form>
    </div>
</template>
<script>
import { validationMixin } from 'vuelidate'
import { required, minLength, minValue } from 'vuelidate/lib/validators'

export default {
    props: ['form_id','rule_id','main_rule'],
    mixins: [validationMixin],
    validations: {
        r_order:{
            minValue: minValue(1)
        },
        r_name:{
            required,
            minLength: minLength(4)
        }
    },
    data(){
        return {
            r_id: 0,
            r_name: '',
            r_order: 0,
            r_rule_type: 0,
            r_sub_of: 0,
            r_result_type: 0,
            c_name: '',
            c_description: '',
            c_type: 0,
            r_status: 1,

            arr_rule_type: [
                {value: 1, text: 'หลักเกณฑ์หลัก'},
                {value: 2, text: 'หลักเกณฑ์ย่อย'}
            ],
            arr_main_rule: [],
            arr_rule_order: [],
            arr_result_type: [
                {value: 0, text: 'ประเภทหลักเกณ์'},
                {value: 1, text: 'ตรงทุกข้อ'},
                {value: 2, text: 'ข้อใดข้อหนึ่ง'},
            ],
            arr_c_type: [

                {value: 1, text: 'ใช่หรือไม่'},
                {value: 2, text: 'กำหนดค่า'}
            ],
            state: 'new',
            alert: ''
        }
    },
    watch : {
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

        r_sub_of(){
            console.log('change sub -of');
            this.getOrderRule(this.r_sub_of);
        },
        r_rule_type(){
            if (this.r_rule_type == 1){
                this.getOrderRule(0);
                this.$forceUpdate();
            }
        }
    },
    mounted(){
        //this.getOrderRule();
    },
    methods: {
        onSubmit(e){
            e.preventDefault();
            var path = `/api/forms/${this.form_id}/form_rules`;
            var rule = {};
            console.log('name rule : ' + this.r_name+' ' + this.r_order+ ' ' + this.r_sub_of+' ' + this.r_result_types+' ' + this.r_status);
            if (this.state == 'new'){
                axios.post(path,{
                    name: this.r_name,
                    order: this.r_order,
                    sub_of: this.r_sub_of,
                    rule_type: this.r_rule_type,
                    result_type: 0,
                    condition: this.c_name,
                    condition_type: this.c_type,
                    description: this.c_description,
                    status: this.r_status,
                })
                .then(response=>{
                    rule = response.data.data;
                    this.r_id = rule.id;

                    this.r_name = rule.name;
                    if (rule.rule_type == 0){
                        this.getOrderRule(0);
                    }else{
                        this.getOrderRule(rule.sub_of);
                    }
                    this.r_rule_type = rule.rule_type;
                    this.r_order = rule.order;
                    this.r_sub_of = rule.sub_of;
                    this.r_result_type = rule.result_type;
                    this.c_name = rule.condition;
                    this.c_type = rule.condition_type;
                    this.c_description = rule.description;
                    this.r_status = rule.status;
                    this.alert = "success"
                    this.state = 'update'
                    this.$forceUpdate();

                })
                .catch(error=>{
                    this.alert = "error";
                })
            }else if (this.state == 'update'){
                //console.log('update rule id:' + this.rule.id);
                console.log('update name rule : ' + this.r_name+' ' + this.r_order+ ' ' + this.r_sub_of+' ' + this.r_result_types+' ' + this.r_status);
                path = `${path}/${this.r_id}`;
                axios.put(`${path}`,{
                    name: this.r_name,
                    order: this.r_order,
                    rule_type: this.r_rule_type,
                    result_type: this.r_result_type,
                    sub_of: this.r_sub_of,
                    condition: this.c_name,
                    condition_type: this.c_type,
                    description: this.c_description,
                    status: this.r_status,
                })
                .then(response=>{
                    rule = response.data.data;
                    this.r_id = rule.id;
                    this.r_name = rule.name;
                    if (rule.rule_type == 0){
                        this.getOrderRule(0);
                    }else{
                        this.getOrderRule(rule.sub_of);
                    }
                    this.r_rule_type = rule.rule_type;
                    this.r_order = rule.order;
                    this.r_sub_of = rule.sub_of;
                    this.r_result_type = rule.result_type;
                    this.c_name = rule.condition;
                    this.c_type = rule.condition_type;
                    this.c_description = rule.description;
                    this.r_status = rule.status;
                    this.state = 'update'
                    this.$forceUpdate();
                    this.alert = "success"
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }
        },
        fetchData(){
            var path = '';
            var rule = {};
            path = `/api/forms/${this.form_id}/form_rules/${this.r_id}`;
            axios.get(path)
            .then(response=>{
                rule = response.data.data;
                this.r_id = rule.id;
                this.r_name = rule.name;

                if (rule.rule_type == 0){
                    this.getOrderRule(0);
                }else{
                    this.getOrderRule(rule.sub_of);
                }
                this.r_rule_type = rule.rule_type;
                this.r_order = rule.order;
                this.r_sub_of = rule.sub_of;
                this.r_result_type = rule.result_type;
                this.c_name = rule.condition;
                this.c_type = rule.condition_type;
                this.c_description = rule.description;
                this.r_status = rule.status;
                this.$forceUpdate();
            })
        },
        getMainRule(){
            var path = '';
            var rules = [];
            path = `/api/forms/${this.form_id}/form_rules?sub_of=0`;
            axios.get(path)
            .then(response=>{
                rules = response.data.data;
                this.arr_main_rule = [];
                this.arr_main_rule.push({value: 0, text: 'เลือกเกณฑ์หลัก'});
                for (let i=0 ;i < rules.length ; i++){
                    this.arr_main_rule.push({value: rules[i].id, text: rules[i].name});
                }

            })

        },
        getOrderRule(sub_of){
            var path = `/api/forms/${this.form_id}/form_rules?sub_of=${sub_of}`;
            var arr = [];
            var rules = [];
            var max = 0;
            console.log('get order :' + path);
            axios.get(path)
            .then(response=>{
                rules = response.data.data;
                console.log('rule length: '+ rules.length);
                this.arr_rule_order = [];
                max = rules.length;
                if (this.state == 'new'){
                    max = max + 1;
                }
                arr.push({value: 0,text: 'ลำดับ'});

                for (let i=1 ; i <= max ; i++){
                    arr.push({value: i, text: i});
                }

                this.arr_rule_order = arr;
                this.$forceUpdate();
            })
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
        },
        clearData(){
            this.state = 'new';
            this.r_id = 0;
            this.r_name = '';
            this.r_sub_of = 0;
            this.r_order = -1;
            this.r_rule_type = -1;

            this.r_result_type = 0;
            this.r_status = 0;
            this.c_name = '';
            this.c_description= '';
            this.c_type = 0;
            this.arr_main_rule = [];
            this.arr_rule_order = [];


        },
        toCloseRule(){
            this.clearData();
            this.$v.reset;
            this.$root.$emit('bv::hide::modal','modalRule');
            this.$root.$emit('fetchData');
        }
    }
}
</script>

