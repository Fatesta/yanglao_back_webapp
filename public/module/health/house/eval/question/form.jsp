<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <form id="form" method="post">
        <input type="hidden" name="id" value="${question.id}" />
        <input type="hidden" name="evalId" value="${question.evalId}" />
        <input type="hidden" name="ordernoUpdate" value="false" />
        <table class="form">
            <tr>
                <td>题型</td>
                <td>
                    <input id="type" name="type" class="easyui-combobox"
                      data-options="
                          required: true,
                          editable: false,
                          data: [{v: 1, t: '单选'}, {v: 2, t: '多选'}],
                          valueField: 'v',
                          textField: 't',
                          value: '${question.type == null ? 1 : question.type}'"
                      style="width:100px;">
                </td>
            </tr>
            <tr>
                <td>内容</td>
                <td>
                    <textarea rows="7" cols="40" class="easyui-validatebox" name="content" data-options="required: true, validType:'length[0,1000]'">${question.content}</textarea></td>
            </tr>
            <c:if test="${question.id != null}">
            <tr>
                <td>顺序</td>
                <td>
                    <input id="orderno" name="orderno" class="easyui-numberbox" value="${question.orderno}" style="width: 100px;"
                        data-options="required:true,precision:0">
                    (数值越小表示越靠前)
                </td>
            </tr>
            </c:if>
        </table>
    </form>
