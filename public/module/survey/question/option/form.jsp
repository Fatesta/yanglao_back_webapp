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
        <input type="hidden" name="id" value="${questionOption.id}" />
        <input type="hidden" name="questionId" value="${questionOption.questionId}" />
        <table class="form">
            <tr>
                <td>内容</td>
                <td>
                    <textarea rows="7" cols="40" class="easyui-validatebox" name="content" data-options="required: true, validType:'length[0,1000]'">${questionOption.content}</textarea></td>
            </tr>
            <tr>
                <td>分隔选项</td>
                <td>
                    <select name="contentSplit" class="easyui-combobox" style="width: 100px;">
                        <option value="space">按空白</option>
                        <option value="line">按行</option>
                        <option value="">不分割</option>
                    </select>
                </td>
            </tr>
            <c:if test="${questionOption.id != null}">
            <tr>
                <td>显示顺序</td>
                <td>
                    <input class="easyui-numberbox" name="orderno" value="${questionOption.orderno}" style="width: 100px;"
                        data-options="required:true,precision:0">
                    (数值越小表示越靠前)
                </td>
            </tr>
            </c:if>
        </table>
    </form>
</body>
</html>