<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="frmBoss" method="post">
        <input type="hidden" name="moneyType" value="1">
    	<input type="hidden" name="id" value="${boss.id }">
	    <table class="form">
	    	<tr>
	    		<c:if test="${not empty boss.id}">
	    			<td><label for="username">工号</label></td>
	    			<td><input class="easyui-textbox" name="username" value="${boss.username}" data-options="required:true,validType:'length[1,20]'<c:if test="${boss.id != null}">,disabled:true</c:if>" style="width:100px;"></td>
	    		</c:if>
	    	</tr>
	    	<tr>
	    		<td><label for="realName">姓名</label></td>
	    		<td><input class="easyui-textbox" name="realName" value="${boss.realName}" data-options="required:true,validType:'length[1,50]'" style="width:100px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="sex">性别</label></td>
	    		<td><input class="easyui-combobox" name="sex" value='${boss.sex == null ? "M" : boss.sex}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'M',value:'男'},{label:'W',value:'女'}]" style="width:40px;">
				</td>
	    	</tr>
	    	<tr>
	    		<td><label for="phone">手机号</label></td>
	    		<td><input class="easyui-numberbox" name="phone" value="${boss.phone}" data-options="required:true,validType:'length[11,11]',precision:0" style="width:90px;"></td>
	    	</tr>
            <c:if test="${boss.id == null}">
            <tr>
                <td><label for="passwd">登录密码</label></td>
                <td><input class="easyui-textbox" name="passwd" data-options="
                    required:true,type:'password',validType:'length[6,36]'" style="width:90px;"></td>
            </tr>
            </c:if>
	    	<tr>
	    		<td><label for="email">邮箱地址</label></td>
	    		<td><input class="easyui-textbox" name="email" value="${boss.email}" data-options="required:true,validType:['email','length[0,50]']" style="width:160px;"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="orgId">组织</label></td>
	    		<td>
	    			<input class="easyui-combotree" name="orgIds" style="width:250px;"
        				data-options="required:true,
				            	valueField:'id',
				            	textField:'text',
				            	url:'${urlPath }admin/listOrg.do',
				            	value:'${boss.orgIds}',
				            	checkbox: true,
                                multiple: true,
                                cascadeCheck: false" />
	    		</td>
	    	</tr>
	    </table>
	</form>
</body>
</html>