<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache,no-store, must-revalidate">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="0">
<title>远程咨询 -【咨询人员端】</title>
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/material/easyui.css">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/myslider/css/myslider.css">
<link rel="stylesheet" type="text/css" href="${modulePath}health/chat/chat.css?v=1.2">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/select/css/select.css">
<style>
#medicalResult{margin-top: 20px; margin-left: 20px;}
#otherSideAction{font-size: 14px}
.title, .tj {
  background-color: ${designStyle.colors.dominant};
}
.tj:hover {
  background-color: ${designStyle.colors.dominant};
  opacity: 0.7;
}
</style>
</head>
<body>
<div class="wc">
    <div class="left">
        <div class="title">
            <div class="person"></div>
            <div class="desc">咨询人员</div>
        </div>
        <div class="list">
            <ul class="type-list" id="userList">
            </ul>
        </div>

    </div>
    <div class="right">
        <div class="title">
            <div class="doc"></div>
            <div class="desc">TA的基本信息</div>
        </div>
        <div class="content">
            <img id="headUrl" src="${urlPath }images/doc_head2.png">
            <div class="desc">
                <table>
                    <tr>
                        <td class="type-icon"><div class="person2"></div></td>
                        <td><span>姓名：</span><span id="userName" class="name2"></span></td>
                        <td><span>性别：</span><span id="sex"></span></td>
                        <td><span>年龄：</span><span id="age"></span></td>
                    </tr>
                    <tr>
                        <td class="type-icon"><div class="tel"></div></td>
                        <td colspan="3"><span>电话：</span><span id="telephone"></span></td>
                    </tr>
                    <tr>
                        <td class="type-icon"><div class="bs"></div></td>
                        <td colspan="3"><span>病史：</span><span id="remark"><a id="viewRemark" href="#" class="easyui-linkbutton" style="display:none">查看</a></span></td>
                    </tr>
                </table>
            </div>
            <div class="edit">
                <a id="editProfile" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">编辑</a>
            </div>
        </div>
        <div class="center">
            <div class="left">
                <div class="top">
                    <div class="title">
                        <div id="videoTitle" class="left-title" style="display:none">
                            您正在与<span id="videoOtherSideName" class="name2" style="color:#5FB0CD;"></span>进行视频咨询
                            <span id="msg"></span>
                        </div>
                    </div>
                    <div class="shiping">
                        <%@ include file="videoCtrl.jsp" %>
                    </div>
                </div>
                <div class="zdyj">
                    <div class="zdyj-title">
                                           医生意见 <span id="otherSideAction"></span>
                    </div>
                    <div id="medicalResult" name="medicalResult"></div>
                </div>
            </div>
            <div class="right">
                <div id="videoSmallColl">
                    <object id="otherVideoObject" classid="clsid:54FC7795-1014-4BF6-8BA3-500C61EC1A05" width="100%" height="100%"></object>
                </div>
                <div id="doctor" style="display:none" >
                    <p><span class="b">姓名：</span><span id="realName"></span></p>
                    <p style="line-height:30px;"><span class="b">科室：</span><span id="department"></span></p>
                    <p style="line-height:30px;"><span class="b">职称：</span><span id="professor"></span></p>
                    <p><span class="b">简介：</span><span id="remark"></span></p>
                </div>
            </div>
        </div>
    </div>
</div>

<iframe id="overlay" src="${urlPath}view/health/chat/overlayContainer.do"></iframe>

<script id="inquiryRecordListTpl" type="text/html">
<iframe id="frame" frameborder=0 scrolling=auto width="100%" height="100%" style="z-index:10000000">
<div style="float: left; font: 16px/18px 微软雅黑;">
{{each list as row index}}
<div>{{row.createTime}}&nbsp;&nbsp;{{row.medicalResult}}</div><br />
{{/each}}
</div>
</iframe>
</script>
<script>
CONFIG = parent.CONFIG;
</script>
<script>
var supportRole = !('<%=request.getParameter("nonSupportRole")%>' == 'true');
</script>
<script src="${libPath}easyui/jquery.min.js"></script>
<script src="${libPath}easyui/jquery.easyui.min.js"></script>
<script src="${libPath}easyui/locale/easyui-lang-zh_CN.js"></script>
<script src="${libPath}utils/signals.min.js"></script>
<script src="${libPath}/jq.extend.js"></script>
<script>jqueryExtend($)</script>
<script src="${libPath}common.js"></script>
<script src="${libPath}template.js"></script>
<script src="${libPath}socket.io.js"></script>
<script src="${libPath}EZUIKit/ezuikit.js"></script>
<script src="${libPath}EZUIKit/ez-common.js"></script>
<script src="${modulePath}health/chat/common.js?v=3.8"></script>
<script src="${modulePath}health/chat/communityVersion.js?v=3.8"></script>

</body>
</html>
