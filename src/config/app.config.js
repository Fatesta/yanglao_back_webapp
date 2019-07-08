const defaultConfigValues = {
  autoLoginEnabled: false,
  rememberPasswordEnabled: false,
  theme: 'dark',//light
  size: 'small',
  sideMenuCollapsed: false
};

class Config {
  constructor() {
    //TODO:过一段时间之后删掉
    if (this.get('version') < 20190708) {
      this.set('version', '20190708');
      this.set('theme', 'dark');
    }

    for (let key in defaultConfigValues) {
      if (this.get(key) == null) {
        this.set(key, defaultConfigValues[key]);
      }
    }
  }

  get(key) {
    return JSON.parse(localStorage.getItem(key));
  }

  set(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
  }
}

const config = new Config();
export default config;

const APP_NAME = '呼贝智慧养老服务平台';
export {
  APP_NAME
};