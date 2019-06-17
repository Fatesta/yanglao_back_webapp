<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	    <table id="userBasicInfo" class="form model-form">
            <tr>
                <td style="width:80px">用户类型</td>
                <td id="userType">${user.userType}</td>
            </tr>
	    	<tr>
	    		<td>昵称</td>
	    		<td>${user.aliasName}
                    <c:if test="${user.isvalid != 1}"><span style="color:red">（该用户处于已挂失状态）</span></c:if>
                </td>
	    	</tr>
            <tr>
                <td>姓名</td>
                <td>${user.realName}</td>
            </tr>
            <tr>
                <td>性别</td>
                <td>${(user.sex == null || user.sex == 0) ? '男' : '女'}</td>
            </tr>
            <tr>
                <td>生日</td>
                <td><fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd" /></td>
            </tr>
            <tr>
                <td>年龄</td>
                <td>${empty user.idcard ? '' : user.age}</td>
            </tr>
            <tr>
                <td>身份证号</td>
                <td>${user.idcard}</td>
            </tr>
            <tr>
                <td>手机号码</td>
                <td name="telephone">${user.telphone}</td>
            </tr>

            <c:if test="${user.userType == 2}">
	            <tr>
	                <td>会员卡号</td>
	                <td>${user.deviceCode}</td>
	            </tr>
            </c:if>
            <c:if test="${user.userType == 3}">
                <tr>
                    <td>主机ID</td>
                    <td>${user.deviceCode}</td>
                </tr>
            </c:if>
            <c:if test="${user.userType == 9}">
	            <tr>
	                <td>设备号</td>
	                <td>${user.deviceCode}</td>
	            </tr>
            </c:if>

	    	<tr>
	    		<td>紧急联系人</td>
	    		<td>${user.name}</td>
	    	</tr>
            <tr>
                <td>紧急联系电话</td>
                <td name="contactTel">${user.contactTel}</td>
            </tr>
	    	<tr>
	    		<td>家庭地址</td>
	    		<td>
	    			<span>${user.address}</span>
				</td>
	    	</tr>
            <tr>
                <td>老年卡号</td>
                <td>
                    <span>${user.elderlyCard}</span>
                </td>
            </tr>
	    	<!--
            <tr>
                <td><label for="remark">备注</label></td>
                <td>
                    <textarea style="width: 298px;height: 60px;" class="easyui-validatebox" name="remark" data-options="readonly:true">${user.remark}</textarea>
                </td>
            </tr>  -->
	    </table>

	    <script>
            var userTypeEl = $('#userBasicInfo #userType');
            userTypeEl.text(DictMan.itemMap('user.type')[userTypeEl.text()]);
            ['telephone', 'contactTel'].forEach(function(k) {
                var e = $('#userBasicInfo [name=' + k + ']');
                var s = e.text();
                e.text(s ? (s.substring(0, 3) + ' ' + s.substring(3, 7) + ' ' + s.substring(7, 11)) : s);
            });
	    </script>