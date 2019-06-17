<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
label {
	width: 60px;
}
</style>
</head>
<body>
	<form id="serviceResourceForm" method="post">
		<input type="hidden" name="id" value="${serviceResource.id }">
		<table class="form">
			<tr>
				<td><label for="orgName">资源名称</label></td>
				<td><input class="easyui-textbox" name="orgName"
					data-options="value:'${serviceResource.orgName}',required:true,validType:'length[1,100]'"></td>
				<td><label for="serviceType">服务类型</label></td>
				<td><select class="easyui-combobox"
					name="serviceType" style="width: 135px;"
					data-options="
          url: '/dict/items.do?dictName=serviceResource.type',
          textField: 'value',
          valueField: 'key',
          value:'${serviceResource.serviceType}',required:true">
				</select></td>
			</tr>
			<tr>
				<td><label for="contactName">联系人</label></td>
				<td><input class="easyui-textbox"
					name="contactName"
					data-options="value:'${serviceResource.contactName}',validType:'length[0,50]'"></td>
				<td><label for="contactTel">手机号</label></td>
				<td><input class="easyui-numberbox"
					name="contactTel" value="${serviceResource.contactTel}"
					data-options="validType:'length[11,11]',precision:0"></td>
			</tr>
			<tr>
				<td><label for="contactFixPhone">固话</label></td>
				<td><input class="easyui-textbox"
					name="contactFixPhone" value="${serviceResource.contactFixPhone}"
					data-options="validType:'length[0,20]'"></td>
				<td><label for="city">城市</label></td>
				<td><input class="easyui-combobox" name="city"
					style="width: 135px;"
					data-options="valueField:'text',textField:'text',url:'${libPath}json/city.json',value:'${serviceResource.city}',required:true">
				</td>
			</tr>
			<tr>
				<td><label for="aliasName">地址</label></td>
				<td colspan="3" class="form"><input class="easyui-textbox"
					name="address" value="${serviceResource.address}"
					data-options="required:true,validType:'length[1,120]'"
					style="width: 350px;"></td>
			</tr>
			<tr>
				<td><label for="remark">备注</label></td>
				<td colspan="3" class="form"><textarea style="width: 350px;"
						rows="5" class="easyui-validatebox" name="remark"
						data-options="validType:'length[0,255]'">${serviceResource.remark}</textarea></td>
			</tr>
		</table>
	</form>
</body>
</html>