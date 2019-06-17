<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<form id="frmHandleAlarm" method="post">
		<input type="hidden" name="deviceStatId" value="${deviceStat.id}">
		<input type="hidden" name="deviceId" value="${deviceStat.deviceId}">
		<input type="hidden" name="dangerType" value="${deviceStat.dangerType}">
		<input type="hidden" name="ignore" value="0">
		<table class="form">
			<tr>
				<td>照片</td>
	    		<td>
	    			<c:if test="${user.imagePath != null}">
		    			<img src="${user.imagePath}" style="max-width:180px;max-height:140px">
		    		</c:if>
		    		<c:if test="${user.imagePath == null}">[无]</c:if>
	    		</td>
    		</tr>
		 	<tr>
		 		<td>姓名</td>
		 		<td>${user.realName != null ? user.realName : '[无]'}</td>
		 	</tr>
		 	<tr>
		 		<td>昵称</td>
		 		<td>${user.aliasName}</td>
		 	</tr>
		 	<tr>
		 		<td>性别</td>
		 		<td>${user.sex == 0 ? "男" : "女"}</td>
		 	</tr>
		 	<tr>
		 		<td>手机号</td>
		 		<td>${user.telphone}</td>
		 	</tr>
		 	<tr>
		 		<td>住址</td>
		 		<td>${user.address != null ? user.address : '[无]'}</td>
		 	</tr>
		 	<tr>
		 		<td>紧急联系人</td>
		 		<td>${user.name != null ? user.name : '[无]'}</td>
		 	</tr>
		 	<tr>
		 		<td>联系电话</td>
		 		<td>${user.contactTel != null ? user.contactTel : '[无]'}</td>
		 	</tr>
		 	<tr style="color:red">
		 		<td>告警</td>
		 		<td>${deviceStat.remark}</td>
		 	</tr>
	    	<tr>
	    		<td>处理措施</td>
	    		<td>
	    			<textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="operation" data-options="validType:'length[0,2000]'"></textarea>
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="chkIgnore">忽略同类型消息</label></td>
	    		<td>
	    			<input id="chkIgnore" name="chkIgnore" type="checkbox"><span style="display:inline;color:red">
	    			(选择后当天23:59:59分前
	    			<c:choose>
	    				<c:when test="${deviceStat.dangerType == 1}">离线</c:when>
	    				<c:when test="${deviceStat.dangerType == 2}">离开安全区域</c:when>
	    				<c:when test="${deviceStat.dangerType == 4}">低电量</c:when>
	    			</c:choose>
	    			消息不再提示)</span>
	    		</td>
	    	</tr>
		</table>
	</form>
	
	<script>
	if("${deviceStat.id}" == "") {
	    dlgHandleAlarm.dialog("close");
	}
	
	$("#chkIgnore").change(function(){
	    $("[name=ignore]").val(+ $(this).prop("checked"));
	});
	</script>
</body>
</html>