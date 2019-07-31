<template>
  <el-container :style="{cursor: submitting && 'wait'}">
    <el-main
      style="
        flex-wrap: wrap;
        justify-content: center;
        display: flex;
        align-items: center;
        position: relative;"
    >
      <div class="login-container">
        <div
          style="
            text-align: center;
            margin-bottom: 28px;
            letter-spacing: 1px;"
        >
          <span
            :style="{
              fontSize: '26px',
              fontWeight: 600,
              color: '#333'
            }">呼贝智慧养老服务平台</span>
          <div
            :style="{
              fontSize: '14px',
              paddingTop: '8px',
              color: '#555'
            }">欢迎使用</div>
        </div>
        <el-form :model="form" :rules="rules" ref="form" label-width="0px" size="large">
          <el-form-item prop="username">
            <el-input
              v-model="form.username"
              placeholder="用户名"
              @keyup.enter.native="onSubmit">
              <el-button slot="prepend" icon="el-icon-user"></el-button>
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input 
              type="password"
              v-model="form.password"
              placeholder="密码"
              @keyup.enter.native="onSubmit">
              <el-button slot="prepend" icon="el-icon-lock"></el-button>
            </el-input>
          </el-form-item>
          <el-form-item class="checkboxes">
            <el-checkbox
              v-model="autoLoginEnabled"
              @change="onAutoLoginChange">自动登陆</el-checkbox>
            <el-checkbox
              v-model="rememberPasswordEnabled"
              @change="onRememberPasswordChange"
              style="float: right;">记住密码</el-checkbox>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" @click="onSubmit" style="width: 100%;" :loading="submitting">登 录</el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-main>
    <el-footer style="text-align: center;position:relative;top:-20px;">
      <el-link
        type="info"
        :underline="false"
        target="_blank"
        href="http://www.loveonline.net.cn/about-us.html"
      >Copyright ©{{ moment().year() }} 武汉亲情互联科技有限公司</el-link>
      <el-link
        type="info"
        :underline="false"
        target="_blank"
        href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=42018502001970"
        style="display: block;line-height: 30px;"
      >鄂公网安备 42018502001970号</el-link>
    </el-footer>
  </el-container>
</template>


<script>
import Vue from 'vue';
import { Container, Main, Footer, Link, Form, FormItem, Alert, Input, Checkbox, Button, Message } from 'element-ui';

import config from '@/config/app.config';
import auth from '@/auth';
import moment from 'moment';
[Container, Main, Footer, Link, Form, FormItem, Alert, Input, Checkbox, Button].forEach(c => {
  Vue.use(c);
});

export default {
  data() {
    return {
      autoLoginEnabled: config.get('autoLoginEnabled'),
      rememberPasswordEnabled: config.get('rememberPasswordEnabled'),
      form: {
        username: config.get('username'),
        password: config.get('password')
      },
      submitting: false,
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      },
      moment
    };
  },
  mounted() {
    if (this.autoLoginEnabled && !window.fromLogout) {
      const username = config.get('username');
      const password = config.get('password');
      if (username && password) {
        setTimeout(() => {
          this.form = { username, password };
          this.$nextTick(() => {
            this.submit();
          });
        }, 100);
      }
    }

    (() => {
      var userAgent = navigator.userAgent;
      if (!(userAgent.indexOf("Firefox") > -1 || userAgent.indexOf("Chrome") > -1)) {
        Message.warning({
          message: `
            检测到您正在使用的不是
            <a href="https://www.baidu.com/s?wd=Chrome"
               target="_blank" style="color: inherit;">谷歌Chrome</a>
            或
            <a href="http://www.firefox.com.cn/"
               target="_blank" style="color: inherit;">Firefox 浏览器</a>，`
            + '为了更好的体验，请优先使用这些浏览器&nbsp;',
          dangerouslyUseHTMLString: true,
          duration: 0,
          showClose: true
        });
      }
    })();
  },
  methods: {
    onAutoLoginChange(checked) {
      this.autoLoginEnabled = checked;
      config.set('autoLoginEnabled', checked);
      if (checked) {
        this.rememberPasswordEnabled = true;
        config.set('rememberPasswordEnabled', true);
      }
    },
    onRememberPasswordChange(checked) {
      this.rememberPasswordEnabled = checked;
      config.set('rememberPasswordEnabled', checked);
      if (!checked) {
        this.autoLoginEnabled = false;
        config.set('autoLoginEnabled', false);
        config.set('password', '');
      }
    },
    onSubmit() {
      this.$refs.form.validate( (valid) => {
        if (valid) {
          this.submit();
        }
      });
    },
    async submit() {
      const { username, password } = this.form;
      this.submitting = true;
      const ret = await this.axios({
        url: 'api/admin/login',
        method: 'post',
        data: `username=${username}&password=${password}`,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
      if (ret.success) {
        config.set('username', username);
        config.set('password', this.rememberPasswordEnabled ? password : '');    
        auth.login();
        this.$router.replace('/');
      } else {
        config.set('password', '');
        Message.error(ret.message);
        this.submitting = false;
      }
    }
  }
}
</script>

<style scoped>
  .el-container {
    width: 100%;
    height: 100%;
  }

  .login-container {
    width: 338px;
    margin: 8% auto;
  }
  .checkboxes {
    position: relative;
    top: -10px;
    height: 20px;
  }
  .el-link {
    font-weight: unset;
  }
</style>