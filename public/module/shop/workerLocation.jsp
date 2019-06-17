<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="workerLocationLayout" class="easyui-layout">

	<div data-options="region:'center'" sstyle="width: 84%;">
	   <div id="workerLocationMapContainer" class="map-container"></div>
	</div>
	<div data-options="region:'east',collapsible:true,split:true, collapsed: true" title="搜索" style="width: 250px;">
	    <div name="tbr">
	        <form id="queryForm">
	            <table class="form">
	                <tr>
	                    <td>姓名</td>
	                    <td>
	                       <input class="easyui-textbox filter" name="realName" type="text" style="width: 100px;"></td>

	                    <td><a href="#"
	                        class="easyui-linkbutton" id="query" data-options="iconCls:'icon-search'">查询</a></td>
	                </tr>
	            </table>
	        </form>
        </div>
	    <table id="workerLocationDatagrid" class="easyui-datagrid" toolbar='#workerLocationLayout [name=tbr]'>
	        <thead>
	            <tr>
	                <th data-options="field:'realName',width: '100%',halign:'center'"></th>
	            </tr>
	        </thead>
	    </table>
	</div>
</div>
<script id="workerInfo.html" type="text/html">
    <table class="tip_form">
        <tr>
            <th style="width:60px">姓名：</th>
            <td>{{realName}}</td>
        </tr>
        <tr>
            <th>手机：</th>
            <td>{{phone}}</td>
        </tr>
        <tr>
            <th>工作店铺：</th>
            <td>{{providerName}}</td>
        </tr>
        <tr>
            <th>状态：</th>
            <td style="font-weight:bold">{{if state == 0}}<span style="color:green">空闲中</span>{{/if}}{{if state == 1}}<span style="color:red">忙碌中</span>{{/if}}</td>
        </tr>
        {{if state == 1}}
        <tr>
            <th>订单号：</th>
            <td>{{orderCodes}}</td>
        </tr>
        {{/if}}
    </table>
    </script>
    <script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
    <script src="${libPath}SearchControl_min.js"></script>
    <script src="${libPath}utils/require.js"></script>
    <script src="${libPath}ui/map-utils.js"></script>
<script>
   require([CONFIG.modulePath + 'shop/workerLocation.js?v=1'], function(f) { f() });
</script>
</body>
</html>