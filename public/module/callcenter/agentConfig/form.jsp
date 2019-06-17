<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post">
        <input type="hidden" name="adminId" />
        <table class="form">
            <tr>
               <td>用户</td>
               <td id="selectAdmin" >
                   <input id="adminUsername" class="easyui-textbox" readonly style="width: 100px;">
               </td>
            </tr>
            <tr>
               <td>坐席</td>
               <td id="selectAgent" >
                   <input name="loginName" class="easyui-combobox"
	                   data-options="
	                   url: '${urlPath}callcenter/agentConfig/agents.do',
	                   valueField: 'loginName',
	                   textField: 'displayName'"
                   style="width: 100px;">
               </td>
            </tr>
        </table>
    </form>
</body>
</html>