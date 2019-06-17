<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="providerLocationLayout" class="easyui-layout">
	<div data-options="region:'center'" sstyle="width: 80%;">
	   <div id="providerLocationMapContainer" class="map-container"></div>
	</div>
	<div data-options="region:'east',collapsible:true, collapsed: true, split:true" title="搜索" style="width:300px;">
        <div class="easyui-tabs" data-options="fit:true">
            <div data-options="title: '服务站'">
                <div name="tbr1">
                    <form name="queryForm">
                        <table class="form">
                            <tr>
                                <td>名称</td>
                                <td>
                                   <input class="easyui-textbox filter" name="realName" type="text" style="width: 140px;"></td>

                                <td><a href="#"
                                    class="easyui-linkbutton" name="query" data-options="iconCls:'icon-search'">查询</a></td>
                            </tr>
                        </table>
                    </form>
                </div>
                <table id="providerLocationDatagrid" class="easyui-datagrid" toolbar='#providerLocationLayout [name=tbr1]'>
                    <thead>
                        <tr>
                            <th data-options="field:'realName',width: '100%',halign:'center'"></th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div data-options="title: '服务资源'">
                <div name="tbr2">
                    <form name="queryForm">
                        <table class="form">
                            <tr>
                                <td>名称</td>
                                <td>
                                    <input class="easyui-textbox filter" name="orgName" type="text" style="width: 140px;"></td>

                                <td><a href="#"
                                       class="easyui-linkbutton" name="query" data-options="iconCls:'icon-search'">查询</a></td>
                            </tr>
                        </table>
                    </form>
                </div>
                <table id="serviceResourceLocationDatagrid" class="easyui-datagrid" toolbar='#providerLocationLayout [name=tbr2]'>
                    <thead>
                    <tr>
                        <th data-options="field:'orgName',width: '100%',halign:'center'"></th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
	</div>
</div>

<script id="storeInfo.html" type="text/html">
    <table class="tip_form">
        <tr>
            <th>商家名称：</th>
            <td>{{name}}</td>
        </tr>
        <tr>
            <th>联系人：</th>
            <td>{{linkman}}</td>
        </tr>
        <tr>
            <th>联系电话：</th>
            <td>{{telephone}}</td>
        </tr>
        <tr>
            <th>地址：</th>
            <td>{{address}}</td>
        </tr>
        <tr>
            <th>营业时间：</th>
            <td>{{serviceTime}}</td>
        </tr>
    </table>
    </script>
    <script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
    <script src="${libPath}SearchControl_min.js"></script>
    <script src="${libPath}utils/require.js"></script>
    <script src="${libPath}ui/map-utils.js"></script>
<script>
   require([CONFIG.modulePath + 'shop/providerLocation.js?v=1'], function(f) { f() });
</script>
</body>
</html>