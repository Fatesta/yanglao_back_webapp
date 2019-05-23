import { stringify } from 'qs';


axios.defaults.baseURL = '/';

/* 实现默认使用表单数据格式 */
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
axios.interceptors.request.use(function(config) {
    if (!config.data) {
        return config;
    }
    //这里不能用instanceof，由于使用了iframe，parentOrOtherIframe.Object != thisIframe.Object
    else if (typeof config.data == 'object') {
        config.data = stringify(config.data);
        return config;
    }
    else if (config.data.toString() == '[object FormData]') {
        return config;
    }

    return config;
});

/*
axios默认把data作为其属性的response对象作为参数传递给then回调。
但是根据来自本项目的经验，大部分情况下，我们只要data。
所以下面拦截器实现的是，默认将response.data作为then回调的参数，
如果你需要原response细节，请配置response:true，对于网络异常情况的处理，请使用catch
*/
axios.interceptors.response.use(function(response) {
    return response.config.response ? response : response.data;
});
