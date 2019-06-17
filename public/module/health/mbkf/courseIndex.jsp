<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
	<table class="form">
	   <tr>
	    <td>标题</td>
           <td>
               <input class="easyui-textbox" name="title" type="text">
           </td>
           <td>分类</td>
           <td>
               <input class="easyui-combobox" id="category" name="category" style="width:100px;"/>
               <input class="easyui-combobox" id="category2" name="childCategory" style="width:100px;"/>
           </td>
           <td colspan="7">
               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
           </td>
           <c:forEach var="func" items="${ROLE_FUNCS}">
               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
           </c:forEach>
		</tr>
	</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}mbkf/course/page.do',
                  queryParams: {classesId: '${classesId}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'courseContent', width:'40%', halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId:'dg',field:'courseContent',min:60})">课程内容</th>
            <th data-options="field:'curriculaTime', width:'6%', halign:'center'">开课日期</th>
            <th data-options="field:'createTime', width:'10%', halign:'center'">创建时间</th>
        	</tr>
    </thead>
</table>

<script>
var PAGE_CONFIG = {classesId: '${classesId}'};
</script>
<script src="${modulePath}health/mbkf/course.js"></script>

</body>
</html>