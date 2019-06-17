﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
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
               <td><a id="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a></td>
               <td><a id="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a></td>
           </tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}cardConsume/cardService/page.do',
                  queryParams: {cardId: '${cardId}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'serviceName', width:'20%', halign: 'center', align:'left'">服务名称</th>
            <th data-options="field:'serviceCode', width:'12%', halign: 'center', align:'left'">服务编码</th>
            <th data-options="field:'times', width:'5%', halign: 'center', align:'left', formatter: formatters.times">次数</th>
            <th data-options="field:'unit', width:'5%', halign: 'center', align:'left'">单位</th>
        	</tr>
    </thead>
</table>

<script>
var PAGE_CONFIG = {};
PAGE_CONFIG['cardId'] = '${cardId}';
</script>
<script src="${modulePath}cardConsume/cardService/index.js"></script>

</body>
</html>