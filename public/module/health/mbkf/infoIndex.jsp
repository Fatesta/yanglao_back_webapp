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
           <td>课件名</td>
           <td>
               <input class="easyui-textbox" name="title" type="text" style="width:120px">
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
    data-options="url:'${urlPath }/mbkf/manageInfo/page.do?classesId=${classesId}',
                  multiSort:true,
                  sortOrder:'desc',
                  rownumbers: true,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'title',width:'200',align:'center'">课件名</th>
            <th data-options="field:'categoryName',width:'10%',align:'center'">课件分类</th>
            <th data-options="field:'childCategoryName',width:'10%',align:'center'">课件次级分类</th>
            <th data-options="field:'thumbnailUrl',width:'8%',halign:'center',formatter: formatters.thumbnailUrl">缩略图</th>
            <th data-options="field:'createTime',width:'10%',align:'center'">发布时间</th>
            <th data-options="field:'recommendStatus',width:'10%',align:'center',formatter: formatters.status">是否推荐</th>
        </tr>
    </thead>
</table>
<script>
var PAGE_CONFIG = {classesId: '${classesId}'};

</script>
<script src="${modulePath}info/category/category.js"></script>
<script src="${modulePath}health/mbkf/info.js?v=1"></script>

</body>
</html>