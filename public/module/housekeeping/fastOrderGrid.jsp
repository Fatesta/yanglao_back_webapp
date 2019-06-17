<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
</head>
<body>
<div id="container"></div>
<div style="position: absolute;top: 50px;left: 100px;background-color: white;width: auto;height: auto;padding: 10px;">
	<table class="form">
		<tr>
			<td>搜索：</td>
			<td colspan="3">
				<input id="ss" class="easyui-searchbox" style="width: 220px;"
        			data-options="searcher:qq,menu:'#mm'"></input>
				<div id="mm">
				    <div data-options="name:'position'">位置</div>
				    <div data-options="name:'device'">雇员</div>
				    <div data-options="name:'order'">订单</div>
				</div>
		</tr>
		<tr>
			<td>呼贝：</td>
			<td>
				<form id="searchDevice">
				<select class="easyui-combobox filter" name="status" style="width: 80px;" data-options="onChange:function(){refreshData();}">
			        <option value="" selected="selected">全部</option>
			        <option value="0">空闲</option>
			        <option value="1">工作中</option>
			    </select>
			    </form>
			</td>
			<td>订单：</td>
			<td>
				<form id="searchOrder">
				<select class="easyui-combobox filter" name="status" style="width: 80px;" data-options="onChange:function(){refreshData();}">
			        <option value="" selected="selected">全部</option>
			        <option value="1">未分配</option>
			        <option value="2">未执行</option>
			        <option value="3">执行中</option>
			        <option value="4">已完成</option>
			    </select>
			    </form>
			</td>
		</tr>
	</table>
