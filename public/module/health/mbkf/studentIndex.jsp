<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
    <input name="classesId" value="${classesId}" type="hidden">
	<table class="form">
	   <tr>
            <td>昵称</td>
            <td>
                <input class="easyui-textbox filter" name="aliasName" type="text">
            </td>
            <td>手机号</td>
            <td>
                <input class="easyui-textbox filter" name="telephone" type="text">
            </td>
            <td>设备号</td>
            <td>
                <input class="easyui-textbox filter" name="deviceCode" type="text">
            </td>
           <c:forEach var="func" items="${ROLE_FUNCS}">
               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
           </c:forEach>
		</tr>
	</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}mbkf/student/page.do',
                  queryParams: {classesId: '${classesId}'},
                  singleSelect:false,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'aliasName', width:'8%', halign:'center'">昵称</th>
            <th data-options="field:'sex', width:'3%', halign:'center', formatter: UICommon.datagrid.formatter.gender">性别</th>
            <th data-options="field:'telephone', width:'7%', halign:'center'">手机号码</th>
            <th data-options="field:'deviceCode', width:'10%', halign:'center'">设备号</th>
            <th data-options="field:'idcard', width:'10%', halign:'center'">身份证</th>
            <th data-options="field:'address', width:'20%', halign:'center',formatter:UICommon.datagrid.formatter.wraptip">家庭地址</th>
            <th data-options="field:'createTime', width:'10%', halign:'center'">创建时间</th>
        	</tr>
    </thead>
</table>

<script>
var PAGE_CONFIG = {classesId: '${classesId}'};
</script>
<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}health/mbkf/student.js"></script>

</body>
</html>