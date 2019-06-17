<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
	    <form id="frmCommunityDepartmentEmployee" method="post">
	        <input type="hidden" name="id" value="${employee.id}">
	        <input type="hidden" name="departmentId" value="${employee.departmentId}">
	        <input type="hidden" name="imagePath" value="${employee.imagePath}">
	        <table class="form">
				<%--
	            <tr>
	              <td>照片</td>
	              <td>
	                <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${employee.id == null ? "上传" : "修改"}</a>
	              </td>
	            </tr>
	            <tr>
	              <td></td>
	              <td>
	                 <c:if test="${empty employee.imagePath}">
	                    <c:set var="headUrl" value='' />
	                 </c:if>
	                 <c:if test="${not empty employee.imagePath}">
	                    <c:set var="headUrl" value='${employee.imagePath}' />
	                 </c:if>
	                <img id="headImg" src="${headUrl}" width="100" height="100">
	              </td>
	            </tr>--%>
	            <tr>
	                <td>姓名</td>
	                <td><input class="easyui-textbox" name="name" value="${employee.name}" data-options="required:true,validType:'length[1,20]'" style="width: 160px;"></td>
	            </tr><!--
	            <tr>
	                <td>性别</td>
	                <td><input class="easyui-combobox" name="sex" value='${employee.sex == null ? "0" : employee.sex}' 
	                    data-options="required:true,editable:false,valueField:'label',textField:'value',
	                                data:[{label:'0',value:'男'},{label:'1',value:'女'}]" style="width: 120px;">
	                </td>
	            </tr>
	            <tr>
	                <td>生日</td>
	                <td><input class="easyui-datebox" name="birthday" value='<fmt:formatDate value="${employee.birthday}" pattern="yyyy-MM-dd" />' style="width: 120px;"></td>
	            </tr>
	            <tr>
	                <td>身份证号</td>
	                <td colspan="3">
	                    <input class="easyui-textbox" name="idcard" value="${employee.idcard}" data-options="validType:'length[15,18]'" style="width: 170px;">
	                </td>
	            </tr>-->
				<tr>
					<td>移动电话</td>
					<td><input class="easyui-textbox"  name="mobile" value="${employee.mobile}" data-options="required:true,invalidMessage:'手机号格式错误！',validType:{length:[5,20]}" style="width: 160px;"></td>
				</tr>
	            <tr>
	                <td>办公电话</td>
	                <td><input class="easyui-textbox" name="telephone" value="${employee.telephone}" data-options="invalidMessage:'手机号格式错误！',validType:{length:[5,20]}" style="width: 160px;"></td>
	            </tr>
				<tr>
					<td>职务</td>
					<td><input class="easyui-textbox" name="position" value="${employee.position}" data-options="required:true" style="width: 160px;"></td>
				</tr>
					<!--
	            <tr>
	                <td>个人简介</td>
	                <td colspan="3">
	                    <textarea rows="5" style="width: 400px;" class="easyui-validatebox" name="resume" data-options="validType:'length[0,120]'">${employee.resume}</textarea>
	                </td>
	            </tr>
	            <tr>
	                <td>学历</td>
	                <td colspan="3">
	                    <input class="easyui-combobox" name="education"
		                    data-options="
		                            required: true,
		                            data: DictMan.items('education'),
		                            value: '${employee.education}'" />
	                </td>
	            </tr>
	            <tr>
	                <td>学历经历</td>
	                <td colspan="3">
	                    <textarea rows="5" style="width: 400px;" class="easyui-validatebox" name="educationalExperience">${employee.educationalExperience}</textarea>
	                </td>
	            </tr>
	            <tr>
	                <td>入职日期</td>
	                <td><input class="easyui-datebox" name="employmentDate" value='<fmt:formatDate value="${employee.employmentDate}" pattern="yyyy-MM-dd" />' style="width: 120px;"></td>
	            </tr>-->
	        </table>
	    </form>
</body>
</html>
