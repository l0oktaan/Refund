<template>
<div class="animated fadeIn">
        <b-row>
            <b-col sm="12">
                <b-card  class="bg-info" v-for="(rule,x_index) in rules" :key="x_index">
                    <div slot="header">
                        <div class="card-header-actions">
                            <b-badge variant="success">Success</b-badge>
                        </div>
                        <i class="fas fa-angle-double-right fa-lg"></i><span> หลักเกณฑ์ {{rule.order}} : {{rule.name}}</span>
                    </div>
                        <consider-check
                            v-for="(consider,index) in rule.considers" :key="index"
                            :consider = "consider"
                        >
                            <toggle-button :value = "false" :sync = "true" :width="60" :height="25"
                                :labels="{checked: 'ใช่', unchecked: 'ไม่ใช่'}"
                                :color="{checked: '#41831b', unchecked: '#7c7c7c'}"
                                style="padding-top:4px; line-height:0px;"
                                v-if="consider.type == 1"

                            />
                            <b-form-input type="text" v-else-if="consider.type == 2" ></b-form-input>
                            <my-date-picker
                                v-else-if="consider.type == 3 && consider.oper > 1"
                                ref="r_date" :id="'d11'"
                                :showDate="date_show" @update="value => date_show = value"
                            ></my-date-picker>
                        </consider-check>
                        <b-card v-for="(sub_rule,y_index) in rule.sub_rules" :key="y_index"
                            :header="'หลักเกณฑ์ ' + rule.order + '.' + sub_rule.order + ' : ' + sub_rule.name"
                            class="bg-primary sub_rule">
                                <consider-check
                                    v-for="(consider,y_index) in sub_rule.considers" :key="y_index"
                                    :consider = "consider"
                                >
                                    <toggle-button :value = "false" :sync = "true" :width="60" :height="25"
                                        :labels="{checked: 'ใช่', unchecked: 'ไม่ใช่'}"
                                        :color="{checked: '#41831b', unchecked: '#7c7c7c'}"
                                        style="padding-top:4px; line-height:0px;"
                                        v-if="consider.type == 1"

                                    />
                                    <b-form-input type="text" v-else-if="consider.type == 2" ></b-form-input>
                                    <my-date-picker
                                        v-else-if="consider.type == 3 && consider.oper > 1"
                                        ref="r_date" :id="'d11'"
                                        :showDate="date_show" @update="value => date_show = value"
                                    ></my-date-picker>
                                </consider-check>
                        </b-card>
                </b-card>
            </b-col>
        </b-row>
    </div>

</template>
<script>
export default {
    props: ['form_id','refund_id','refund_form_id'],
    data(){
        return {
            rules: [],
            refund_detail_list: [],
            date_show: ''
        }
    },
    watch :{

    },
    mounted() {
        this.fetchData();
        this.getRefundDetail();
        this.addResult();
    },
    methods: {
        fetchData(){
            var path = `/api/forms/${this.form_id}/form_rules`;
            axios.get(`${path}`)
            .then(response=>{
                this.rules = response.data.data;
                //this.getSubRule();
            })
        },
        getSubRule(){
            var path = '';
            var id = 0;
            var sub_rule = [];

            this.showRule =[];

            console.log('get sub rule' + this.rules.length);
            for (let i = 0 ; i < this.rules.length ; i++){
                id = this.rules[i].id;
                path = `/api/forms/${this.form_id}/form_rules?sub_of=${id}`;
                console.log('get sub rule path :' + path);
                Object.assign(this.rules[i],{sub_rules: sub_rule});
                axios.get(path)
                .then(response=>{
                    sub_rule = response.data.data;
                    console.log('sub rule ' + id + ': ' + sub_rule.length);

                    if (sub_rule.length > 0){
                        //Object.assign(this.rules[i],{_showDetails: true});
                        Object.assign(this.rules[i],{sub_rules: sub_rule});
                        //return sub_rule;
                    }
                    this.showRule = this.rules;
                    this.$forceUpdate();
                })
                .catch(error=>{

                })
            }
        },
        getRefundDetail(){
            this.refund_detail_list = [];
            var path = `/api/offices/${this.office_id}refunds/${this.refund_id}/refund_forms/${this.refund_form_id}/refund_details`;
            axios.get(`${path}`)
            .then(response=>{
                this.refund_detail_list = response.data.data;
            })
            .catch(error=>{

            })

        },
        fine_detail(consider){

        },
        addResult(){
            var arr = [];

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

.sub_rule_name{
    padding-top: 5px!important;
}
.rule_name{
    margin: 5px!important;
    background-color: #ffffff!important;
}
.card-header{
    padding: 5px!important;
    background-color: #20a8d8;
    color: #ffffff;
    font-size: 1rem!important;
}
.card{
    margin-bottom: 5px!important;
}
.card-body{
    background-color: #ffffff!important;
    padding: 2px!important;
    color: #000!important;
    font-size: 1rem!important;
}
.sub_rule{
    margin: 5px;
}
</style>
