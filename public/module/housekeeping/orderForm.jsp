<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="orderForm" method="post">
    	<input type="hidden" name="id" value="${order.id }">
    	<input type="hidden" id="amapLongitude" name="amapLongitude" value="${order.amapLongitude }">
    	<input type="hidden" id="amapLatitude" name="amapLatitude" value="${order.amapLatitude }">
	    <table class="form">
	    	<tr>
	    		<td><label for="orderNo">订单号</label></td>
	    		<td><input class="easyui-textbox" name="orderNo" value="${order.orderNo}" data-options="required:true,validType:'length[1,50]'" style="width:200px"></td>
	    		<td><label for="type">服务类型</label></td>
	    		<td>
	    			<input class="easyui-combobox" name="type" value='${order.type == null ? "1" : order.type}' 
	    				data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'1',value:'保姆'}]" style="width:200px">
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="employerName">雇主名称</label></td>
	    		<td><input class="easyui-textbox" name="employerName" value="${order.employerName}" data-options="required:true,validType:'length[1,50]'" style="width:200px"></td>
	    		<td><label for="employerTelphone">雇主电话</label></td>
	    		<td><input class="easyui-textbox" name="employerTelphone" value="${order.employerTelphone}" data-options="required:true,validType:'length[1,20]'" style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="startTime">开始时间</label></td>
	    		<td><input class="easyui-datetimebox" name="startTime" data-options="required:true" value="${order.startTime}" style="width:200px"></td>
	    		<td><label for="endTime">结束时间</label></td>
	    		<td><input class="easyui-datetimebox" name="endTime" data-options="required:true" value="${order.endTime}" style="width:200px"></td>
	    	</tr>
	    	<tr>
	    		<td><label for="reward">酬金</label></td>
	    		<td><input class="easyui-numberbox" name="reward" value="${order.reward}" data-options="required:true,min:0,precision:2" style="width:200px"></td>
	    		<td><label for="address">工作地址</label></td>
	    		<td><input class="easyui-textbox" id="address" name="address" value="${order.address}" data-options="required:true,readonly:true,validType:'length[1,100]'" style="width:200px"></td>
	    	</tr>
	    </table>
	    <div id="container" style="width:400px; height: 240px;margin-left: auto;margin-right: auto;"></div>
	</form>
	<script>
		var marker = null;
	
		// 初始化地图
		var map = new AMap.Map('container',{
			zoom: 18
		});
		
		// 加载插件
		AMap.plugin(['AMap.ToolBar','AMap.Scale'], function(){
            map.addControl(new AMap.ToolBar());
            map.addControl(new AMap.Scale());
    	});
		
		// 标记工作地点
		var amapLongitude = $("#amapLongitude").val();
		var amapLatitude = $("#amapLatitude").val();
		if (amapLatitude && amapLongitude) {
			map.setCenter([amapLongitude,amapLatitude]);
			marker = new AMap.Marker({
		        position: [amapLongitude,amapLatitude],
		        map:map
		    });
		}
		
		// 注册点击事件
		map.on("click",function(e){
			if (marker != null) {
				marker.setMap();
			}
			marker = new AMap.Marker({
	            position : e.lnglat,
	            map : map
	        });
			AMap.service('AMap.Geocoder',function(){//回调函数
		        //实例化Geocoder
		        geocoder = new AMap.Geocoder({
		            city: "010"//城市，默认：“全国”
		        });
		        // 使用geocoder 对象完成相关功能
		        var lnglatXY=[e.lnglat.lng, e.lnglat.lat];// 地图上所标点的坐标
		        geocoder.getAddress(lnglatXY, function(status, result) {
		            if (status === 'complete' && result.info === 'OK') {
		               $("#address").textbox("setValue", result.regeocode.formattedAddress);
		            }else{
		               //获取地址失败
		               showAlert("操作失败", "获取地址失败！");
		            }
		        });  
			});
		});
    </script>
</body>
</html>