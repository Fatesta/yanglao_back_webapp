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
        <input type="hidden" name="id" value="${evalInfo.id}" />
        <input type="hidden" name="imgUrl" value="${evalInfo.imgUrl}" />
        <table class="form">
            <tr>
                <td>图片</td>
                <td colspan="3">
                    <a id="imgUploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${evalInfo.id == null ? "上传" : "修改"}</a>
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <img id="img" <c:if test="${evalInfo.id != null}">src="${evalInfo.imgUrl}"</c:if> style="width:140px;height:100px" />
                </td>
            </tr>
            <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" value="${evalInfo.title}" style="width: 310px;"
                        data-options="required:true,validType:'length[1,225]'">
                </td>
            </tr>
            <tr>
                <td>简介</td>
                <td>
                    <textarea rows="4" cols="60" class="easyui-validatebox" name="content"
                              data-options="required: true, validType:'length[0,1000]'" style="width: 300px;">${evalInfo.content}</textarea></td>
            </tr>
        </table>
    </form>
</body>
</html>