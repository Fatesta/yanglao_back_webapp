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
    <form id="feedbackForm" method="post">
    	<input type="hidden" name="serialId" value="${feedback.serialId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="type">类型</label></td>
	    		<td>
	    			<input class="easyui-combobox" name="type" value="${feedback.type}" data-options="required:true,
	    				valueField:'id',textField:'text',
	    				data:[{
							id: '1',
							text: 'BUG'
						},{
							id: '2',
							text: '建议'
						}]">
	    		</td>
	    		<td><label for="contactType">联系方式</label></td>
	    		<td>
	    			<input class="easyui-combobox" name="contactType" value="${feedback.contactType}" data-options="required:true,
	    				valueField:'id',textField:'text',
	    				data:[{
							id: '1',
							text: 'QQ'
						},{
							id: '2',
							text: '微信'
						},{
							id: '3',
							text: '手机'
						}]">
				</td>
	    	</tr>
	    	<tr>
	    		<td><label for="contactNumber">联系号码</label></td>
	    		<td><input class="easyui-textbox" name="contactNumber" value="${feedback.contactNumber}" data-options="required:true,validType:'length[1,50]'" ></td>
	    		<td><label for="phoneModel">手机型号</label></td>
	    		<td><input class="easyui-textbox" name="phoneModel" value='${feedback.phoneModel}' >
				</td>
	    	</tr>
	    	<tr>
	    		<td><label for="remark">备注</label></td>
	    		<td colspan="3" class="form"><textarea rows="3" cols="50" class="easyui-validatebox" name="remark" data-options="validType:'length[0,2000]'">${feedback.remark}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>