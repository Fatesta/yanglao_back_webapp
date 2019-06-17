<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="frmEmployee" method="post">
    	<input type="hidden" name="id" value="${employee.id }">
    	<input type="hidden" name="providerId" value="${employee.providerId}">
    	<input type="hidden" name="bossId" value="">
	    <table class="form">
	    	<tr>
	    		<td><label for="roleId">角色</label></td>
	    		<td>
	    			<select class="easyui-combobox" name="roleId" data-options="
	    				<c:if test='${employee.roleId != null}'>value:'${employee.roleId}',</c:if>
	    				required:true<c:if test="${employee.id != null}">,disabled:true</c:if>", style="width: 250px;">
						<c:if test="${not empty session_role_leaf_fn_map['139']}"><option value="4" selected="selected">管理员</option></c:if>
	    				<c:if test="${not empty session_role_leaf_fn_map['141']}"><option value="3" selected="selected">店员</option></c:if>
	    			</select>
				</td>
	    	</tr>
	    	<tr>
	    		<c:if test="${not empty employee.id}">
	    			<td><label for="username">工号</label></td>
	    			<td><input class="easyui-textbox" name="username" value="${employee.username}" data-options="required:true,validType:'length[1,20]'<c:if test="${employee.id != null}">,disabled:true</c:if>" style="width:250px;"></td>
	    		</c:if>
	    	</tr>
	    	<tr>
	    		<td><label for="realName">姓名</label></td>
	    		<td><input class="easyui-textbox" name="realName" value="${employee.realName}" data-options="required:true,validType:'length[1,50]'" style="width:250px;"></td>
	    	</tr>
	    	<c:if test="${employee.id == null}">
	    	<tr>
	    		<td><label for="passwd">登录密码</label></td>
	    		<td><input class="easyui-textbox" name="passwd" data-options="required:true,type:'password',validType:'length[6,36]'" style="width:250px;"></td>
	    	</tr>
	    	</c:if>
	    	<tr>
	    		<td><label for="sex">性别</label></td>
	    		<td><input class="easyui-combobox" name="sex" value='${employee.sex == null ? "M" : employee.sex}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'M',value:'男'},{label:'W',value:'女'}]" style="width:250px;">
				</td>
	    	</tr>
	    	<tr>
	    		<td><label for="phone">手机号</label></td>
	    		<td><input class="easyui-numberbox" name="phone" value="${employee.phone}" data-options="required:true,validType:'length[11,11]',precision:0" style="width:250px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="email">邮箱地址</label></td>
	    		<td><input class="easyui-textbox" name="email" value="${employee.email}" data-options="required:true,validType:['email','length[0,50]']" style="width:250px;"></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>