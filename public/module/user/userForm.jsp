<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <form id="userForm" method="post">
        <input type="hidden" name="userId" value="${user.userId }">
    	<input type="hidden" name="appUserId" value="${user.userId }">
    	<input type="hidden" name="userType" value="${user.userType }">
	    <table class="form">
	    	<tr>
	    		<td>昵称</td>
	    		<td colspan="3"><input class="easyui-textbox" name="aliasName" value="${user.aliasName}" data-options="required:true,validType:'length[1,20]'" style="width: 120px;"></td>
	    	</tr>
	    	<tr>
                <td>姓名</td>
                <td colspan="3"><input class="easyui-textbox" name="realName" value="${user.realName}" data-options="validType:'length[1,20]'" style="width: 120px;"></td>
	    	</tr>
	    	<tr>
	    		<td>性别</td>
	    		<td colspan="3"><input class="easyui-combobox" name="sex"
	    			data-options="
                            required: true,
                            data: DictMan.items('user.gender'),
                            value: '${user.sex}'" style="width: 120px;">
				</td>
	    	</tr>
            <tr>
                <td>身份证号</td>
                <td colspan="3">
                    <input class="easyui-textbox" name="idcard" value="${user.idcard}" data-options="validType:'length[15,18]'" style="width: 170px;">
                </td>
            </tr>
            <tr>
                <td>电话/手机号码</td>
                <td colspan="3"><input class="easyui-numberbox" id="telephone" name="telephone" value="${user.telphone}" data-options="<c:if test="${user.userType == 0 || user.userType == 1}">required:true,</c:if>invalidMessage:'手机号格式错误！',validType:{length:[5,20]},precision:0" style="width: 120px;"></td>
            </tr>
	    	<tr>
				<td>生日</td>
	    		<td colspan="3"><input class="easyui-datebox" name="birthday" value='<fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd" />' style="width: 120px;"></td>
	    	</tr>
            <tr name="imageTr" style="display:none">
              <td>头像</td>
              <td colspan="3">
                <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${medicalUser.userId == null ? "上传" : "修改"}</a>
              </td>
            </tr>
            <tr name="imageTr" style="display:none">
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
	    		<td><input class="easyui-textbox" name="name" value="${user.name}" data-options="required:false,validType:'length[0,50]'" style="width: 120px;"></td>
	    		<td>紧急联系电话</td>
	    		<td><input class="easyui-numberbox" name="contactTel" value="${user.contactTel}" data-options="required:false,precision:0" style="width: 120px;"></td>
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
                           <c:if test="${user.orgId != 0}">,value: ${user.orgId}</c:if>" />
               </td>
            </tr>
            <tr>
                <td>家庭地址</td>
                <td colspan="3">
                    <textarea rows="3" style="width: 320px;height: 60px;" class="easyui-validatebox" name="address" data-options="validType:'length[0,120]'">${user.address}</textarea>
                </td>
            </tr>
	    </table>
	</form>
