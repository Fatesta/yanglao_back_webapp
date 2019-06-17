<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<link href="${modulePath}community/berth/checkin/index.css?v=4.1" rel="stylesheet" type="text/css" />

</head>
<body class="easyui-layout">
    <div data-options="region:'north',border:false" style="height:60px;">
        <div style="height:28px;">
            <span style="margin-left: 8px;line-height: 28px;font-size: 1.1em;">
                <span>上面选择楼栋，左边选择楼栋的楼层；</span>
                <span class="state-empty">绿色</span>表示空闲床位；
                <span class="state-used">红色</span>表示占用床位；</span>
                <span>点击头像查看入住人基本信息；</span>
                <span>在床位上右键打开床位的更多操作选项；</span>
			    <a id="selectUser" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询入住人</a>
        </div>
        <div id="tabsBuilding" class="easyui-tabs" data-options="fit:true, tabPosition: 'top'" title="楼栋"></div>
    </div>
    
    <div data-options="region:'center',border:false">
        <div class="easyui-layout">
            <div data-options="region:'west',border:false" style="width:56px;">
	           <div id="tabsFloor" class="easyui-tabs" data-options="fit:true, tabPosition:'left'" title="楼层"></div>
	        </div>
	        <div id="panelRooms" data-options="region:'center',border:false"></div>
        </div>
    <div id="berthMenu" class="easyui-menu" style="width:140px;display:none">
        <div name="updateDeposit" class="big-menu-item" data-options="iconCls: 'icon-money'">交押金</div>
        <div name="userInfo" class="big-menu-item" data-options="iconCls: 'icon-user'">当前入住人信息</div>
        <div name="checkinRecord" class="big-menu-item" data-options="iconCls: 'icon-berth'">历史入住记录</div>
        <div name="checkinPayRecord" class="big-menu-item" data-options="iconCls: 'icon-money'">历史账单</div>
        <div name="setServicePlan" class="big-menu-item" data-options="iconCls: 'icon-money'">服务计划</div>
        <div name="setSmartDevice" class="big-menu-item" data-options="iconCls: 'icon-set'">绑定智能设备</div>
    </div>
    </div>
<script id="emptyBerthTpl" type="text/html">
	<div class="box-l">
	    <div></div>
	</div>
	<div class="box-r">
	    <ul class="roomrz">
	        <li>&nbsp;<span> </span></li>
	        <li></li>
	        <li></li>
	        <li name="ruzhu" class="button">入住</li>
	    </ul>
	</div>
</script>
<script id="usedBerthTpl" type="text/html">
    <div class="box-l">
        <div class="berth-user-photo" data-user-id="{{berth.berthCheckin.userId}}" style="filter: grayscale(0.4);">
            {{if berth.berthCheckin.userInfo != null}}
            <img src="${modulePath}community/berth/checkin/img/photo_icon_{{berth.berthCheckin.userInfo.sex == 0 ? 'man' : 'woman'}}.png">
            {{/if}}
            {{if berth.berthCheckin.userInfo == null}}
            <img src="${modulePath}community/berth/checkin/img/user_default_photo.png">
            {{/if}}
        </div>
    </div>
    <div class="box-r">
        <ul>
            {{if berth.berthCheckin.userInfo != null}}
            <li>{{berth.berthCheckin.userInfo.realName || berth.berthCheckin.userInfo.aliasName}}</li>
            <li>{{berth.berthCheckin.userInfo.sex == 0 ? '男' : '女'}}&nbsp;&nbsp;{{berth.berthCheckin.userInfo.age}}岁</li>
            {{/if}}
            {{if berth.berthCheckin.userInfo == null}}
            <li style="color:red">(未查询到用户)</li>
            <li></li>
            {{/if}}
            <li title="{{berth.berthTypeName}}">{{berth.berthTypeName.length > 9 ? berth.berthTypeName.substring(0, 11) + ".." : berth.berthTypeName}}</li>
            <li name="tuizhu" class="button">退住</li>
        </ul>                        
    </div>
</script>
<script id="roomTpl" type="text/html">
	<div class="room" data-room-no="{{roomNo}}" title="{{roomNo}}号房间">
	    <h2 class="room-no">{{roomNo}}</h2>
	</div>
</script>
<script id="emptyFloorInfoTpl" type="text/html">
    <div class="empty-floor">未查询到{{building.buildingNo}}楼栋{{floorNo}}层的房间数据。</div>
</script>
<script src="${libPath}template.js"></script>
<script src="${modulePath}user/select.js?v=1"></script>
<script src="${modulePath}community/berth/checkin/js/roomberth.js?v=1.2"></script>
<script src="${modulePath}community/berth/checkin/js/main.js?v=1.2"></script>
    <script src="${modulePath}user/basicInfo.js?v=1"></script>
</body>
</html>