<template>
    <div class="animated fadeIn">
        <my-alert :AlertType="alert"></my-alert>
        <b-row class="justify-content-md-center">
            <b-col cols="8">
                <b-card>

                    <div slot="header">
                        <strong>รายละเอียดฟอร์ม</strong>
                    </div>
                    <b-form @submit="onSubmit">
                        <b-form-group>
                            <label for="name1">ชื่อแบบฟอร์ม</label>
                            <b-form-input type="text"

                                placeholder="ชื่อแบบฟอร์ม"
                                name="name1"
                                v-model="form.name1"
                                >
                            </b-form-input>

                        </b-form-group>
                        <b-form-group>
                            <label for="name2">ชื่อแบบฟอร์ม เพิ่มเติม</label>
                            <b-form-input type="text"
                                v-model="form.name2"

                                placeholder="ชื่อแบบฟอร์ม เพิ่มเติม">
                            </b-form-input>

                        </b-form-group>
                        <b-form-group >
                            <label for="formName3">ชื่อแบบฟอร์ม เพิ่มเติม</label>
                            <b-form-input type="text" v-model="form.name3" id="txtFormName3" placeholder="ชื่อแบบฟอร์ม เพิ่มเติม"></b-form-input>
                        </b-form-group>
                        <b-row>
                            <b-col sm="4">
                                <b-form-group >
                                    <label for="month1">ลำดับฟอร์ม</label>
                                    <b-form-select v-model="form.order"
                                        name="order"
                                        :plain="true"
                                        :options="form_order_list"
                                        >
                                    </b-form-select>

                                </b-form-group>
                            </b-col>
                        </b-row>

                        <div class="text-center">
                            <b-button type="submit" variant="primary">บันทึกข้อมูล</b-button>
                            <router-link to="/admin/forms">
                                <b-button variant="danger" >ปิด</b-button>
                            </router-link>

                        </div>

                    </b-form>

                </b-card>

            </b-col>
        </b-row>

    </div>
</template>
<script>

export default {
    props: ['form_id'],
    data(){
        return {
            forms: this.$store.state.forms,
            state: 'new',
            form: {
                id: 0,
                name1: '',
                name2: '',
                name3: '',
                order: 0
            },
            path: this.$route.path,
            //form_id: this.$route.params.id,
            form_order_list: [],
            alert: "",
            form_count: this.$store.state.forms.length
        }
    },
    mounted(){
        console.log('form detail :' + this.form_id);
        if (this.form_id == 0){
            this.state = 'new';
        }else{
            this.state = 'update';
            this.form = this.forms[this.forms.findIndex(i => i.id == this.form_id)];

        }
        this.getFormOrderList();
    },
    computed: {

    },
    methods: {
        getFormOrderList(){
            var max = this.form_count;
            console.log('max :' + max);

            var order = [];

            order.push({'value': 0, text: 'ลำดับ'});
            if (this.state == "new"){
                max = max + 1;
            }
            for (let i = 1; i <= max; i++){
                order.push({value: i, text: i});
            }
            this.form_order_list = order;
            //this.form_order_max = order[order.length-1].value;


        },
        onSubmit(e){
            e.preventDefault();

            var path = '/api/forms';

            if (this.state == "new"){
                axios.post(path,{
                    name1 : this.form.name1,
                    name2 : this.form.name2,
                    name3 : this.form.name3,
                    order : this.form.order,
                    create_by : 'Songwut',
                    status : 1
                })
                .then((response)=>{
                    this.alert = "success";
                    this.state = "update";
                    this.form = response.data.data;
                    //this.$emit('toEdit',this.form.id);
                    //setTimeout( () => this.$router.push({ path: `/admin/forms/${this.form.id}/edit`}), 1000);
                    setTimeout( () => this.$emit('toEdit',this.form.id), 1000);

                    this.$forceUpdate();
                })
                .catch(error=>{
                    this.alert = "error";
                })
            }else if (this.state == "update"){
                axios.put(`${path}/${this.form_id}`,{
                    name1 : this.form.name1,
                    name2 : this.form.name2,
                    name3 : this.form.name3,
                    order : this.form.order,
                    create_by : 'Songwut',
                    status : 1
                }).then((response)=>{
                    this.alert = "success";
                    this.state = "update";
                    this.form = response.data.data;
                }).catch(error=>{
                    console.log(error);
                    this.alert = "error";
                })
            }
        }
    }
}
</script>
<style scoped>

</style>
