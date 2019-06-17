<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <table class="form">
        <tr>
            <td>总人数: </td>
            <td>${totalNum}</td>
        </tr>
        
        <tr>
            <td>匹配成功人数: </td>
            <td>${matchingNum}</td>
            <c:if test="${matchingNum != 0}">
            <td>
                <a name="downloadFile" data-type="1" class="easyui-linkbutton" data-options="iconCls:'icon-download'">下载文件</a>
            </td>
            </c:if>
        </tr>

        <tr>
            <td>匹配失败人数: </td>
            <td>${mismatchingNum}</td>
            <c:if test="${mismatchingNum != 0}">
            <td>
                <a name="downloadFile" data-type="0" class="easyui-linkbutton" data-options="iconCls:'icon-download'">下载文件</a>
            </td>
            </c:if>
        </tr>
    </table>
</body>
</html>