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
        <input type="hidden" name="tid" value="${servicePlanTemplateDetail.tid}" />
        <input type="hidden" name="timeSegSv">
        <table class="form">
            <tr>
                <td>模板</td>
                <td><input id="templateTitle" class="easyui-textbox"
                    data-options="required:true,editable:false" style="width: 250px" ></td>
            </tr>
            <tr>
                <td>日期</td>
                <td>
                    <input id="planDate" class="easyui-datebox" name="planDate" value="${servicePlanTemplateDetail.planDate}"
                        data-options="required:true,editable:false" style="width: 100px">
                    <span id="planDateTip" style="display:inline;color:blue;font-style:italic"></span>
                </td>
            </tr>
            <tr>
                <td>时间段</td>
                <td><a id="addTimeSeg" class="easyui-linkbutton" data-options="iconCls:'icon-add'"></a></td>
            </tr>
        </table>
        <table id="dgTimeSeg" class="easyui-datagrid" style="width: 96%"
            data-options="pagination: false,
                          fit:false">
        </table>
    </form>
</body>
</html>