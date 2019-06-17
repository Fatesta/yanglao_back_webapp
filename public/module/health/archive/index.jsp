<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <link rel="stylesheet" type="text/css" href="${modulePath}health/archive/index.css?v=1.1">
</head>
<body class="easyui-layout">
    <div id="basicInfo" data-options="region: 'north'" style="margin-top: 1px; height:275px;">
        <table class="info-form">
            <caption>基本信息</caption>
            <tr>
                <th style="width: 60px">姓名</th>
                <td style="width:40px">
                    <span name="realName" class="value"></span>
                </td>
                <th style="width: 60px">性别</th>
                <td name="gender" class="value" style="width:40px"></td>
            </tr>
            <tr>
                <th style="width: 60px">年龄</th>
                <td name="age" class="value" style="width:40px"></td>
                <th style="width: 60px">出生日期</th>
                <td name="birthday" class="value"  style="width:90px"></td>
            </tr>
            <tr>
                <th>联系电话</th>
                <td name="telphone" class="value" style="width:100px"></td>
                <th>身份证号码</th>
                <td name="idcard" class="value" style="width:150px"></td>
            </tr>
            <tr>
                <th>紧急联系人</th>
                <td name="contactName" class="value" style="width:140px"></td>
                <th style="width: 80px">紧急联系电话</th>
                <td name="contactTel" class="value" style="width:100px"></td>
            </tr>
            <tr>
                <th>所属社区</th>
                <td name="orgName" class="value" style="width:140px"></td>
                <th>家庭地址</th>
                <td name="address" class="value" style="width:400px"></td>
            </tr>
            <tr>
                <th>备注</th>
                <td name="remark" class="value" style="width:140px" colspan="3"></td>
            </tr>
        </table>
        <a id="selectUser" class="easyui-linkbutton"
           data-options="iconCls: 'icon-search'"
           style="position: absolute;left: 808px;top: 4px;">选择用户</a>
    </div>
    <div data-options="region: 'center'">
        <div id="tabs" class="easyui-tabs" data-options="title:'', fit: true">
            <div data-options="title:'健康数据'">
                <jsp:include page="/view/health/archive/healthData.do" />
            </div>
            <div data-options="title:'疾病史'" data-history_type="disease_history"></div>
            <div data-options="title:'家族史'" data-history_type="family_history"></div>
            <div data-options="title:'用药史'" data-history_type="medication_history"></div>
            <div data-options="title:'过敏史'" data-history_type="allergic_history"></div>
            <div data-options="title:'手术史'" data-history_type="operation_history"></div>
            <div data-options="title:'健康告警记录'">
                <table id="alarmHistory" class="easyui-datagrid">
                    <thead>
                        <tr>
                            <th data-options="field:'remark',halign:'center',align:'left',width:'600'">告警信息</th>
                            <th data-options="field:'createTime',halign:'center',align:'center',width:'130'">告警时间</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <script>
        var userId = '${userId}';
    </script>
    <script src="${modulePath}user/select.js"></script>
    <script src="${modulePath}health/archive/index.js?v=1.4"></script>
</body>
</html>

