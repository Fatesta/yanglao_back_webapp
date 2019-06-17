<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post"  enctype="multipart/form-data">
        <input type="hidden" name="id" value="${infoCategory.id}" />
        <table class="form">
            <tr>
                <td>父ID</td>
                <td>
                    <input class="easyui-textbox" name="parentId" value="${infoCategory.parentId}" style="width: 300px;"
                        data-options="required:true">
                </td>
            </tr>
            <tr>
                <td>名称</td>
                <td>
                    <input class="easyui-textbox" name="name" value="${infoCategory.name}" style="width: 300px;"
                        data-options="required:true,validType:'length[1,20]'">
                </td>
            </tr>
            <tr>
                <td>简介</td>
                <td>
                    <textarea rows="5" cols="50" class="easyui-validatebox" name="remark" data-options="validType:'length[0,500]'">${infoCategory.remark}</textarea></td>
            </tr>
            <tr>
                <td><label for="free">是否收费</label></td>
                <td><input id="free" type="checkbox" name="free" <c:if test="${infoCategory.free}">checked="checked"</c:if>></td>
            </tr>
            <tr>
                <td>序号</td>
                <td>
                    <input class="easyui-numberbox" name="sort" value="${infoCategory.sort}" style="width: 100px;"
                        data-options="precision:0">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>