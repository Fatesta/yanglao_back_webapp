<%
    String url = request.getRequestURL().toString();
    boolean isProduceMode = url.indexOf("service.loveonline.net.cn") != -1;
    boolean isDevMode = url.indexOf("localhost") != -1 || url.indexOf("127.0.0.1") != -1;
    session.setAttribute("isProduceMode", isProduceMode);
    session.setAttribute("isDevMode", isDevMode);

    final String SYSTEM_NAME = "呼贝智慧养老服务平台";
    session.setAttribute("SYSTEM_NAME", SYSTEM_NAME);
    session.setAttribute("SYSTEM_TITLE",
            isProduceMode ? SYSTEM_NAME : (isDevMode ? "开发版" : "测试版") + "-" + SYSTEM_NAME);
    session.setAttribute("byLogin", true);

%>

<%
com.xtxk.hb.security.model.Admin admin = (com.xtxk.hb.security.model.Admin)session.getAttribute("curAdmin");
if (admin != null && admin.getUsername().equals("jcygl")) {
    String name = "江城义工联呼贝智慧养老平台";
    session.setAttribute("SYSTEM_NAME", name);
    session.setAttribute("SYSTEM_TITLE", name);
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=0.70, user-scalable=no">
	<title>${SYSTEM_TITLE}</title>
    <link rel="shortcut icon" href="./favicon.ico">
	<link rel="stylesheet" type="text/css" href="/index.css?v=20190616">
</head>

<body>
    <div id="app" style="width:100%;height:100%;"></div>

    <script src="${libPath}dicts.js?v=1.4"></script>
    <script src="${libPath}utils/signals.min.js"></script>
    <script>Signal = signals.Signal;</script>
    <script src="${libPath}utils/axios.min.js"></script>
    <script src="${libPath}utils/underscore-min.js"></script>
    <script src="${libPath}utils/moment.min.js"></script>
    <script src="${libPath}easyui/jquery.min.js"></script>
    <script src="${libPath}base64.js"></script>
    <script src="${libPath}utils/observer.js"></script>
    <script src="${libPath}ui/ui.js?v=20190529"></script>
    <script src="${libPath}common.js?v=20190529"></script>

    <script src="/common.js?v=20190612"></script>
    <script src="/lib/utils/require.js"></script>
    <script>
        window.app_version = '20190616';
        require(['/vendors.js?v=2019060417', '/index.js?v=' + window.app_version]);
    </script>
</body>
</html>