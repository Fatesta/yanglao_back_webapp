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
        <input name="userId" type="hidden" />
        <input name="productId" type="hidden" />
        <table class="form">
            <tr>
                <td>服务用户</td>
                <td>
                    <input id="userAliasName" class="easyui-textbox"
                           data-options="required:true,editable:false" style="width: 100px" >
                    <a id="selectUser" class="easyui-linkbutton" data-options="iconCls:'icon-choose'">选择</a>
                </td>
            </tr>
            <tr>
                <td>计划日期</td>
                <td><input name="planDate" class="easyui-datebox" data-options="required:true" style="width: 100px;"></td>
            </tr>
            <tr>
                <td>计划时间</td>
                <td><input name="planTime" class="easyui-timespinner" style="width: 70px;"></td>
            </tr>
            <tr>
                <td>服务产品</td>
                <td>
                    <input id="productName" class="easyui-textbox" data-options="required:true,editable:false" style="width: 200px;" />
                    <a id="selectProduct" class="easyui-linkbutton" data-options="iconCls:'icon-choose'">选择</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>