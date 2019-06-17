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
        <input type="hidden" name=serviceCode value="${serviceCode}" />
        <table class="form">
            <tr>
                <td>课程</td>
                <td>
                    <input id="infoCategoryId" name="infoCategoryId" class="easyui-combobox"
                        data-options="
		                   required:true,
		                   url: '${urlPath}info/category/list.do',
		                   valueField: 'id',
		                   textField: 'name',
		                   editable: false"
		                style="width:100px;"/>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>