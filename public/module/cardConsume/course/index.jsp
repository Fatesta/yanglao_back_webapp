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
               <td><a id="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a></td>
               <td><a id="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a></td>
           </tr>
        </table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}cardConsume/course/page.do',
                  queryParams: {serviceCode: '${serviceCode}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'name', width:'25%', halign: 'center', align:'left'">名称</th>
            <th data-options="field:'remark', width:'25%', halign: 'center', align:'left'">简介</th>
            </tr>
    </thead>
</table>

<script>
var PAGE_CONFIG = {};
PAGE_CONFIG['serviceCode'] = '${serviceCode}';
</script>
<script src="${modulePath}cardConsume/course/index.js"></script>

</body>
</html>