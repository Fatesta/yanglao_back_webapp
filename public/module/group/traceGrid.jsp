<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc" ></script>
</head>
<body class="easyui-layout">
<div data-options="region:'center'" style="width: 95%;">
	<div id="container" style="width:100%; height: 100%;"></div>
</div>
<div data-options="region:'west',collapsible:true,split:true" title="查询" style="width:170px;">
    <div id="tbr">
	    <table class="form">
	        <tr>
	            <td>日期</td>
	            <td><input id="date" name="date" type="text" style="width:110px"></td>
	        </tr>
            <tr>
                <td>时段</td>
                <td>
                    <select id="timeRange" class="easyui-combobox" type="text" style="width:110px">
                        <option value="0">全部</option>
                        <option value="1">凌晨(00~05:59)</option>
                        <option value="2">上午(06~12:59)</option>
                        <option value="3">下午(13~17:59)</option>
                        <option value="4">晚上(18~23:59)</option>
                    </select>
               </td>
            </tr>
	    </table>
    </div>
    <table id="dg" class="easyui-datagrid" toolbar="#tbr">
        <thead>
            <tr>
                <th data-options="field:'timeStr',width: '90%',halign:'center'">时间</th>
            </tr>
        </thead>
    </table>
</div>
<script>
$('#timeRange').combobox({
    onChange: function(value) {
        $('#dg').datagrid('load');
    }
});


//创建地图实例
var map = new BMap.Map("container");
// 设置中心点坐标和地图级别
map.centerAndZoom(new BMap.Point(116.404, 39.915), 18);
// 开启鼠标滚轮缩放
map.enableScrollWheelZoom(true);
// 添加地图控件
map.addControl(new BMap.NavigationControl());// 添加平移缩放控件
map.addControl(new BMap.ScaleControl());// 添加比例尺控件
map.addControl(new BMap.GeolocationControl());// 添加定位控件
map.addControl(new BMap.CityListControl({
   	anchor: BMAP_ANCHOR_TOP_RIGHT,
   	offset: BMap.Size(10, 20)
}));

map.zoomendTimes = 0;
map.addEventListener("zoomend", function(){
    map.zoomendTimes++;
    redrawMarkers($('#dg').datagrid('getData'));
});

$("#date").datebox({onSelect: function(date){
    map.clearOverlays();
	refreshPosition();
}});

//默认选择当前时间
$("#date").datebox("setValue", moment().format("YYYY:MM:dd"));
refreshPosition();

function refreshPosition() {
    var date = $("#date").datebox("getValue");
    $('#dg').datagrid({
        url:'${urlPath}group/listDevicePositionByDeviceCode.do',
        queryParams: {deviceCode:"${deviceCode}",deviceId:"${deviceId}", date: date},
        pagination: false,
        fit:true,
        loadFilter: function loadFilter(trace) {
            if (trace.points.length == 0) {
                return [];
            }
            
            //先按时间取集合（元素互不相同）,同时转换BMap.Point和时间标签
            var timeMap = {};
            trace.start_point.timeStr = moment(trace.start_point.loc_time * 1000).format('HH:mm:ss');
            trace.start_point.point = new BMap.Point(trace.start_point.longitude, trace.start_point.latitude);
            timeMap[trace.start_point.timeStr] = trace.start_point;
            
            trace.points.forEach(function(tpoint){
                tpoint.point = new BMap.Point(tpoint.longitude, tpoint.latitude);
                if(tpoint.create_time) {
                    var timeStr = tpoint.create_time.substring(11);
                    if (!timeMap[timeStr]) {
                        timeMap[timeStr] = tpoint;
                    }
                    tpoint.timeStr = timeStr;
                } else {
                    timeMap[timeStr] = tpoint;
                }
            });
            var endTimeStr = moment(trace.end_point.loc_time * 1000).format('HH:mm:ss');
            trace.end_point.timeStr = endTimeStr;
            trace.end_point.point = new BMap.Point(trace.end_point.longitude, trace.end_point.latitude);
            if (!timeMap[endTimeStr]) {
                timeMap[endTimeStr] = trace.end_point;
            }

            var tpoints = Object.values(timeMap);
            //按时间排序
            tpoints.sort(function(tp1, tp2) {
                return moment(date + ' ' + tp2.timeStr).valueOf() - moment(date + ' ' + tp1.timeStr).valueOf();
            });
            
            // 按区间查询选项过滤
            var range = +$('#timeRange').combobox('getValue');
            if (range) {
	            tpoints = tpoints.filter(function(tpoint) {
	                var h = +tpoint.timeStr.substring(0, 2),
	                    m = +tpoint.timeStr.substring(3, 5);
	                var v;
	                if ((0 <= h && h <= 5) && (0 <= m && m <= 59)) v = 1;
	                else if ((6 <= h && h <= 12) && (0 <= m && m <= 59)) v = 2;
	                else if ((13 <= h && h <= 17) && (0 <= m && m <= 59)) v = 3;
	                else if ((18 <= h && h <= 23) && (0 <= m && m <= 59)) v = 4;
	                
	                return v == range;
	            });
            }
            
            return tpoints;
        },
        onLoadSuccess: function(page) {
            redrawMarkers(page);
        },
        onClickRow: gotoPosition,
    });
}

