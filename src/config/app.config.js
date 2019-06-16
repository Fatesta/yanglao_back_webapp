const defaultConfigValues = {
  autoLoginEnabled: false,
  rememberPasswordEnabled: false,
  theme: 'light',//dark
  sideMenuCollapsed: false
};

class Config {
  constructor() {
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
