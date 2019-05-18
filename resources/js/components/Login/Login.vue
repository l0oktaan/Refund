<template>

  <div class="app flex-row align-items-center">
    <div class="container">
      <b-row class="justify-content-center">
        <b-col md="8">
          <b-card-group>
            <b-card no-body class="text-white bg-primary py-5 d-md-down-none" style="width:44%">
              <b-card-body class="text-center">
                <div>
                    <b-img center src="/images/cgd_white.png" fluid alt="Responsive image"></b-img>
                    <h4>ระบบถอนคืนเงินรายได้แผ่นดิน</h4>              
                </div>
              </b-card-body>
            </b-card>
            <b-card no-body class="p-4">
              <b-card-body >
                <div class="animated fadeIn">
                <b-form v-if="state=='username'">
                    <b-row>
                        <b-col>
                            <p class="text-muted">ใส่รหัสผู้ใช้งานระบบ</p>
                            <b-input-group class="mb-3">
                                <b-input-group-prepend><b-input-group-text><i class="icon-user"></i></b-input-group-text></b-input-group-prepend>
                                <b-form-input type="text" class="form-control" placeholder="รหัสผู้ใช้งาน" autocomplete="username email" />
                            </b-input-group> 
                        </b-col>
                    </b-row>                 
                    <b-row>
                        <b-col class="text-center align-bottom">
                            <b-button variant="primary" @click="state='password'">เข้าสู่ระบบ</b-button>
                        </b-col>
                        
                    </b-row>
                </b-form>
                </div>
                <div class="animated fadeIn">
                <b-form v-if="state=='password'">
                    <b-row>
                        <b-col>
                            <p class="text-muted">ใส่รหัสผ่าน</p>
                            <b-input-group class="mb-3">
                                <b-input-group-prepend><b-input-group-text><i class="icon-lock"></i></b-input-group-text></b-input-group-prepend>
                                <b-form-input type="password" class="form-control" placeholder="รหัสผ่าน" />
                            </b-input-group> 
                        </b-col>
                    </b-row>                 
                    <b-row>
                        <b-col class="text-center align-bottom">
                            <b-button variant="primary" @click="state='username'" >เข้าสู่ระบบ</b-button>
                        </b-col>
                        
                    </b-row>
                </b-form>
                </div>
              </b-card-body>
            </b-card>            
          </b-card-group>
        </b-col>
      </b-row>
    </div>
  </div>
  
</template>
<script>
export default {
    data(){
        return {
            state: 'username'
        }
    }
}
</script>

<style scoped>
img{
    max-width: 150px;
    margin-bottom: 15px!important;
}
</style>
