<template>
    <div class="animated fadeIn">
        <my-alert :AlertType="alert"></my-alert>
        <h4>ข้อมูลการถอนคืนเงินรายได้</h4>
        <b-tabs v-model="tabIndex">
            <b-tab>
              <template slot="title">
                <h5>ขั้นตอนที่ 1 : <i :class="tabs[0].status == 1 ? icon_check : icon_uncheck"></i></h5>
                <span>{{tabs[0].title}}</span>
              </template>
              <b-row>
                  <b-col cols="6" v-for="(form,index) in forms" :key="index">
                    <div class="animated fadeIn">
                        <b-card no-body :class="isSelect[index] ? 'bg-info' : 'bg-default'">
                            <b-card-body class="pb-0 ">
                                <div class="float-right">
                                    <toggle-button :value="false" :sync="true" :width="70" :height="25"
                                        :labels="{checked: 'เลือก', unchecked: 'ไม่เลือก'}"
                                        :color="{checked: '#41831b', unchecked: '#7c7c7c'}"
                                        style="padding-top:5px; line-height:35px;"
                                        v-model="isSelect[index]"
                                        @change="confirmChange(form,index)"
                                        :disabled="refund_status === 'update'"
                                    />
                                </div>

                                <div class="textFiled">ฟอร์มลำดับที่ : {{form.order}}</div>
                                <div class="textFiled">ชื่อแบบฟอร์ม : {{form.name1}}</div>
                                <div></div>
                            </b-card-body>
                        </b-card>
                    </div>
                </b-col>
              </b-row>
              <b-row>
                  <b-col>
                    <div class="animated fadeIn text-center">
                        <b-button variant="primary" @click="saveRefundForm" :disabled="refund_status === 'update'">บันทึกข้อมูล</b-button>
                        <b-button variant="danger">ยกเลิก</b-button>
                    </div>
                  </b-col>
              </b-row>
            </b-tab>
            <!--================================= Tab Form ==================================-->
            <b-tab v-for="(tab,index) in tab_forms" :key="index" >
                <template slot="title">
                <h5>แบบฟอร์ม :<i :class="tab.status == 1 ? icon_check : icon_uncheck"></i></h5>
                <span>{{tab.title}}</span>
              </template>

                  <refund-check :form_id="refund_forms[index].form_id" v-if="false"></refund-check>

            </b-tab>
            <!--==================================== Tab Form End =====================================-->

          </b-tabs>
            {{refund_detail}}

    </div>
