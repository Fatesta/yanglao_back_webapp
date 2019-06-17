<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<form id="reservationForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="resId" value="${reservation.resId}">
<input type="hidden" name="userId" value="${userIds}">
<input type="hidden" name="userIds" value="${userIds}">
<input type="hidden" name="doctorId" value="${reservation.doctorId}">
<input type="hidden" name="status" value="${reservation.status}">
<table class="form">
    <tr>
    	<td>医生</td>
    	<td>
    		<input class="easyui-textbox" id="selectedDoctor" data-options="required:true,editable:false" value="${reservation.doctorName}"/>
    		<a class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:selectDoctor">选择医生</a></td>
    </tr>
    <tr>
    	<td>预约时间</td>
    	<td><input class="easyui-datebox" data-options="required:true,editable:false" name="reservationTime" value="<fmt:formatDate value='${reservation.reservationTime}' dateStyle='medium' />"/></td>
    </tr>
    <tr>
    	<td>备注</td>
    	<td><textarea class="edit" name="remark" style="width: 400px;height: 100px;">${reservation.remark }</textarea></td>
    </tr>
</table>
</form>
<script>
function selectDoctor(){
	var url = "health/doctorForm.do?mode=${mode}";
	var selectDoctorDlg = openQueryDialog({
	    title: "选择医生",
	    width: 650,
	    height: 480,
	    href: url,
	    buttons:[{
			text:"确定",
			iconCls:'icon-ok',
			handler:function(){
				onSelectedDoctor();
				selectDoctorDlg.dialog("close");
			}
		}]
	});	
}

function onSelectedDoctor() {
	var doctors = $("#doctorGrid").datagrid("getSelections");
	$("#reservationForm [name=doctorId]").val(doctors.map(function(d){ return d.id }).join(","));
	$("#selectedDoctor").textbox('clear').textbox("setValue", doctors.map(function(d){ return d.realName }).join(","));
}
</script>
</body>
</html>