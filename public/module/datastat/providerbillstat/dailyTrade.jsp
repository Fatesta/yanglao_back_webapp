<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
<%@ include file="/module/common.jsp"%>
</head>
<body>

<table id="dgpbs" class="easyui-datagrid" 
        data-options="url:'${urlPath }providerbillstat/dailyTradeAmountPage.do',
                  queryParams: {providerId: '${providerId}', startCreateTime: '${startCreateTime}', endCreateTime: '${endCreateTime}'},
                  pageSize: 30,
                  loadFilter: function(page) {
                    page.rows.forEach(function(row){
                        _.forEach(row.tradeTypeAmountMap, function(v, k){
                            row['total' + k] = v;
                        });
                    });
                    return page;
                  }"
                  >
    <thead>
        <tr>
        
            <th data-options="field:'createDate', width:90, align:'center'">日期</th>
            <c:if test="${adminRole.id == 1}">
            <th data-options="field:'total1',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">购买余额</th>
            </c:if>
            <th data-options="field:'total3',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">用户总消费</th>
            <th data-options="field:'total3_online',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">用户线上消费</th>
            <th data-options="field:'total3_cash',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">用户现金消费</th>
            <th data-options="field:'total4',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">给用户充值</th>
            <th data-options="field:'totalpp',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">赠送金额</th>
            <th data-options="field:'total5',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">用户退款</th>
            <th data-options="field:'total11',width:'100',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">返还余额</th>
            <th data-options="field:'totalincome',width:'180',halign:'center',precision:'2',formatter:UICommon.datagrid.formatter.money">销售额=用户总消费-返还余额</th>
        </tr>
    </thead>
</table>
</body></html>

