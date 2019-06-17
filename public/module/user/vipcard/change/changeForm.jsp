<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<form id="vipCardUserChangeCardForm" method="post">
    <input type="hidden" name="userId" value="${user.userId }">
    <table class="form">
        <tr>
            <td>昵称</td>
            <td>${user.aliasName}</td>
        </tr>
        <tr>
            <td>身份证号</td>
            <td>${user.idcard}</td>
        </tr>
        <tr>
            <td>手机号码</td>
            <td>${user.telphone}</td>
        </tr>
        <tr>
            <td>旧卡号</td>
            <td>
                <input name="oldCardCode" value="${user.deviceCode}" class="easyui-textbox" data-options="readonly:true"/>
            </td>
        </tr>
        <tr>
            <td>新卡号</td>
            <td>
                <input name="newCardCode" class="easyui-textbox" data-options="required:true"/>
            </td>
        </tr>
        <tr>
            <td>更换原因</td>
            <td>
                <select name="reasonType" class="easyui-combobox" data-options="required:true" style="width: 60px">
                    <option value="1">丢失</option>
                    <option value="2">损坏</option>
                    <option value="3">其它</option>
                </select>
            </td>
        </tr>
    </table>
</form>
