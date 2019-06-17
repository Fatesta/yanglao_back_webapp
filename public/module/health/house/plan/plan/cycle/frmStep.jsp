<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="frmStep" method="post">
        <input type="hidden" name="planId" value="${planId}"/>
        <input type="hidden" name="day" value="${day}"/>
        <input type="hidden" name="articleId" value=""/>
        <table class="form">
            <tr>
                <td>第几天</td>
                <td>
                    <input class="easyui-numberbox" value="${day}" data-options="disabled:true" style="width:40px"/>
                </td>
            </tr>
            <tr>
                <td>第几步</td>
                <td>
                    <input name="step" class="easyui-numberbox" value="${step}" data-option="min:1" style="width:40px"/>
                </td>
            </tr>
            <tr>
                <td>设置文章</td>
                <td>
                    <input id="selectedArticleTitle" class="easyui-textbox" data-options="readonly:true" style="width:200px"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <a id="newArticle" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">前去新增</a>
                    <a id="refArticle" class="easyui-linkbutton" data-options="iconCls:'icon-choose'">关联已有</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>