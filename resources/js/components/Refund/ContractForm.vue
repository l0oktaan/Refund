<template>
    <div class="animated fadeIn">
        <my-alert :AlertType="alert"></my-alert>
        <b-form @submit="onContractSubmit">
            <b-row>
                <b-col sm="12">
                    <b-form-group>
                        <label for="contract_party">ชื่อคู่สัญญา :</label>
                        <b-form-input type="text"
                            placeholder="ชื่อคู่สัญญา"

                            v-model="contract_party"
                        >
                        </b-form-input>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col sm="6">
                    <b-form-group>
                        <label for="contract_no">สัญญาเลขที่ :</label>
                        <b-form-input type="text"
                            placeholder="สัญญาเลขที่"
                            name="contract_no"
                            v-model="contract_no"
                        >
                        </b-form-input>
                    </b-form-group>
                </b-col>
                <b-col sm="6">
                    <b-form-group>
                        <label for="contract_date">สัญญาลงวันที่ :</label>
                        <my-date-picker ref="contract_date" :id="11" :showDate="date_sign" @update="value => contract_date = value"></my-date-picker>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col sm="6">
                    <b-form-group>
                        <label for="budget">วงเงินในสัญญา :</label>
                        <cleave
                            placeholder="วงเงินในสัญญา"
                            name="budget_new"
                            v-model="budget"
                            class="form-control"
                            :options="cleave_options.number">
                        </cleave>
                        <!-- <b-form-input type="text"
                            placeholder="วงเงินในสัญญา"
                            name="budget"
                            v-model="budget"
                        >
                        </b-form-input> -->
                    </b-form-group>
                </b-col>
                <b-col sm="6">
                    <b-form-group>
                        <label for="penalty_per_day">ค่าปรับวันละ :</label>
                        <cleave
                            placeholder="ค่าปรับวันละ"
                            name="penalty_per_day"
                            v-model="penalty_per_day"
                            class="form-control"
                            :options="cleave_options.number">
                        </cleave>
                        <!-- <b-form-input type="text"
                            placeholder="ค่าปรับวันละ"
                            name="penalty_per_day"
                            v-model="penalty_per_day"
                        >
                        </b-form-input> -->
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col sm="6">
                    <b-form-group>
                        <label for="contract_start">วันที่สัญญาเริ่มต้น :</label>
                        <my-date-picker ref="start" :id="1" :showDate="date_start" @update="value => contract_start = value"></my-date-picker>
                    </b-form-group>
                </b-col>
                <b-col sm="6">
                    <b-form-group>
                        <label for="contract_end">วันที่สัญญาสิ้นสุด :</label>
                        <my-date-picker ref="end" :id="2" :showDate="date_end" @update="value => contract_end = value"></my-date-picker>
                    </b-form-group>
                </b-col>
            </b-row>
            <b-row>
                <b-col>
                    <div class="text-center" style="margin-bottom:5px;">
                        <b-button type="submit" variant="primary">บันทึกเงื่อนไข</b-button>
                        <b-button type="reset" variant="danger" @click="clearContract">ยกเลิก</b-button>
                    </div>
                </b-col>
            </b-row>
        </b-form>
        <contract-edit :refund_id="refund_id" v-if="contract_status == 'update'"></contract-edit>
    </div>
