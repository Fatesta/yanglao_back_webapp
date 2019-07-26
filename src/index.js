import Vue from 'vue';
import VueRouter from 'vue-router';
import { Container } from 'element-ui';
import Login from '@/Login.vue';
import auth from '@/auth';
import { APP_NAME } from '@/config/app.config';
import { axios } from '@/api';
import VueAxios from 'vue-axios';

Vue.use(VueRouter);
Vue.use(VueAxios, axios);
Object.assign(Vue.prototype, {
  document: window.document,
  DictMan: window.DictMan
});

const router = new VueRouter({
  mode: 'hash',
  base: __dirname,
  routes: [
    {
      path: '/',
      component: () => ({
        component: import('@/App.vue'),
        loading: Container,
        delay: 0
      }),
      beforeEnter(to, from, next) {
        if (auth.loggedIn()) {
          next();
        } else {
          next('/login');
        }
      }
    },
    {
      path: '/login',
      component: Login
    },
    {
      path: '/logout',
      beforeEnter(to, from, next) {
        auth.logout();
        window.fromLogout = true;
        axios.post('api/admin/logout');
        next('/login');
      }
    }
  ]
});

var app = new Vue({
  render(h) {
    return h('router-view');
  },
  router,
});
app.$mount('#app');

// 设置 title
document.title = APP_NAME;

const runEnv = location.hostname.startsWith('service') ?
  'production' : ['localhost', '127.0.0.1'].includes(location.hostname) ? 'development' : 'testing';
window.RUN_ENV = runEnv;
if (runEnv !== 'production') {
  document.title = (runEnv === 'development' ? '开发版' : '测试版') + '-' + document.title;
}

