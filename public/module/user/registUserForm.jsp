<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <form id="registUserForm" method="post">
        <input type="hidden" name="imagePath" value="${user.imagePath}">

	    <table class="form">
	    	<tr>
	    		<td>用户类型</td>
	    		<td colspan="3">
					<input class="easyui-combobox filter" id="userType" name="userType" style="width: 120px;" data-options="required:true,editable:false">
				</td>
	    	</tr>
	    	<tr>
	    		<td>昵称</td>
	    		<td colspan="3"><input class="easyui-textbox" name="aliasName" data-options="required:true,validType:'length[1,20]'" style="width: 120px;"></td>
	    	</tr>
            <tr>
                <td>姓名</td>
                <td colspan="3"><input class="easyui-textbox" name="realName" value="${user.realName}" data-options="validType:'length[1,20]'" style="width: 120px;"></td>
            </tr>
            <tr>
                <td>性别</td>
                <td colspan="3"><input class="easyui-combobox" name="sex" value='${user.sex == null ? "0" : user.sex}' 
                    data-options="
                            required: true,
                            data: DictMan.items('user.gender'),
                            value: '${user.sex}'" style="width: 120px;">
                </td>
            </tr>
            <tr>
                <td>生日</td>
                <td colspan="3"><input class="easyui-datebox" name="birthday" style="width: 120px;"></td>
            </tr>
            <tr>
                <td>身份证号</td>
                <td colspan="3">
                    <input class="easyui-textbox" name="idcard" data-options="validType:'length[15,18]'" style="width: 170px;">
                </td>
            </tr>
            <tr>
                <td>电话/手机号码</td>
                <td colspan="3"><input class="easyui-numberbox" id="telephone" name="telephone" data-options="invalidMessage:'您输入的手机号不正确或已存在！',validType:{length:[5,20]},precision:0" style="width: 120px;"></td>
            </tr>
            <tr id="trCardCode" style="display:none">
                <td>卡号</td>
                <td colspan="3">
                    <input class="easyui-textbox" id="cardCode" name="deviceCode" data-options="required:false,validType:'length[10,20]'" style="width: 170px;">
                </td>
            </tr>
            <tr id="trDeviceCode" style="display:none">
                <td>设备号</td>
                <td colspan="3">
                    <input class="easyui-textbox" id="deviceCode" name="deviceCode" data-options="required:false,validType:'length[10,20]'" style="width: 170px;">
                </td>
            </tr>
	    	<tr id="trPassword">
	    		<td>密码</td>
	    		<td><input class="easyui-textbox" id="password" name="password" data-options="type:'password',required:true,validType:'length[1,6]'" style="width: 120px;"></td>
	    		<td>确认密码</td>
	    		<td><input class="easyui-textbox" id="repassword"  data-options="type:'password',required:true,validType:{equals:['#password']}" style="width: 120px;"></td>
	    	</tr>
            <tr name="imageTr-todo" style="display:none">
              <td>头像</td>
              <td colspan="3">
                <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${medicalUser.userId == null ? "上传" : "修改"}</a>
              </td>
            </tr>
            <tr name="imageTr-todo" style="display:none">
              <td></td>
              <td colspan="3">
                 <c:if test="${empty user.imagePath}">
                    <c:set var="headUrl" value='${imagePath}medicaluser_head.png' />
                 </c:if>
                 <c:if test="${not empty user.imagePath}">
                    <c:set var="headUrl" value='${user.imagePath}' />
                 </c:if>
                <img id="headImg" src="${headUrl}" width="100" height="100">
              </td>
            </tr>
	    	<tr>
	    		<td>紧急联系人</td>
	    		<td><input class="easyui-textbox" name="name" data-options="required:false,validType:'length[0,50]'" style="width: 120px;"></td>
	    		<td>联系电话</td>
	    		<td><input class="easyui-numberbox" name="contactTel" data-options="required:false,precision:0" style="width: 120px;"></td>
	    	</tr>
	        <tr>
	           <td>属于社区</td>
	           <td colspan="3">
	               <input name="orgId" class="easyui-combotree"
                          style="width: 308px"
	                   data-options="
	                       editable: true,
	                       required: true,
	                       url: '${urlPath}org/listOrg.do',
	                       valueField: 'id',
	                       textField: 'name',
	                       <c:if test="${orgId != 0}">value: ${orgId}</c:if>" />
	           </td>
	        </tr>
	    	<tr>
	    		<td>家庭地址</td>
	    		<td colspan="3">
	    			<textarea rows="3" style="width: 298px;height: 60px;" class="easyui-validatebox" name="address" data-options="validType:'length[0,120]'"></textarea>
				</td>
	    	</tr>
            <tr>
                <td>备注</td>
                <td colspan="3" class="form"><textarea style="width: 298px;height: 60px;" class="easyui-validatebox" name="remark" data-options="validType:'length[0,100]'" style="width: 320px;height: 60px;">${user.remark}</textarea></td>
            </tr>
	    </table>
	</form>
