import VueRouter from 'vue-router';
import './components/index'; // 公共vue组件，应全部打包到本入口文件只有一份
import Login from '@/pages/Login.vue';
import App from '@/pages/app/App.vue';
import auth from '@/auth';
import * as globalvars from './globalvars';
import '@/api';

Vue.use(VueRouter);

Object.assign(Vue.prototype, globalvars.default);

var app = new Vue({
  render(createElement) {
    const h = createElement;
    return h('router-view', {class: 'view'});
  },
  router: new VueRouter({
    mode: 'hash',
    base: __dirname,
    routes: [
      {
        path: '/',
        component: App,
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
  }),
});
app.$mount('#app');