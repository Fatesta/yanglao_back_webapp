<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<table id="dg" class="easyui-datagrid"
    data-options="url:'${urlPath}cardConsume/service/page.do',
                  queryParams: {categoryType: '${categoryType}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'serviceName', width:'24%', halign: 'center', align:'left'">服务名称</th>
            <th data-options="field:'categoryName', width:'10%', halign: 'center', align:'left'">服务类别</th>
            <th data-options="field:'serviceCode', width:'20%', halign: 'center', align:'left'">服务编码</th>
            <th data-options="field:'unit', width:'9%', halign: 'center', align:'left'">服务单位</th>
            <th data-options="field:'serviceDesc', width:'25%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'serviceDesc'})">服务介绍</th>
            </tr>
    </thead>
</table>