<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
	<style type="text/css">
		.red {
			color : red;
		}
		.title {
			font-size: 14px;
			font-weight: bold;
		}

		.summary-table-container {
			position: absolute;
			left: 0.5%;
			top: 2px;
			width: 99%;
			height: 40px;
			padding-bottom: 10px;
			background-color: rgba(255,255,255,0.5);
			border-radius: 2px;
			border: 1px solid #ccc;
			user-select: none;
		}
		.summary-table-container:hover {
			background-color: rgba(255,255,255,0.9);
		}
		.summary-table {
			color: #555;
			font-weight: bold;
		}
		.summary-table th {
			padding: 4px 60px 4px 60px;
			font-size: 14px;
			color: rgb(64, 158, 255);
		}
		.summary-table td {
			padding: 0px 60px 0px 60px;
			font-variant: tabular-nums;
			font-size: 16px;
		}
	</style>
</head>
<body>

<div id="statLayout" class="easyui-layout" >

	<div data-options="region:'center'" style="width: 80%; display:none">
		<div id="statMapContainer" class="map-container"></div>
		<div class="tools_panel_bottom" style="height: 132px;">
			<table id="dangerStatTable" class="form">
				<tr>
					<td class="form icon_dangerous"></td>
					<td class="form title" style="font-weight:bold">告警总数：</td>
					<td class="form red title" data-key="0">0</td>
				</tr>
				<tr>
					<td class="form icon_off_line"></td>
					<td class="form title">离线(1-3天)：</td>
					<td class="form red title" data-key="1" name="execAlarmStat" data-type="offline">0</td>
				</tr>
				<tr>
					<td class="form icon_out_security"></td>
					<td class="form title">离开安全区域：</td>
					<td class="form red title" data-key="2" name="execAlarmStat" data-type="outSafeZone">0</td>
				</tr>
				<tr>
					<td class="form icon_battery_low"></td>
					<td class="form title">低电量(低于10%)：</td>
					<td class="form red title" data-key="4" name="execAlarmStat" data-type="lowbattery">0</td>
				</tr>
				<tr>
					<td class="form icon_health"></td>
					<td class="form title">健康检测：</td>
					<td class="form red title" data-key="6" name="execAlarmStat" data-type="userHealthAbnormal">0</td>
				</tr>
			</table>
		</div>
		<div class="summary-table-container" style="display: block">
			<table id="stat-numbers-table" class="form summary-table" style=" margin: 0 auto;">
				<tr>
					<th>用户</th>
					<th style="display: none;">特殊老人</th>
					<th>街道</th>
					<th>社区</th>
					<th>养老院</th>
					<th>志愿者</th>
					<th>服务机构</th>
				</tr>
				<tr>
					<td name="user"></td>
					<td name="specialOldman" style="display: none;"></td>
					<td name="street"></td>
					<td name="org"></td>
					<td name="yanglaoyuan"></td>
					<td name="volunteer"></td>
					<td name="provider"></td>
				</tr>
			</table>
			<div style="
    			position: absolute;
    			bottom: 2px;
    			right: 8px;
				cursor: pointer;
				color: #888;
				font-size: 14px;
				font-weight: bold;
			}" onclick="stat.onCollapseClick()" title="隐藏，稍后请将光标移到地图顶部即可再次显示">︿</div>
		</div>
	</div>
	
	<div data-options="region:'east', collapsed: true" title="&nbsp;" style="width: 350px; display:none">
	    <div id="statTabs" class="easyui-tabs" style="width:100%;height:100%;">
	        <div title="系统告警">
	            <div id="statGridToolbar">
	                <form id="searchStatForm">
	                    <table class="form">
	                        <tr>
	                            <td>昵称</td>
	                            <td><input class="easyui-textbox filter"
	                                name="aliasName" type="text" style="width: 100px;"></td>
	                            <td>设备号</td>
	                            <td><input class="easyui-textbox filter"
	                                name="deviceCode" type="text" style="width: 100px;"></td>
	                        </tr>
	                        <tr>
	                            <td>手机号</td>
	                            <td><input class="easyui-textbox filter"
	                                name="telphone" type="text" style="width: 100px;"></td>
	                            <td>告警类型</td>
	                            <td><select class="easyui-combobox filter"
	                                name="dangerType" style="width: 100px;">
	                                    <option value="" selected="selected">全部</option>
	                                    <option value="1">离线</option>
	                                    <option value="2">离开安全区域</option>
	                                    <option value="4">低电量</option>
	                                    <option value="6">健康检测</option>
	                            </select></td>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                               <a href="#" name="query" class="easyui-linkbutton" id="searchBtn" data-options="iconCls:'icon-search'">查询</a>
	                               <a href="#" name="clear" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
	                            </td>
	                        </tr>
	                    </table>
	                </form>
	            </div>
	            <div id="cameraDlg"></div>
	            <div id="dlg"></div>
	            <table id="statGrid"
	                data-options="url:'${urlPath }stat/listDeviceStat.do',
	                              pageSize:10,
	                              pageList:[10,20],
	                              fit:true,
	                              sortName:'danger_level',
	                              sortOrder:'desc',
	                              onClickRow: stat.gotoPosition,
	                              toolbar:'#statGridToolbar'
	                              ">
	                <thead>
	                    <tr>
	                        <th data-options="field:'aliasName',width:80,halign:'center',formatter:dangerManage.formatters.deviceCode">昵称</th>
	                        <th data-options="field:'remark',width:160,halign:'center',formatter:dangerManage.formatters.remark">告警消息</th>
	                        <th data-options="field:'-',width:60,halign:'center',formatter:dangerManage.formatters.op">操作</th>
	                    </tr>
	                </thead>
	            </table>
	        </div>
	        
	        <div title="告警处理记录">
	            <div id="tbrDgDeviceAlarmOp">
	                <form id="frmQuery">
	                    <table class="form">
	                        <tr>
	                            <td>昵称</td>
	                            <td><input class="easyui-textbox filter" name="aliasName" type="text" style="width: 100px;"></td>
	                            <td>设备号</td>
	                            <td><input class="easyui-textbox filter"
	                                name="deviceCode" type="text" style="width: 100px;"></td>
	                        </tr>
	                        <tr>
	                            <td>手机号</td>
	                            <td><input class="easyui-textbox filter" name="telphone" type="text" style="width: 100px;"></td>
	                            <td>告警类型</td>
	                            <td>
	                                <select class="easyui-combobox filter" name="dangerType" style="width: 100px;">
	                                    <option value="" selected="selected">全部</option>
	                                    <option value="1">离线</option>
	                                    <option value="2">离开安全区域</option>
	                                    <option value="4">低电量</option>
	                                    <option value="6">健康检测</option>
	                                </select></td>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                                <a href="#" class="easyui-linkbutton" id="searchBtn" data-options="iconCls:'icon-search'"
	                                    onclick="deviceAlarmManager.query()">查询</a>
	                        </tr>
	                    </table>
	                </form>
	            </div>
	            <table id="dgDeviceAlarmOp" toolbar='#tbrDgDeviceAlarmOp'
	                data-options="url:'${urlPath }stat/getDeviceAlarmOpPage.do',
	                              fit:true,
	                              singleSelect:true">
	                <thead>
	                    <tr>
	                        <th data-options="field:'aliasName',width:70,halign:'center', formatter:UICommon.datagrid.formatter.wraptip">昵称</th>
	                        <th data-options="field:'remark',width:120,halign:'center', formatter:deviceAlarmManager.formatters.remark">告警信息</th>
	                        <th data-options="field:'alarmTime',width:'130',halign:'center'">告警时间</th>
	                        <th data-options="field:'operation',width:'100',halign:'center', formatter:deviceAlarmManager.formatters.operation">处理措施</th>
	                        <th data-options="field:'operateTime',width:'130',halign:'center'">处理时间</th>
	                        <th data-options="field:'operatorName',width:'80',halign:'center', formatter:UICommon.datagrid.formatter.wraptip">处理人</th>
	                    </tr>
	                </thead>
	            </table>
	        </div>
	        
	        <div title="用户搜索">
	            <div id="orderDlg"></div>
	            <div id="deviceDlg"></div>
	            <div id="deviceGridToolbar">
	                <form id="searchDeviceForm">
	                    <table class="form">
	                        <tr>
					            <td>昵称</td>
					            <td>
					                <input class="easyui-textbox filter" name="aliasName" type="text" style="width:90px;">
					            </td>
								<td>用户类型</td>
								<td>
								    <input class="easyui-combobox filter" name="userType"
								         data-options="
				                            data: DictMan.items('user.type'),
				                            loadFilter: function(arr) {
				                              return [{value: '-3', text: '全部'}].concat(arr);
				                            },
				                            value: '-3'"
								        style="width: 90px;">
								</td>
	                        </tr>
	                        <tr>
	                            <td>手机号</td>
	                            <td><input class="easyui-textbox filter"
	                                name="telphone" type="text" style="width: 90px;"></td>
	                            <td>在线状态</td>
	                            <td><select class="easyui-combobox filter"
	                                name="onLine" style="width: 90px;">
	                                    <option value="" selected="selected">全部</option>
	                                    <option value="1">在线</option>
	                                    <option value="0">离线</option>
	                            </select></td>
	                        </tr>
	                        <tr>
	                            <td colspan="4">
	                               <a href="#" name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	                               <a name="userQuerier" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">高级查询</a>
	                               <a href="#" name="clear" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a></td>
	                        </tr>
	                    </table>
	                </form>
	            </div>
	            <table id="deviceGrid"
	                data-options="url:'${urlPath }stat/listDevice.do',
	                          pageSize:20,
	                          pageList:[10,20],
	                          fit: true,
	                          rownumbers: true,
	                          onClickRow: stat.gotoPosition,
	                          toolbar:'#deviceGridToolbar'
	                          ">
	                <thead>
	                    <tr>
	                        <th data-options="field:'aliasName',width:100,halign:'center', formatter: stat.deviceQuery.formatters.aliasName">昵称</th>
	                        <th data-options="field:'onLine',width:60,halign:'center',align:'center',formatter: stat.deviceQuery.formatters.onLine">在线状态</th>
	                        <th data-options="field:'telphone',width:120,halign:'center'">手机号</th>
                            <th data-options="field:'address',width:200,halign:'center'">地址</th>
	                        <th data-options="field:'-',width:50,halign:'center',formatter: stat.deviceQuery.formatters.op">操作</th> 
	                    </tr>
	                </thead>
	            </table>
	        </div>
	        
	    </div>
	</div>
