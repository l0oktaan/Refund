<template>
    <b-col sm="12" md="6">
        <transition name="fade">
            <b-card no-body class="bg-primary">
            <b-card-body class="pb-0">
                <b-dropdown class="float-right" variant="transparent p-0" right>
                <template slot="button-content">
                    <i class="icon-settings"></i>
                </template>
                <b-dropdown-item><i class="fas fa-align-justify"></i>&nbsp;แสดงแบบฟอร์ม</b-dropdown-item>
                <b-dropdown-item @click="showForm"><i class="fas fa-edit"></i>&nbsp;แก้ไขแบบฟอร์ม</b-dropdown-item>
                <b-dropdown-item @click="delForm"><i class="fas fa-trash"></i>&nbsp;ลบแบบฟอร์ม</b-dropdown-item>
                </b-dropdown>
                <h4 class="mb-0">ฟอร์มหมายเลข {{order}}</h4>
                <p>{{name3}}</p>


            </b-card-body>

            </b-card>
            <!-- <b-card class="bg-default" no-body v-if="show">
                <div slot="header">
                    แบบฟอร์ม หมายเลข 1
                    <div class="card-header-actions">
                    <b-link href="#" class="card-header-action btn-setting">
                        <i class="icon-settings"></i>
                    </b-link>
                    <b-link class="card-header-action btn-minimize" v-b-toggle.collapse1>
                        <i class="icon-arrow-up"></i>
                    </b-link>
                    <b-link href="#" class="card-header-action btn-close" v-on:click="show = !show">
                        <i class="icon-close"></i>
                    </b-link>
                    </div>
                </div>
                <b-collapse id="collapse1" visible>
                    <b-card-body>
                        <div>
                            <span>ชื่อฟอร์ม :</span>
                        </div>
                        <div>
                            <span>ชื่อฟอร์ม :</span>
                        </div>
                        <div class="text-center">
                            <button type="button" class="btn btn-outline-primary btn-sm"><i class="fas fa-align-justify"></i>&nbsp;แสดงฟอร์ม</button>
                            <button type="button" v-b-modal.modal-1 class="btn btn-outline-success btn-sm"><i class="fas fa-edit"></i>&nbsp;แก้ไข</button>
                            <button type="button" class="btn btn-outline-danger btn-sm"><i class="fas fa-trash"></i>&nbsp;ลบฟอร์ม</button>
                        </div>
                    </b-card-body>
                </b-collapse>
            </b-card> -->

        </transition>

    </b-col>

</template>
<script>
export default {
    props : ['form_id','name1','name3','order'],
    data(){
        return {
            select_id: 0,
            show: true,

        }
    },
    methods: {
        showForm(){
            //var modalName = 'modal-1' + this.form_id;
            //this.$refs[modalName].show()
            //this.select_id = this.form_id;
            //this.$root.$emit('onShowForm');
            //this.$root.$emit('bv::show::modal', 'modalForm');
            this.$emit('onShowForm',this.form_id);
            //this.$router.push('forms/' + this.form_id)  ;
        },
        delForm(){
            this.$swal({
                    title: "กรุณายืนยันการลบแบบฟอร์ม",
                    text: "หากยืนยันการลบ หลักเกณฑ์และเงื่อนไขจะถูกลบไปด้วย",
                    icon: "error",
                    closeOnClickOutside: false,
                    buttons: [
                        'ยกเลิก',
                        'ยืนยัน'
                    ],

                }).then(isConfirm =>{
                    if (isConfirm){
                        let path = `/api/forms/${this.form_id}`;
                        axios.delete(path)
                        .then(response=>{
                            this.$emit('fetchForm');
                        })
                    }

                });
        },
    }
}
</script>
<style scoped>
.btn{
    padding-left: 15px!important;
    padding-right: 15px!important;

}
.bg-primary{
    background-color: #20a8d8 !important;
}
.card-body{
    color: #fff!important;
}
.dropdown-item>i{
    color: #000!important;
}
</style>
