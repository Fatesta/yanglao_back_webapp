export default {
  login() {
    sessionStorage.setItem('admin', true);
  },
  logout() {
    sessionStorage.removeItem('admin');
  },
  loggedIn() {
    return sessionStorage.getItem('admin');
  }

};