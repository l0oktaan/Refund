<template>
    <div class="animated fadeIn">
        <div>
        <my-alert :AlertType="alert"></my-alert>
        <b-form @submit="onSubmit">

            <b-form-group>
                <label for="name">รายละเอียดเงื่อนไข</label>
                <b-form-input type="text"
                    placeholder="รายละเอียดเงื่อนไข"
                    name="name"
                    v-model = "c_name"
                    @blur="$v.c_name.$touch()"
                    >
                </b-form-input>
                <div class="error" v-if="!$v.c_name.required">กรุณากรอกข้อมูล</div>
                <div class="error" v-if="!$v.c_name.minLength">กรุณากรอกข้อมูลความยาวไม่น้อยกว่า {{$v.c_name.$params.minLength.min}} ตัวอักษร.</div>
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
                            :options="arr_type"
                            name="c_type"
                        ></b-form-radio-group>
                    </b-form-group>
                </b-col>
            </b-row>
            <div class="text-center">
                <b-button type="submit" variant="primary">บันทึกข้อมูล</b-button>
                <b-button type="reset" variant="danger" @click="toCloseCondition">ปิด</b-button>
            </div>

        </b-form>
        </div>
    </div>
</template>
<script>
import { validationMixin } from 'vuelidate'
import { required, minLength, minValue } from 'vuelidate/lib/validators'
export default {
    props: ['form_id', 'rule_id'],
    data(){
        return {
            c_id: 0,
            c_name: '',
            c_description: '',
            c_type: 0,
            c_status: 1,

            state: 'new',
            arr_type: [
                {value: 1, text: 'ใช่หรือไม่'},
                {value: 2, text: 'กำหนดค่า'}
            ],

            alert: '',
            conditions: {}
        }
    },
    watch: {
        rule_id(){
            console.log(' watch rule id :' + this.rule_id);
            if (this.rule_id > 0 ){
                this.fetchData();

                this.$forceUpdate();
            }else{

                this.$forceUpdate();

            }
        }
    },
    mounted(){

    },
    mixins: [validationMixin],
    validations: {

        c_type:{
            minValue: minValue(1)
        },
        c_name:{
            required,
            minLength: minLength(4)
        }

    },methods: {

        toCloseCondition(){
            //this.$parent.$refs
            this.clearData();
            this.$root.$emit('bv::hide::modal','modalCondition');
        },
        fetchData(){

            var condition = [];
            var path = `/api/forms/${this.form_id}/form_rules/${this.rule_id}/form_conditions`;
            console.log('get con :' + path);
            axios.get(path)
            .then(response=>{
                condition = response.data.data;
                console.log('show con :' + condition[0].name);
                if (condition.length > 0){

                    this.state = 'update';
                    this.c_id = condition[0].id;
                    this.c_name = condition[0].name;
                    this.c_description = condition[0].description;
                    this.c_type = condition[0].condition_type;
                    this.c_status = condition[0].status;
                    this.conditions = condition[0];
                }else{
                    this.clearData();
                }

            })
            .catch(error=>{

            })
        },
        onSubmit(e){
            e.preventDefault();
            var condition = {};
            var path = '';
            console.log('state :' + this.state);
            if (this.state == 'new'){
                path = `/api/forms/${this.form_id}/form_rules/${this.rule_id}/form_conditions`;

                axios.post(path,{
                    name: this.c_name,
                    condition_type: this.c_type,
                    description: this.c_description,
                    status: this.c_status
                })
                .then(response=>{
                    condition = response.data.data;
                    this.alert = "success";
                    this.c_id = condition.id;
                    this.c_name = condition.name;
                    this.c_description = condition.description;
                    this.c_type = condition.condition_type;
                    this.c_status = condition.status;
                    this.conditions = condition;
                    this.state = 'update';
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }else if (this.state == 'update'){
                path = `/api/forms/${this.form_id}/form_rules/${this.rule_id}/form_conditions/${this.c_id}`;
                axios.put(path,{
                    name: this.c_name,
                    condition_type: this.c_type,
                    description: this.c_description,
                    status: this.c_status
                })
                .then(response=>{
                    condition = response.data.data;
                    this.alert = "success";
                    this.c_id = condition.id;
                    this.c_name = condition.name;
                    this.c_description = condition.description;
                    this.c_type = condition.condition_type;
                    this.c_status = condition.status;
                    this.conditions = condition;
                    this.state = 'update';
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }

        },
        clearData(){
            this.alert = '';
            this.c_id = 0;
            this.c_name = '';
            this.c_description ='';
            this.c_type = 0;
            this.c_status = 1;
            this.state = 'new';
            this.conditions = {};
        }
    }
}
</script>

