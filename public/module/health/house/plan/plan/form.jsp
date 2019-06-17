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
        <input type="hidden" name="id" value="${plan.id}" />
        <input type="hidden" name="state" value="${plan.state}" />
        <input type="hidden" name="coverUrl" value="${plan.coverUrl}" />
        <table class="form">
            <tr>
                <td>图片</td>
                <td colspan="3">
                    <a id="imgUploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${plan.id == null ? "上传" : "修改"}</a>
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <img id="img" <c:if test="${plan.id != null}">src="${plan.coverUrl}"</c:if> style="width:140px;height:100px" />
                </td>
            </tr>
            <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" value="${plan.title}" style="width: 310px;"
                        data-options="required:true,validType:'length[1,225]'">
                </td>
            </tr>
            <tr>
                <td>周期天数</td>
                <td>
                    <input class="easyui-numberbox" name="cycleDayNum" value="${plan.cycleDayNum}" style="width: 50px;"
                           data-options="required:true,precision:0">
                </td>
            </tr>
            <tr>
                <td>简介</td>
                <td>
                    <textarea rows="4" cols="60" class="easyui-validatebox" name="intro"
                              data-options="required: true, validType:'length[0,1000]'" style="width: 300px;">${plan.intro}</textarea></td>
            </tr>
        </table>
    </form>
</body>
</html>