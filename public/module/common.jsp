<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${SYSTEM_TITLE}</title>
<link rel="shortcut icon" href="./favicon.ico">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/material/easyui.css">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/icon.css?v=8.1">
<link rel="stylesheet" type="text/css" href="${cssPath }index.css?v=11.2">
<link rel="stylesheet" type="text/css" href="${cssPath }easyui-prettify.css?v=6.2">
<%@ include file="index-style.jsp" %>
<script src="${libPath}easyui/jquery.min.js"></script>
<script src="${libPath}easyui/jquery.easyui.min.js"></script>
<script src="${libPath}easyui/jquery.extend.js"></script>
<script src="${libPath}jq.extend.js?v=1.1"></script>
<script src="${libPath}easyui/locale/easyui-lang-zh_CN.js"></script>
<script src="${libPath}easyui/locale/extend-lang-zh_CN.js"></script>
<script src="${libPath}easyui/datagrid-filter.js"></script>
<script>
if (window.top.inheritGlobalVars) {
    window.top.inheritGlobalVars(window, window.top);
    window.top.openTab = window.openTab;
}
var CONFIG = {
  "libPath": "/lib/", "baseUrl": '/', "modulePath": "/module/", 'imagePath': '/images/', 'SESSION_EXP': +'${SESSION_EXP}'
};
</script>
