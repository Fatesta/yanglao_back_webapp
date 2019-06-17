<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post"  enctype="multipart/form-data" style="margin: 8px">
        <input type="hidden" name="classesId" value="${classesLearningPlan.classesId}" />
        <input type="hidden" name="planId" value="${classesLearningPlan.planId}" />
        <input type="hidden" name="url" value="${classesLearningPlan.url}" />
        <input type="hidden" name="fileName" value="${classesLearningPlan.fileName}" />
        <input type="hidden" name="weekDay" value="${classesLearningPlan.weekDay}" />
        <input type="hidden" name="weekTime" value="${classesLearningPlan.weekTime}" />
        
        <h3>重复: </h3>
        <table id="weekDayTable" class="form" style="margin-left:30px">
        </table>
        <br>
        <a id="addWeekTime" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'">添加时间点</a>
        <table id="weekTimeTable" class="form" style="margin-left:30px">
        </table>
    </form>
</body>
</html>