<template>
     <!-- Sidebar -->
            <div class="sidebar">
                <nav class="sidebar-nav">
                    <ul class="nav">
                        <li class="nav-item  nav-dropdown  ">
                            <a class="nav-link  nav-dropdown-toggle " href="#">
                                    เริ่มต้น
                                    </a>
                            <ul class="nav-dropdown-items">
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/ui-kit/">
                                            UI Kit
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/introduction/">
                                            Introduction
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/browsers-devices/">
                                            Browsers & devices
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/javascript/">
                                            JavaScript
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/build-tools/">
                                            Build tools
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/webpack/">
                                            Webpack
                                            </a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link" href="https://coreui.io/docs/getting-started/accessibility/">
                                            Accessibility
                                            </a>
                                </li>
                            </ul>
                        </li>
                        <b-nav vertical>
                            <b-nav-item v-for="(lMenu,index) in leftMenu" :key="index"  :to="lMenu.path"><i :class="lMenu.icon"></i>&nbsp;{{lMenu.menu}}</b-nav-item>                            
                        </b-nav>


                        <li class="nav-item mt-auto">
                            <a class="nav-link nav-link-success" href="https://coreui.io" target="_top">
                                    <i class="nav-icon cui-cloud-download"></i> Download CoreUI</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-danger" href="https://coreui.io/pro/" target="_top">
                                <i class="nav-icon cui-layers"></i> Try CoreUI
                                <strong>PRO</strong>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

</template>
<script>
export default {
    data(){
        return {
            leftMenu: [
                {menu: 'Dashboard', path: '/refund', icon: 'fas fa-globe'}, 
                {menu: 'ข้อมูลหน่วยงาน', path: '/refund/office', icon: 'fa fa-university'},                 
                {menu: 'การถอนคืนฯ', path: '/refund/form', icon: 'fa fa-align-justify'},
            ]
        }
    }
}
</script>

<style scoped>


</style>
