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
        <input type="hidden" name="cardId" value="${cardId}" />
        <input type="hidden" name="serviceCode" value="" />
        <table class="form">
            <tr>
                <td>已选择服务：</td>
                <td id="selected" style="width:20px;overflow:hidden;">未选择</td>
                <td>
                    <a id="selectService" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">选择服务</a>
                </td>
            </tr>
            <tr>
                <td><label for="chkLimitTimes">是否限制使用次数</label></td>
                <td colspan="2"><input id="chkLimitTimes" type="checkbox" checked="true"></td>
            </tr>
            <tr>
                <td>使用次数</td>
                <td>
                    <input id="times" name="times" class="easyui-numberbox" style="width: 100px;"
                        data-options="required:true,precision:0" >
                </td>
                <td id="unit">次</td>
            </tr>
        </table>
    </form>
</body>
</html>