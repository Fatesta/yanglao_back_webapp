<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<table id="dgCardAndService" class="easyui-datagrid"
    data-options="url:'${urlPath}shop/order/housekeeping/cardAndService.do',
                  queryParams: {userId: '${userId}', productId: '${productId}'},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'cardNumber', width:'14%', halign:'center', align:'left'">卡号</th>
            <th data-options="field:'cardName', width:'30%', halign:'center', align:'left'">卡名称</th>
            <th data-options="field:'serviceName', width:'32%', halign: 'center', align:'left'">服务名称</th>
            <th data-options="field:'times', width:'10%', halign: 'center', align:'left'">次数</th>
            <th data-options="field:'restTimes', width:'10%', halign: 'center', align:'left'">剩余次数</th>
            </tr>
    </thead>
</table>
