
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');

window.Vue = require('vue');

import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)


import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue)

//import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import Vuex from 'vuex'
Vue.use(Vuex)

import axios from 'axios'
import VueAxios from 'vue-axios'
//axios.defaults.baseURL = 'http://sajjainfo.com';
//axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
Vue.use(VueAxios, axios)
window.axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest'
};
Vue.use(VueAxios, axios)

import VueSwal from 'vue-swal'
Vue.use(VueSwal)

import Vuelidate from 'vuelidate'
Vue.use(Vuelidate)



import App from './views/App.vue'
import Home from './views/Home.vue'
import Login from './views/Login.vue'
import Refund from './views/Refund.vue'
import Admin from './views/Admin/Admin'
import AdminIndex from './views/Admin/AdminIndex'

import FormIndex from './views/Admin/Form/FormIndex'

const router = new VueRouter({
    mode: 'history',
    base: '/',
    routes: [
        {
            path: '/',
            component: Home,
            meta: {
                breadCrumb: 'หน้าหลัก' //crumb
            }
        },
        {
            path: '/login',
            component: Login,
            meta: {
                breadCrumb: 'เข้าสู่ระบบ' //crumb
            }
        },
        {
            path: '/refund',
            component: Refund,
            meta: {
                breadCrumb: 'หน้าแรก' //crumb
            }
        },
        {
            path: '/admin',
            component: Admin,
            mode: 'history',
            meta: {
                breadCrumb: 'Dashboard' //crumb
            },
            children: [
                {
                    path: '',
                    component: AdminIndex,
                    meta: {
                        breadCrumb: 'Admin' //crumb
                    }
                },
                {
                    path: 'form',
                    component: FormIndex,
                    meta: {
                        breadCrumb: 'จัดการแบบฟอร์ม' //crumb
                    }
                }
            ]
        }
    ]
});
import AdminNav from './components/Admin/AdminNav.vue';
Vue.component('AdminNav', AdminNav).defaults;

import AdminMenu from './components/Admin/AdminMenu.vue';
Vue.component('AdminMenu', AdminMenu).defaults;

import AdminBreadcrumb from './components/Admin/AdminBreadcrumb.vue';
Vue.component('AdminBreadcrumb', AdminBreadcrumb).defaults;

import AdminSide from './components/Admin/AdminSide.vue';
Vue.component('AdminSide', AdminSide).defaults;

import FormFind from './components/Admin/Form/FormFind.vue';
Vue.component('FormFind', FormFind).defaults;

import FormCover from './components/Admin/Form/FormCover.vue';
Vue.component('FormCover', FormCover).defaults;

import FormDetail from './components/Admin/Form/FormDetail.vue';
Vue.component('FormDetail', FormDetail).defaults;

import FormRuleList from './components/Admin/Form/FormRuleList.vue';
Vue.component('FormRuleList', FormRuleList).defaults;

import FormRule from './components/Admin/Form/FormRule.vue';
Vue.component('FormRule', FormRule).defaults;

import MyAlert from './components/MyAlert.vue';
Vue.component('MyAlert', MyAlert).default;

import MyLogin from './components/Login/Login.vue';
Vue.component('MyLogin', MyLogin).default;


const app = new Vue({
    el: '#app',
    components: { App },
    router
});