function redrawMarkers(page) {
    map.clearOverlays();
    
    var tpoints = page.rows;
    if (tpoints.length == 0) {
        return;
    }

    // 画
    if (tpoints.length == 1) {
        //结束位置
        map.addOverlay(makeOverlay(tpoints[0], '${imagePath}end.png'));
        // 按结束位置居中
        if(map.zoomendTimes == 0) {
            map.setCenter(tpoints[0].point);
        }
    } else if (tpoints.length > 1) {
        //开始位置
        map.addOverlay(makeOverlay(tpoints[tpoints.length - 1], '${imagePath}start.png'));
        // 按开始位置居中
        if(map.zoomendTimes == 0) {
            map.setCenter(tpoints[tpoints.length - 1].point);
        }
        //中间位置
        tpoints.slice(1, tpoints.length - 1).reverse().forEach(function(tpoint){
            map.addOverlay(makeOverlay(tpoint));
        });
        //结束位置
        map.addOverlay(makeOverlay(tpoints[0], '${imagePath}end.png'));
        // 画折连线
        var polyline = new BMap.Polyline(tpoints.map(function(tp) { return tp.point; } ));
        map.addOverlay(polyline);
    }
    
    function makeOverlay(tpoint, iconUrl) {
        var marker = new BMap.Marker(tpoint.point);
        marker.setLabel(new BMap.Label(tpoint.timeStr, {offset: new BMap.Size(20,-10)}));
        if (iconUrl) {
            marker.setIcon(new BMap.Icon(iconUrl, new BMap.Size(60, 60)));
        }
        return marker;
    }
}

//定位到地图的指定坐标
function gotoPosition(index, row) {
    var point = new BMap.Point(row.longitude, row.latitude);
    map.panTo(point);
    var overlay = map.getOverlays().filter(function(overlay) {
        return (overlay instanceof BMap.Marker && overlay.getLabel() && overlay.getLabel().content == row.timeStr);
    })[0];
    toBounceMarker(overlay);
}

toBounceMarker = (function(){
 //当前跳动的marker
 var bounceMarker = null;
 
 var bounceTimer = null;
 //让marker跳动
 function toBounceMarker(marker) {
     stopBounce();
     map.getOverlays().forEach(function(overlay) {
         if (overlay instanceof BMap.Marker) {
             if (marker != overlay)
                 overlay.hide();
         }
     });
     
     marker.setAnimation(BMAP_ANIMATION_BOUNCE);
     bounceMarker = marker;
     bounceTimer = setTimeout(stopBounce, 3000);
 }
 
 // 停止当前跳动的marker
 function stopBounce() {
     clearTimeout(bounceTimer);
     if (bounceMarker) {
         bounceMarker.setAnimation(null);
         map.getOverlays().forEach(function(overlay) {
             if (overlay instanceof BMap.Marker) {
                 if (bounceMarker != overlay)
                     overlay.show();
             }
         });

         bounceMarker = null;
     }
 }
 
 return toBounceMarker;
})();
</script>
</body>
</html>