</div>
<div id="housekeepingOrderDlg"></div>
<script>
	// 创建地图实例
	var map = new BMap.Map("container");
	// 设置中心点坐标和地图级别
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 12);
	// 开启鼠标滚轮缩放
	map.enableScrollWheelZoom(true);
	// 设置当前城市
	setLocalCity();
	
	// 创建本地搜索
	var localSearch = new BMap.LocalSearch(map, {      
		renderOptions:{map: map}
	});
	
	function qq(value,name){
		if (value == null || value == "") {
			return;
		}
		
		if (name == "position") {// 搜索位置信息
			localSearch.search(value);
		} else if (name == "device") {// 搜索设备信息
			// 获取在线家政设备，并在地图上渲染图标
			var deviceParams = $.extend(url2Json($("#searchDevice").serialize()), {q:value});
			$.get("${urlPath}housekeeping/order/searchDevice.do", deviceParams, function(data) {
				if (data.length > 0) {
					// 清空地图上的数据
					map.clearOverlays();
					$.each(data, function(i, v) {
						addDeviceIcon(v);
					});
					var v = data[0];
					map.centerAndZoom(new BMap.Point(v.longitude, v.latitude), 18);
					var content = "呼贝：" + v.deviceCode + 
								"<br />雇员名称：" + v.aliasName + 
								"<br />状态：" + (v.status == 0 ? "空闲" : "工作中");
					openInfoWindow(250, 80, v.longitude, v.latitude, "家政人员", content);
				} else {
					showMessage("搜索提示", "没有找到您要搜索的设备");
				}
			});
		} else if (name == "order") {// 搜索订单信息
			// 获取订单，并在地图上渲染图标
			var orderParams = $.extend(url2Json($("#searchOrder").serialize()), {q:value});
			$.get("${urlPath}housekeeping/order/searchOrder.do", orderParams, function(data) {
				if (data.length > 0) {
					// 清空地图上的数据
					map.clearOverlays();
					$.each(data, function(i, v) {
						addOrderIcon(v);
					});
					var v = data[0];
					map.centerAndZoom(new BMap.Point(v.baiduLongitude, v.baiduLatitude), 18);
					var status = "未执行";
					if (v.status == 1) {
						status = "未分配";
					} else if (v.status == 3) {
						status = "执行中";
					} else if (v.status == 4) {
						status = "已完成";
					}
					var content = makeOrderContent(v, status);
					openInfoWindow(250, 150, v.baiduLongitude, v.baiduLatitude, "家政订单", content);
				} else {
					showMessage("搜索提示", "没有找到您要搜索的订单");
				}
			});
		}
		
	}
	
	// 添加地图控件
	map.addControl(new BMap.NavigationControl());// 添加平移缩放控件
	map.addControl(new BMap.ScaleControl());// 添加比例尺控件
	map.addControl(new BMap.GeolocationControl());// 添加定位控件
	map.addControl(new BMap.CityListControl({
    	anchor: BMAP_ANCHOR_TOP_RIGHT,
    	offset: BMap.Size(10, 20)
	}));

	// 创建繁忙的雇员图标
	var busyEmpIcon = createIcon("employer_busy.png");
	// 创建空闲的雇员图标
	var idleEmpIcon = createIcon("employer_idle.png");
	
	// 创建未分配的订单图标
	var unallocateIcon = createIcon("order_unallocate.png");
	// 未执行的订单图标
	var unexecutedIcon = createIcon("order_unexecuted.png");
	// 执行中的订单图标
	var doingIcon = createIcon("order_doing.png");
	// 已完成的订单图标
	var doneIcon = createIcon("order_done.png");
	
	// 当地图所有图块完成加载时，刷新数据
	/* map.addEventListener('tilesloaded',function(e){
		
	}); */
	
	setTimeout('timeRefresh()', 500);
	
	function timeRefresh() {
		refreshData();
		setTimeout('timeRefresh()', 60000);
	}
	
	// 为地图注册点击事件
	map.addEventListener("click", function(e){
		if (e.overlay) {// 如果点击的是遮罩，禁止打开下单界面
			return false;
		}
		var href = "${urlPath }housekeeping/order/showHousekeepingFastOrderForm.do?baiduLongitude=" + e.point.lng + "&baiduLatitude=" + e.point.lat;
		var dlg = $("#housekeepingOrderDlg").dialog({
		    title: "编辑订单",
		    width: 520,
		    height: 380,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#housekeepingOrderForm").form("submit", {
					    url:"${urlPath }housekeeping/order/saveOrder.do",
					    success:function(data){
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog("close");
					    		showMessage('系统提示', data.message);
					    		
					    		refreshData();
					    	} else {
					    		showAlert(data.title,data.message,'error');
					    	}
					    } 
					});
				}
			},{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog("close");	
				}
			}],
		    modal: true
		});
	});
	
	//设置当前城市
	function setLocalCity() {
		function myFun(result){
			var cityName = result.name;
			map.setCenter(cityName);
		}
		
		var myCity = new BMap.LocalCity();
		return myCity.get(myFun);
	}
	
	// 创建自定义图标
	function createIcon(imgName) {
		return new BMap.Icon("${imagePath}" + imgName, // 图标地址
				   new BMap.Size(30, 30),// 图标大小
				   {
						offset : new BMap.Size(15, 30)// 定位的位置与图标左上角的偏移量
				   }
		);
	}
	
	function addDeviceIcon(v) {
		var marker = new BMap.Marker(new BMap.Point(v.longitude,
				v.latitude), {
			icon : (v.status == 0 ? idleEmpIcon : busyEmpIcon)
		});
		marker.setTitle("呼贝：" + v.deviceCode + 
						"\r\n雇员名称：" + v.aliasName + 
						"\r\n状态：" + (v.status == 0 ? "空闲" : "工作中"));
		marker.addEventListener("click", function(e){
			//一般用在鼠标或键盘事件上
		  	if (e && e.stopPropagation) {
				//W3C取消冒泡事件
			  	e.stopPropagation();
			} else {
			  	//IE取消冒泡事件
			  	window.event.cancelBubble = true;
			}
			
		  	var p = e.target;
		  	var lng = p.getPosition().lng;
		  	var lat = p.getPosition().lat;
		  	var width = 250;
		  	var height = 80;
		  	var content = "呼贝：" + v.deviceCode + 
							"<br />雇员名称：" + v.aliasName + 
							"<br />状态：" + (v.status == 0 ? "空闲" : "工作中");
		  	
			openInfoWindow(width, height, lng, lat, "家政订单", content);
			
		});
		map.addOverlay(marker);
	}
	
	function addOrderIcon(v) {
		var icon = unexecutedIcon;
		var status = "未执行";
		if (v.status == 1) {
			icon = unallocateIcon;
			status = "未分配";
		} else if (v.status == 3) {
			icon = doingIcon;
			status = "执行中";
		} else if (v.status == 4) {
			icon = doneIcon;
			status = "已完成";
		}

		var marker = new BMap.Marker(new BMap.Point(v.baiduLongitude,
				v.baiduLatitude), {
			icon : icon
		});
		marker.setTitle(makeOrderTitle(v, status));
		map.addOverlay(marker);
		marker.addEventListener("click", function(e){
			//一般用在鼠标或键盘事件上
		  	if (e && e.stopPropagation) {
				//W3C取消冒泡事件
			  	e.stopPropagation();
			} else {
			  	//IE取消冒泡事件
			  	window.event.cancelBubble = true;
			}
			
		  	var p = e.target;
		  	var lng = p.getPosition().lng;
		  	var lat = p.getPosition().lat;
		  	var width = 250;
		  	var height = 150;
			var content = makeOrderContent(v, status);
			
			openInfoWindow(width, height, lng, lat, "家政订单", content);
		});
	}
	
	function openInfoWindow(width, height, lng, lat, title, content) {
		var opts = {
			width : width,
			height : height,
			title : title,
			enableMessage : true// 设置允许信息窗发送短息
		};
		var point = new BMap.Point(lng, lat);
		var infoWindow = new BMap.InfoWindow(content, opts);// 创建信息窗口对象 
		map.openInfoWindow(infoWindow, point);// 开启信息窗口
	}
	
	// 定时刷新地图图标
	function refreshData() {
		// 清空地图上的数据
		map.clearOverlays();
		
		if (map.getZoom() > 10) {// Zoom太小就不加载设备和订单信息
		
			var params = getBounds();
		
			// 获取在线家政设备，并在地图上渲染图标
			var deviceParams = $.extend(url2Json($("#searchDevice").serialize()), params);
			$.get("${urlPath}housekeeping/order/listDevice.do", deviceParams, function(data) {
				$.each(data.rows, function(i, v) {
					addDeviceIcon(v);
				});
			});
			// 获取订单，并在地图上渲染图标
			var orderParams = $.extend(url2Json($("#searchOrder").serialize()), params);
			$.get("${urlPath}housekeeping/order/listOrder.do", orderParams, function(data) {
				$.each(data.rows, function(i, v) {
					addOrderIcon(v);
				});
			});
		}
	}
	
	function getBounds() {
		// 获取可视区域
		var bs = map.getBounds(); 
		// 可视区域左下角
		var bssw = bs.getSouthWest();
		// 可视区域右上角
		var bsne = bs.getNorthEast();
		return {
			maxLng : bsne.lng,// 最大经度
			maxLat : bsne.lat,// 最大纬度
			minLnt : bssw.lng,// 最小经度
			minLat : bssw.lat// 最小纬度
		};
	}
	
	function makeOrderTitle(v, status) {
		return "雇主：" + v.employerName + 
		"\r\n雇主电话：" + v.employerTelphone + 
		"\r\n雇员设备号：" + (v.worker == null ? "未分配" : v.worker) + 
		"\r\n工作地址：" + v.address + 
		"\r\n订单状态：" + status +
		"\r\n工作内容：" + (v.remark == null ? "这家伙太懒了什么都没有写" : v.remark);
	}
	
	function makeOrderContent(v, status) {
		var content = "雇主：" + v.employerName + 
					"<br />雇主电话：" + v.employerTelphone + 
					"<br />雇员设备号：" + (v.worker == null ? "未分配" : v.worker) + 
					"<br />工作地址：" + v.address + 
					"<br />订单状态：" + status +
					"<br />工作内容：" + (v.remark == null ? "这家伙太懒了什么都没有写" : v.remark);
		return content;
	}

	// 获取数据并在地图上渲染图标
	function getDataAndSetIcon(url, icon, title) {
		$.get(url, null, function(data) {
			$.each(data.rows, function(i, v) {
				var marker = new BMap.Marker(new BMap.Point(v.longitude,
						v.latitude), {
					icon : icon
				});
				marker.setTitle(v[title]);
				map.addOverlay(marker);
			});
		});
	}
	
</script>
</body>
</html>