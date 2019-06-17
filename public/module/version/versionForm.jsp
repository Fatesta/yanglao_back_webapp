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
    <form id="versionForm" method="post" enctype="multipart/form-data">
    	<input type="hidden" name="versionId" value="${version.versionId }">
	    <table class="form">
	    	<tr>
	    		<td><label for="versionName">版本名称</label></td>
	    		<td><input class="easyui-textbox" name="versionName" value="${version.versionName}" data-options="required:true,validType:'length[1,50]'" ></td>
	    		<td><label for="versionCode">版本号</label></td>
	    		<td><input class="easyui-numberbox" name="versionCode" value="${version.versionCode}" data-options="required:true,validType:'length[1,50]'" ></td>
	    	</tr>
	    	<tr>
	    		<td><value for="type">版本类型</value></td>
	    		<td><input class="easyui-combobox" name="type" value='${version.type == null ? "0" : version.type}' 
	    			data-options="required:true,editable:false,valueField:'value',textField:'text',
								data:DictMan.items('appVersion'),
								onSelect: function(r){
									var data = new Array();
									if (r.value == 2) {
										data[0] = {value:'teacher',text:'教师'};
										data[1] = {value:'family',text:'家长'};
									} else {
										$('#role').combobox('clear');
									}
									$('#role').combobox('loadData', data);
        						}" >
				</td>
				<td><label for="role">角色类型</label></td>
	    		<td><input id="role" class="easyui-combobox" name="role" value='${version.role == null ? "" : version.role}' 
	    			data-options="editable:false,valueField:'value',textField:'text'" >
				</td>
	    	</tr>
	    	<tr>
				<td><label for="flag">升级类型</label></td>
	    		<td><input class="easyui-combobox" name="flag" value='${version.flag == null ? "0" : version.flag}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'0',value:'非强制升级'},{label:'1',value:'强制升级'}]" >
				</td>
				<td><label for="phoneType">终端类型</label></td>
	    		<td><input class="easyui-combobox" name="phoneType" value='${version.phoneType == null ? "android" : version.phoneType}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'phoneType',value:'android'},{label:'ios',value:'ios'}]" ></td>
	    	</tr>
	    	<tr>
	    		<td><label for="packageFile">安装包</label></td>
	    		<td colspan="3" class="form"><input class="easyui-filebox" style="width: 360px;" name="packageFile" data-options="<c:if test="${version.versionId == null}"></c:if>buttonText:'选择文件',accept:'.apk,.ipa'"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="welcomeImg">欢迎界面图片</label></td>
	    		<td colspan="3" class="form"><input class="easyui-filebox" style="width: 360px;" name="welcomeImg" data-options="buttonText:'选择文件',accept:'image/gif, image/jpeg, image/png'">
	    	</tr>
	    	<tr>
	    		<td><label for="updateLog">更新日志</label></td>
	    		<td colspan="3" class="form"><textarea rows="6" cols="50" class="easyui-validatebox" name="updateLog" data-options="validType:'length[0,2000]'">${version.updateLog}</textarea></td>
	    	</tr>
	    </table>
	</form>
</body>
</html>