</template>
<script>
export default {
    props: ['refund_id'],
    data(){
        return {
            office_id: 2,
            r_id: this.$route.params.id,
            contract_id: 0,
            contract_party: '',
            contract_no: '',
            contract_date: '',
            budget: '',
            penalty_per_day: '',
            contract_start: '',
            contract_end: '',
            date_sign: '',
            date_start: '',
            date_end: '',
            alert: '',
            contract_status: 'new',
            contract: {},
            cleave_options:{
                number: {
                    prefix: '',
                    numeral: true,
                    numeralPositiveOnly: true,
                    noImmediatePrefix: true,
                    rawValueTrimPrefix: true,
                    numeralIntegerScale: 15,
                    numeralDecimalScale: 2
                },
            }
        }
    },
    mounted(){
        this.fetchContract();
        this.$forceUpdate();
    },
    watch: {
        date_start(newDate, oldDate){
            if (this.myDate2 != '' || this.myDate2){

                if (!this.checkDate(newDate,this.myDate2)){
                    this.consider_var1 = oldDate;
                }
            }
        },
        date_end(newDate, oldDate){
            if (this.myDate2 != '' || this.myDate2){
                if (!this.checkDate(this.myDate1,newDate)){
                    this.consider_var2 = oldDate;
                }
            }
        },
    },
    methods: {
        onContractSubmit(e){
            e.preventDefault();
            var contract = {};
            var path = `/api/offices/${this.office_id}/refunds/${this.r_id}/contracts`;
            console.log('contract path : ' + path);
            console.log('contract status : ' + this.contract_status);
            if (this.contract_status == 'new'){

                axios.post(`${path}`,{
                    contract_party: this.contract_party,
                    contract_no:    this.contract_no,
                    contract_date:  this.contract_date,
                    budget:         this.budget,
                    penalty_per_day:this.penalty_per_day,
                    contract_start: this.contract_start,
                    contract_end:   this.contract_end,
                })
                .then(response=>{
                    contract = response.data.data;

                    this.contract_id = contract.id;
                    this.contract_party = contract.contract_party;
                    this.contract_no = contract.contract_no;
                    this.contract_date = contract.contract_date;
                    this.showDatePick('contract_date', contract.contract_date);
                    this.budget = contract.budget;
                    this.penalty_per_day = contract.penalty_per_day;
                    this.showDatePick('start',contract.contract_start);
                    this.showDatePick('end',contract.contract_end);

                    this.contract_start = contract.contract_start;
                    this.contract_end = contract.contract_end;

                    this.contract_status = 'update';
                    this.alert = 'success';
                    this.contract = contract;
                    this.$forceUpdate();
                })
                .catch(error=>{
                    console.log('error :' + error);
                    this.alert = 'error';
                })
            }else{
                path = `/api/offices/${this.office_id}/refunds/${this.r_id}/contracts/${this.contract_id}`;
                axios.put(`${path}`,{
                    contract_party: this.contract_party,
                    contract_no:    this.contract_no,
                    contract_date:  this.contract_date,
                    budget:         this.budget,
                    penalty_per_day:this.penalty_per_day,
                    contract_start: this.contract_start,
                    contract_end:   this.contract_end,
                })
                .then(response=>{
                    contract = response.data.data;
                    this.contract_id = contract.id;
                    this.contract_party = contract.contract_party;
                    this.contract_no = contract.contract_no;
                    this.contract_date = contract.contract_date;
                    this.showDatePick('contract_date', contract.contract_date);
                    this.budget = contract.budget;
                    this.penalty_per_day = contract.penalty_per_day;
                    this.showDatePick('start',contract.contract_start);
                    this.showDatePick('end',contract.contract_end);

                    this.contract_start = contract.contract_start;
                    this.contract_end = contract.contract_end;

                    this.contract_status = 'update';
                    this.alert = 'success';
                    this.contract = contract;
                    this.$forceUpdate();
                })
                .catch(error=>{
                    console.log('error :' + error);
                    this.alert = 'error';
                })
            }

        },
        fetchContract(){
            var contract = {};
            var path = `/api/offices/${this.office_id}/refunds/${this.r_id}/contracts`;
            console.log('contract path: ' + path);
            axios.get(`${path}`)
            .then(response=>{


                console.log('get contract: ' + response.data.data.length);
                if (response.data.data.length > 0){
                    this.contract = response.data.data[0];
                    // this.contract_id = this.contract.id;
                    // this.contract_party = this.contract.contract_party;
                    // this.contract_no = this.contract.contract_no;
                    // this.contract_date = this.contract.contract_date;
                    // this.showDatePick('contract_date',this.contract.contract_date);
                    // this.budget = this.contract.budget;
                    // this.penalty_per_day = this.contract.penalty_per_day;

                    // this.showDatePick('start',this.contract.contract_start);
                    // this.showDatePick('end',this.contract.contract_end);
                    // this.contract_start = this.contract.contract_start;
                    // this.contract_end = this.contract.contract_end;
                    this.showContract();
                    this.contract_status = 'update';
                    this.$forceUpdate();
                }


            })
        },
        showDatePick(refName,value){
            this.$nextTick(() => {
                this.$refs[refName].date = value;
            })
            this.$forceUpdate();
        },
        clearContract(){
            this.contract_id = 0;
            this.contract_party = '';
            this.contract_no = '';
            this.contract_date = '';
            this.budget = '';
            this.penalty_per_day = '';
            this.contract_start = '';
            this.contract_end = '';
        },
        showContract(){

            this.contract_id = this.contract.id;
            this.contract_party = this.contract.contract_party;
            this.contract_no = this.contract.contract_no;
            this.contract_date = this.contract.contract_date;
            this.showDatePick('contract_date',this.contract.contract_date);
            this.budget = this.contract.budget;
            this.penalty_per_day = this.contract.penalty_per_day;

            this.showDatePick('start',this.contract.contract_start);
            this.showDatePick('end',this.contract.contract_end);
            this.contract_start = this.contract.contract_start;
            this.contract_end = this.contract.contract_end;
            this.contract_status = 'update';
            this.$forceUpdate();
        }
    }
}
</script>
<style scoped>

.description{
    font-size: 0.8em!important;
    color: rgb(49, 49, 49);
    margin-left: 20px;
}

.btn{
    padding-top: 5px!important;
    padding-bottom: 5px!important;
    vertical-align: middle!important;
}
.card-header{
    padding: 5px!important;
}
.list{
    padding: 10px!important;

}
.btn-transparent{
    color: black!important;
}
.dropdown-item i{
    color: black!important;
}
.edit_list{
    background-color: rgb(176, 243, 248);
    margin-bottom: 5px!important;
}
.dropdown-item{
    color: black!important;
}
</style>
