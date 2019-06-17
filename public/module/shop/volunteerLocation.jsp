<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="volunteerLocationLayout" class="easyui-layout">

	<div data-options="region:'center'" sstyle="width: 78%;">
	   <div id="volunteerLocationMapContainer" class="map-container"></div>
	</div>
	<div data-options="region:'east',collapsible:true,split:true" title="搜索" style="width: 22%;">
	    <div name="tbr">
	        <form id="queryForm">
	            <table class="form">	         
	                <tr>
	                    <td>姓名</td>
	                    <td>
	                       <input class="easyui-textbox filter" name="realName" type="text" style="width: 70px;"></td>
	                    <td>状态</td>
	                    <td>
	                       <select class="easyui-combobox" name="status" style="width: 60px;">
	                          <option value="">全部</option>
	                       	  <option value="0">空闲</option>
	                       	  <option value="1">离线</option>
	                       </select>
						</td>
	                    <td><a class="easyui-linkbutton" id="query" data-options="iconCls:'icon-search'">查询</a></td>
	                </tr>
	            </table>
	        </form>
        </div>
		<table id="volunteerLocationDatagrid">
			<thead>
				<tr>
					<th data-options="field:'realName',width: '70',halign:'center'">姓名</th>				
					<th data-options="field:'telephone',width: '100',halign:'center'">联系电话</th>	
					<th data-options="field:'status',width: '60',align:'center', formatter: volunteerLocation.formatters.status">状态</th>
				</tr>
			</thead>
		</table>
	</div>
</div>

	<script id="volunteerInfo.html" type="text/html">
        <table class="tip_form">
            <tr>
                <th style="width:60px">姓名：</th>
                <td>{{realName}}</td>
            </tr>
            <tr>
                <th>联系电话：</th>
                <td>{{telephone}}</td>
            </tr>
            <tr>
                <td>家庭地址：</td>
                <td>{{address}}</td>
            </tr>
            <tr>
                <th>所属社区：</th>
                <td>{{orgName}}</td>
            </tr>
            <tr>
                <th>服务描述：</th>
                <td>{{volunteerDesc}}</td>
            </tr>
            <tr>
                <th>服务领域：</th>
                <td>{{profession}}</td>
            </tr>
            <tr>
                <th>服务时长：</th>
                <td>{{serviceDuration}}小时</td>
            </tr>
            <tr>
                <th>接单次数：</th>
                <td>{{orderTimes}}次</td>
            </tr>
            <tr>
                <th>当前状态：</th>
                <td>{{status == 0 ? '空闲' : '离线'}}</td>
            </tr>
        </table>
	</script>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
<script src="${libPath}SearchControl_min.js"></script>
<script src="${libPath}template.js"></script>
<script src="${libPath}ui/map-utils.js"></script>
<script src="${modulePath}shop/volunteerLocation.js?v=1.1"></script>
</body>
</html>