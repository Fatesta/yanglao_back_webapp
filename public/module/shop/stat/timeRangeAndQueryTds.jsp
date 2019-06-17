<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
	    		
<td>按</td>
<td>
	<select class="easyui-combobox" id="timeUnit" name="timeUnit" style="width:42px;">   
	    <option value="day">日</option>   
	    <option value="month">月</option>   
	    <option value="year">年</option>
	</select>
</td>
<td>时间范围</td>
<td>
	<input id="startTime" name="startTime" type="text">
</td>
<td>到</td>
<td>
	<input id="endTime" name="endTime" type="text">
</td>
<td>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>
</td>