<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

	<form id="deviceForm" method="post">
		<input type="hidden" name="userId" value="${device.deviceId }">
		<input type="hidden" name="deviceId" value="${device.deviceId }">
		<table class="form">
	    	<tr>
	    		<td>昵称</td>
	    		<td colspan="3"><input class="easyui-textbox" name="aliasName" value="${device.aliasName}" data-options="required:true,validType:'length[1,50]'" style="width: 120px;"></td>
	    	</tr>
            <tr>
                <td>姓名</td>
                <td colspan="3"><input class="easyui-textbox" name="realName" value="${device.realName}" data-options="validType:'length[1,20]'" style="width: 120px;"></td>
            </tr>
	    	<tr>
	    		<td>性别</td>
	    		<td colspan="3"><input class="easyui-combobox" name="sex" value='${device.sex == null ? "0" : device.sex}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'0',value:'男'},{label:'1',value:'女'}]" style="width: 120px;">
				</td>
	    	</tr>
	    	<tr>
                <td>生日</td>
                <td colspan="3"><input class="easyui-datebox" name="birthday" value='<fmt:formatDate value="${device.birthday}" pattern="yyyy-MM-dd" />' style="width: 120px;"></td>
	    	</tr>
            <tr>
                <td>身份证号</td>
                <td colspan="3">
                    <input class="easyui-textbox" name="idcard" value="${device.idcard}" data-options="validType:'length[15,18]'" style="width: 170px;">
                </td>
            </tr>
            <tr>
                <td>手机号</td>
                <td colspan="3"><input class="easyui-numberbox" name="telephone" value="${device.telphone}" data-options="validType:'length[3,11]',precision:0" style="width: 120px;"></td>
            </tr>
	    	<tr>
	    		<td>开启语音识别</td>
	    		<td colspan="3"><input class="easyui-combobox" name="speechRecognitionStatus" value='${device.speechRecognitionStatus == null ? "0" : device.speechRecognitionStatus}' 
	    			data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'0',value:'否'},{label:'1',value:'是'}]" style="width: 120px;">
				</td>
	    	</tr>
	    	<tr>
                <td>语言种类</td>
                <td colspan="3"><input class="easyui-combobox" name="language" value='${device.language == null ? "zh" : device.language}' 
                    data-options="required:true,editable:false,valueField:'label',textField:'value',
                                data:[{label:'zh',value:'普通话'},{label:'ct',value:'粤语'}]" style="width: 120px;">
                </td>
	    	</tr>
	    	<tr>
	    		<td>期望计步数</td>
	    		<td colspan="3"><input class="easyui-numberbox" name="expectStep" value="${device.expectStep}" data-options="required:true,min:0,precision:0" style="width: 120px;"></td>
	    	</tr>
	    	<tr>
	    		<td>紧急联系人</td>
	    		<td><input class="easyui-textbox" name="name" value="${device.contactName}" data-options="validType:'length[0,50]'" style="width: 120px;"></td>
	    		<td>紧急联系号码</td>
	    		<td><input class="easyui-textbox" name="contactTel" value="${device.contactTel}" data-options="validType:'length[0,20]'" style="width: 120px;"></td>
	    	</tr>
            <tr>
	            <td>属于社区</td>
	            <td colspan="3">
	                <input name="orgId" class="easyui-combobox"
	                    data-options="
	                        required: true,
	                        url: '${urlPath}org/communities.do',
	                        valueField: 'id',
	                        textField: 'name'
	                        <c:if test="${device.orgId != 0}">,value: ${device.orgId}</c:if>" />
	            </td>
            </tr>
            <tr>
                <td>家庭地址</td>
                <td colspan="3">
                    <textarea rows="3" style="width: 298px;height: 60px;" class="easyui-validatebox" name="address" data-options="validType:'length[0,120]'" style="width: 298px;">${device.address}</textarea>
                </td>
            </tr>
	    </table>
	</form>
