<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="frmUserSensorConfig" method="post">
        <input type="hidden" name="sceneId" value="1">
        <input type="hidden" name="userId" value="${userId}">
        <table class="form">
            <tr>
                <td>区域</td>
                <td>
	                <input class="easyui-combobox" name="location" data-options="required: true" style="width: 200px;">
	            </td>
            </tr>
            <tr>
                <td>传感器类型</td>
                <td>
                    <input class="easyui-combobox" name="sensorType" data-options="required: true,value:'PIR',readonly:true" style="width: 200px;">
                </td>
            </tr>
            <tr>
                <td>防区编号</td>
                <td>
                    <input class="easyui-numberbox" name="defenceArea" data-options="required: true, min:1, max:3" style="width: 200px;">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>