</template>
<script>
export default {
    data(){
        return {

            tabIndex: 0,
            tabs: [
                {title: 'เลือกแบบฟอร์มขอถอนคืน', status: 0},
                {title: 'ข้อมูลสัญญา', status: 0},
                {title: 'ข้อมูลการอนุมัติ งด/ลด/ขยายเวลา', status: 0},
                {title: 'ข้อมูลการส่งมอบงาน', status: 0},
                {title: 'จำนวนเงินที่ขออนุมัติ', status: 0},

            ],
            tab_forms: [],
            forms: [],
            arrFormSelected: [],
            isSelect: [],
            form_id : this.$route.params.id,
            form_id: 0,
            office_id: 2,
            refund_id: 0,
            refund_status: 'new',
            refund_forms: [],
            refund_detail: [],
            alert: '',
            icon_check: 'far fa-check-square fa-lg',
            icon_uncheck: 'far fa-square fa-lg',
            mylog : ''
        }
    },
    watch: {
        tabIndex(){
            console.log('tab index :' + this.tabIndex);
        }
    },
    computed : {
        form_tabs(){
            if (this.tabs.length > 3){
                return this.tabs.splice(0,3);
            }else{
                return [];
            }

        }
    },
    mounted(){
        this.getForm();
        this.$forceUpdate();
    },
    methods: {
        getForm(){
            var path = '/api/forms';
            var forms = [];

            axios.get(path)
            .then(response=>{
                forms = response.data.data;
                this.forms = forms;
                this.createArray();
                console.log('form :' + forms.length);
            })
        },
        confirmChange(form,index){


            let formIndex = this.arrFormSelected.findIndex(i => i.id === form.id);

            if (formIndex >= 0){

                this.arrFormSelected.splice(formIndex,1);

            }else{
                this.arrFormSelected.push(
                    {id: form.id, name: form.name1, order: form.order, selectIndex: index}
                );

            }
            this.arrFormSelected = this.sortArrays(this.arrFormSelected);

        },
        sortArrays(arr){
            return _.orderBy(arr,'order','asc');
        },
        createArray(){
            console.log('create array');
            if (this.forms.length > 0){
                for (let i = 0 ; i < this.forms.length ; i++){
                    this.isSelect.push(false);
                }
            }
        },
        clearData(){
            this.tabIndex = 0;
            for (let i = 0 ; i < this.tabs.length ; i++){
                this.tabs[i].status = 0;
            }
            this.tab_forms = [];
            this.forms = [];
            this.arrFormSelected = [];
            this.isSelect = [];
            this.form_id = 0;
            this.refund_status = 'new';
        },
        checkConsidetType(iType,oper){
            if (iType == 1){
                //0 or 1
                return "0"
            }else if (iType == 2){
                //text
                return "-"
            }else if (iType == 3){
                if (oper == 1){
                    return "0"
                }else{
                    return ""
                }
            }
        },
        checkResultType(iType,oper){
            if (iType == 1){
                //0 or 1
                return "boolean"
            }else if (iType == 2){
                //text
                return "value"
            }else if (iType == 3){
                if (oper == 1){
                    return "number"
                }else{
                    return "date"
                }
            }
        },
        createRefundDetail(refund_form){
            //console.log('refund_form :' + refund_form.id);
            var arr_detail = [];
            var rule = {};
            var arr_consider = [];
            var path = `/api/offices/${this.office_id}/refunds/${this.refund_id}/refund_forms/${refund_form.id}/refund_details`;
            var form = refund_form.form;

            for (let i=0; i<form.rules.length; i++){
                rule = form.rules[i]
                arr_consider = rule.considers;
                for (let j=0; j < arr_consider.length; j++){
                    arr_detail.push({
                        'consider_id': arr_consider[j].id,
                        'result_type' : this.checkResultType(arr_consider[j].type ,arr_consider[j].oper),
                        'value': this.checkConsidetType(arr_consider[j].type ,arr_consider[j].oper),
                        'status': 0
                    });
                }
            }
            if (arr_detail.length > 0){
                console.log('refund_detail :' + arr_detail.length);
                axios.post(`${path}`,{
                    state : 'new',
                    detail : arr_detail
                })
                .then(response=>{
                    this.mylog = response;

                })
                .catch(error=>{

                })
            }
            return arr_detail;
        },
        saveRefundForm(){

            if (this.arrFormSelected.length > 0 && this.refund_status == 'new'){
                this.$swal({
                    title: "กรุณาตรวจสอบข้อมูล",
                    text: "หากบันทึกแล้วจะไม่สามารถเพิ่มฟอร์มใหม่ได้",
                    icon: "warning",
                    closeOnClickOutside: false,
                    buttons: [
                        'ยกเลิก',
                        'ยืนยัน'
                    ],

                }).then(isConfirm =>{
                    if (isConfirm){

                        var refund = {};
                        var path = '';
                        var refund_form = {};
                        // Create Refund
                        path = `/api/offices/${this.office_id}/refunds`;
                        axios.post(`${path}`,{
                            approve_code: '123456'
                        })
                        .then(response=>{

                            refund = response.data.data;
                            this.refund_id = refund.id;
                            this.refund_status = 'update';
                            for (let i = 0 ; i < this.arrFormSelected.length ; i++){
                                path = `/api/offices/${this.office_id}/refunds/${this.refund_id}/refund_forms`;
                                axios.post(path,{
                                    form_id: this.arrFormSelected[i].id,
                                    result: 0,
                                    status: 0
                                })
                                .then(response=>{
                                    refund_form = response.data.data;
                                    this.refund_forms.push(response.data.data);
                                    path = `/api/offices/${this.office_id}/refunds/${this.refund_id}/refund_forms/${response.data.data.id}/refund_details`;
                                    console.log('Path refund form :' + path);
                                    /* axios.post(path)
                                    .then(response=>{

                                    })
                                    .catch(error=>{

                                    }); */
                                    this.refund_detail = this.createRefundDetail(refund_form);
                                    var arr = this.refund_forms;
                                    this.refund_forms.forEach(function(element,index,arr){
                                        Object.assign(arr[index],{result: false});

                                    });
                                    this.refund_forms = arr;

                                    this.tab_forms.push(
                                        {
                                            title : 'ฟอร์มหมายเลข :' + this.arrFormSelected[i].order,
                                            status : 0
                                        }
                                    );

                                    this.$forceUpdate();
                                })
                                .catch(error=>{
                                    console.log("Refund Form Error :" + error);
                                    this.alert = 'error';
                                })

                            }
                            if (this.arrFormSelected.length > 0){
                                //console.log('array ' + this.arrFormSelected.length);
                                this.alert = 'success';
                                this.tabs[0].status = 1;


                                this.$forceUpdate();

                            }
                            setInterval(function(){
                                //this.tabIndex = 1;

                                //console.log("tab Index   :" + this.tabIndex);
                            },3000);

                        })
                        .catch(error=>{
                            console.log("Refund Error :" + error);
                            this.alert = 'error';
                        })
                    }

                });

            }else{

            }
        },
        onTabChange(value){
            console.log('tab :' + value);
        }
    }
}
</script>
<style scoped>
.tabTitle{
    font-size: 1rem;
    font-weight: bold;
}
.nav-link{
    padding-top: 10px!important;
}

</style>
