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
        <input type="hidden" name="id" value="${surveyInfo.id}" />
        <table class="form">
            <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" value="${surveyInfo.title}" style="width: 300px;"
                        data-options="required:true,validType:'length[1,225]'">
                </td>
            </tr>
            <tr>
                <td>内容</td>
                <td>
                    <textarea rows="8" cols="60" class="easyui-validatebox" name="content" data-options="required: true, validType:'length[0,1000]'">${surveyInfo.content}</textarea></td>
            </tr>
            <tr>
                <td><label for="orgId">组织</label></td>
                <td>
                    <input class="easyui-combotree" name="orgIds" style="width:250px;"
                        data-options="required:true,
                                valueField:'id',
                                textField:'text',
                                url:'${urlPath }admin/listOrg.do',
                                value:'${orgIds}',
                                checkbox: true,
                                multiple: true,
                                cascadeCheck: false" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>