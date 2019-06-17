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
        <input type="hidden" name="id" value="${surveyQuestion.id}" />
        <input type="hidden" name="surveyId" value="${surveyQuestion.surveyId}" />
        <input type="hidden" name="ordernoUpdate" value="false" />
        <table class="form">
            <tr>
                <td>题型</td>
                <td>
                    <input id="type" name="type" class="easyui-combobox"
                      data-options="
                          required: true,
                          editable: false,
                          data: [{v: 0, t: '问答'}, {v: 1, t: '单选'}, {v: 2, t: '多选'}],
                          valueField: 'v',
                          textField: 't',
                          value: '${surveyQuestion.type == null ? 1 : surveyQuestion.type}'"
                      style="width:100px;">
                </td>
            </tr>
            <tr>
                <td>内容</td>
                <td>
                    <textarea rows="7" cols="40" class="easyui-validatebox" name="content" data-options="required: true, validType:'length[0,1000]'">${surveyQuestion.content}</textarea></td>
            </tr>
            <c:if test="${surveyQuestion.id != null}">
            <tr>
                <td>显示顺序</td>
                <td>
                    <input id="orderno" name="orderno" class="easyui-numberbox" value="${surveyQuestion.orderno}" style="width: 100px;"
                        data-options="required:true,precision:0">
                    (数值越小表示越靠前)
                </td>
            </tr>
            </c:if>
        </table>
    </form>
</body>
</html>