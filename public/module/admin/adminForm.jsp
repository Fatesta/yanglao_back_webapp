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
    <form id="adminForm" method="post">
    	<input type="hidden" name="id" value="${admin.id }">
	    <table class="form">
	    	<tr>
	    		<td><label for="username">用户名</label></td>
	    		<td><input class="easyui-textbox" name="username" value="${admin.username}" data-options="required:true,validType:'length[1,100]'<c:if test="${admin.id != null}">,disabled:true</c:if>" ></td>
	    	</tr>
            <tr>
                <td><label for="passwd">密码</label></td>
                <td><input class="easyui-textbox" name="passwd" data-options="required:true,type:'password',validType:'length[6,36]'<c:if test="${admin.id != null}">,disabled:true</c:if>" ></td>
            </tr>
	    	<tr>
	    		<td><label for="realName">姓名</label></td>
	    		<td><input class="easyui-textbox" name="realName" value="${admin.realName}" data-options="required:true,validType:'length[1,100]'" ></td>
	    	</tr>
	    	<tr>
                <td><label for="sex">性别</label></td>
                <td><input class="easyui-combobox" name="sex" value='${admin.sex == null ? "M" : admin.sex}' 
                    data-options="required:true,editable:false,valueField:'label',textField:'value',
                                data:[{label:'M',value:'男'},{label:'W',value:'女'}]" >
                </td>
	    	</tr>
	    	<tr>
	    		<td><label for="phone">手机号</label></td>
	    		<td><input class="easyui-numberbox" name="phone" value="${admin.phone}" data-options="validType:'length[10,11]',precision:0" ></td>
	    	</tr>
	    	<tr>
	    		<td><label for="email">邮箱地址</label></td>
	    		<td><input class="easyui-textbox" name="email" value="${admin.email}" data-options="validType:['email','length[0,50]']" ></td>
	    	</tr>
	    	<c:if test="${admin.id != null}">
	    	<tr>
	    		<td><label for="professor">医生职称</label></td>
	    		<td colspan="3" class="form"><input class="easyui-textbox" name="professor" value="${admin.professor}" data-options="validType:'length[0,100]'" style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="department">医生科室</label></td>
	    		<td colspan="3" class="form"><textarea rows="2" cols="50" class="easyui-validatebox" name="department" data-options="validType:'length[0,100]'" style="width:200px">${admin.department}</textarea></td>
	    	</tr>
	    	</c:if>
	    	<tr>
	    		<td><label for="remark">备注</label></td>
	    		<td colspan="3" class="form"><textarea rows="3" cols="50" class="easyui-validatebox" name="remark" data-options="validType:'length[0,100]'" style="width:200px">${admin.remark}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>