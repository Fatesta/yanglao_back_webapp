<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<style>
.order-location-query {
    position: absolute;
    right: 10px;
    top: 50px;
    width: 66px;
    height: 24px;
    line-height: 24px;
    background-color: rgba(255,255,255,1);
    border: 1px solid #c4c7cc;
    text-align: center;
}
.order-location-query-form {
    position: absolute;
    right: 10px;
    top: 76px;
    width: 230px !important;
    height: 200px;
    background: rgba(255,255,255,1);
    display:none;
    border: 1px solid #c4c7cc;
}
.order-location-query-form .easyui-linkbutton {
    left: 4px;
    top: 4px;
    position: relative;
}
</style>
<div id="order-location-layout" class="easyui-layout">
    <div id="orderLocationMapContainer" class="map-container"></div>
    <div class="order-location-query">
        <a href="javascript: openQuery()">条件查询</a>
    </div>
    <div class="order-location-query-form">
        <form id="frmQueryOrderLocation">
            <table class="form">
                <tr>
                    <td>工单号</td>
                    <td>
                        <input class="easyui-textbox" name="orderno" type="text" style="width: 150px;">
                    </td>
                </tr>
                <tr>
                    <td>工单状态</td>
                    <td>
                        <select class="easyui-combobox" id="statuses" name="statuses" style="width: 80px;"></select>
                    </td>
                </tr>
                <tr>
                    <td>线上/线下</td>
                    <td colspan="8">
                        <input id="industryId" class="easyui-combobox" name="lineState" style="width: 60px"
                            data-options="
                            required:true,
                            data: [{text: '全部', value: 2}, {text: '线上', value: 1}, {text: '线下', value: 0}],
                            value: 2"
                    </td>
                </tr>
                <tr>
                    <td>开始日期</td>
                    <td>
                        <input class="easyui-datebox filter" name="startCreateTime" type="text" style="width:100px;">
                    </td>
                </tr>
                <tr>
                    <td>结束日期</td>
                    <td>
                        <input class="easyui-datebox filter" name="endCreateTime" type="text" style="width:100px;">
                    </td>
                </tr>
            </table>
        </form>
        <a class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>
    </div>
</div>

<script id="orderInfo.html" type="text/html">
    <table class="tip_form">
        <tr>
            <th>工单号：</th>
            <td>{{orderno}}</td>
        </tr>
        <tr>
            <th>工单地址：</th>
            <td>{{address}}</td>
        </tr>
        <tr>
            <th>服务状态：</th>
            <td style="font-weight:bold;color:{{statusColor}}">{{statusText}}</td>
        </tr>
    </table>
</script>
<script src="${modulePath}shop/workOrder/common.js?v=1"></script>
<script src="${libPath}template.js"></script>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
<script src="${libPath}ui/map-utils.js"></script>
<script src="${libPath}SearchControl_min.js"></script>
<script src="${modulePath}shop/orderLocation.js?v=1.1"></script>
</body>
</html>