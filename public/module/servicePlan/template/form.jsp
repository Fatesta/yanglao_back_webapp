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
        <input type="hidden" name="tid" value="${servicePlanTemplate.tid}" />
        <table class="form">
            <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" style="width: 300px;"
                        value="${servicePlanTemplate.title}"
                        data-options="required:true,validType:'length[1,255]'">
                </td>
            </tr>
            <tr>
                <td>计划开始日期(包含)</td>
                <td><input class="easyui-datebox" id="startDate" name="startDate" value="${servicePlanTemplate.startDate}" data-options="editable: false, required:true, validType:{isBefore:['#endDate', '开始日期必须在结束日期之前']}" ></td>
            </tr>
            <tr>
                <td>计划结束日期(不包含)</td>
                <td><input class="easyui-datebox" id="endDate" name="endDate" value="${servicePlanTemplate.endDate}" data-options="editable: false, required:true, validType:{isAfter:['#startDate', '结束日期必须在开始日期之后']}" ></td>
            </tr>
	        <tr>
	            <td>总时长</td>
	            <td><input class="easyui-numberbox" name="totalDuration" value="${empty servicePlanTemplate.totalDuration ? 60 : servicePlanTemplate.totalDuration}" data-options="precision:0,required:true"  style="width: 50px;">(小时)</td>
	        </tr>
        </table>
    </form>
</body>
</html>