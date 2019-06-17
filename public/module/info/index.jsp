<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>

<%@ include file="/module/common.jsp" %>
    <script src="${libPath}utils/require.js"></script>
    <script><%@ include file="/lib/utils/require-config.js" %></script>
</head>
<body>
<div id="tbrInfo">
    <form id="frmQuery">
	<table class="form">
	   <tr>
           <td>标题</td>
           <td>
               <input class="easyui-textbox" name="title" type="text">
           </td>
           <td>分类</td>
           <td>
               <input class="easyui-combobox" id="category" name="category" data-options="value:'${category}'" style="width:100px;"/>
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
<table id="dgInfo" class="easyui-datagrid" toolbar="#tbrInfo"
    data-options="url:'${urlPath }info/page.do',
                  queryParams: {status: '${infoStatus}', category: '${category}'},
                  idField: 'id',
                  singleSelect: '${singleSelect}' == 'true',
                  rownumbers: true,
                  fit:true">
    <thead>
        <tr>
        	<c:if test="${not singleSelect}">
        	<th data-options="field: 'id', checkbox: true"></th>
        	</c:if>
            <th data-options="field:'thumbnailUrl',width:100,halign:'center',formatter: formatters.thumbnailUrl">缩略图</th>
            <th data-options="field:'title',width:200,halign:'center'">标题</th>
            <th data-options="field:'categoryName',width:140,halign:'center'">分类</th>
            <th data-options="field:'childCategoryName',width:140,halign:'center'">次级分类</th>
            <c:if test="${!hide_status_column}">
            <th data-options="field:'status',width:100,align:'center',formatter: formatters.status">状态</th>
            </c:if>
            <th data-options="field:'publisherName',width:150,halign:'center'">发布者</th>
            <th data-options="field:'createTime',width:150,halign:'center'">发布时间</th>
           
           
            

        </tr>
    </thead>
</table>

<script src="${modulePath}info/category/category.js"></script>
<script src="${modulePath}info/index.js?v=20190530"></script>

</body>
</html>