</div>
<script>
    var orgId = '${curAdmin.orgId}';
</script>
<script id="marker-info-user" type="text/html">
	<table class='tip_form'>
		<tr>
			<th>用户昵称：</th>
			<td>{{info.aliasName}}</td>
		</tr>
		<tr>
			<th>设备编号：</th>
			<td>{{info.deviceCode}}</td>
		</tr>
		<tr>
			<th>联系电话：</th>
			<td>{{info.telphone}}</td>
		</tr>
		<tr>
			<th>紧急联系人：</th>
			<td>{{info.contactName}}</td>
		</tr>
		<tr>
			<th>联系人电话：</th>
			<td>{{info.contactTel}}</td>
		</tr>
		<tr>
			<th>家庭地址：</th>
			<td>{{info.address}}</td>
		</tr>
		{{if evalInfo}}
		<tr><th style="height: 8px"></th></tr>
		<tr>
			<th>评估机构</th>
			<td>{{evalInfo.institutions}}</td>
		</tr>
		<tr>
			<th>申请对象类型</th>
			<td>{{evalInfo.applyTypesText}}</td>
		</tr>
		<tr>
			<th>评估分数</th>
			<td>{{evalInfo.evalScore}}</td>
		</tr>
		<tr>
			<th>拟享受市补贴（元）</th>
			<td>{{evalInfo.allowanceMoney}}</td>
		</tr>
		<tr>
			<th>疾病诊断类别</th>
			<td>{{evalInfo.diseases}}</td>
		</tr>
		<tr>
			<th>养老需求</th>
			<td>{{evalInfo.needsText}}</td>
		</tr>
		{{/if}}
	</table>
</script>
<script id="marker-info-serviceResource"  type="text/html">
	<table class='tip_form'>
		<tr>
			<th>资源名称：</th>
			<td>{{orgName}}</td>
		<tr>
		<tr>
			<th>资源类型：</th>
			<td>{{type}}</td>
		</tr>
		<tr>
			<th>联系人：</th>
			<td>{{contactName}}</td>
		</tr>
		<tr>
			<th>联系电话：</th>
			<td>{{contactTel}}</td>
		</tr>
		<tr>
			<th>地址：</th>
			<td >{{address}}</td>
		</tr>
	</table>
</script>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
<script src="${libPath}SearchControl_min.js"></script>
<script src="${modulePath}user/querier.js?v=2.3"></script>
<script src="${libPath}ui/map-utils.js?v=1.1"></script>
<script src="${modulePath}video/VideoArrayWindow.js?v=1"></script>
<script src="${modulePath}user/basicInfo.js?v=1"></script>
<script src="${libPath}template.js"></script>
<script src="${modulePath}stat/index.js?v=3.7"></script>
</body>
</html>