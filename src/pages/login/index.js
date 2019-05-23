import Login from './Login.vue';

if(window.top.location.href != location.href) {
  window.top.location.href = location.href;
}

new Vue({
  el: '#app',
  render: h => h(Login)
});