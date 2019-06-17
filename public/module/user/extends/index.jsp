<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<style>
#healthData {
	margin: 20px;
}
#healthData table {
	border: 1px solid gray;
}
#healthData table th,td {
	text-align: center;
	font-size: 12px;
}
#healthData table th {
    border-top: 2px solid gray;
    border-bottom: 1px solid gray;
}
</style>
</head>
<body>
<div id="tabs" class="easyui-tabs" data-options="fit:true">
	<div title="健康数据" data-options="selected:true,closable:false">
		<div id="healthData">
			<div>暂无健康数据。</div>
		</div>
	</div>
	
</div>
<script id="healthDataTpl" type="text/html">
<table class="form">
  <tr>
    <th width="10%">项目名称</th>
    <th width="30%">检查结果</th>
    <th width="30%">单位</th>
    <th width="30%">创建日期</th>
  </tr>
{{each list as item index}}
<tr>
	<td>{{item.dataName}}</td>
	<td>{{item.dataValue}}</td>
	<td>{{item.unit}}</td>
	<td>{{item.createTime}}</td>
</tr>
{{/each}}
</table>
</script>
<script src="${libPath}template.js"></script>

<script>
var PAGE_CONFIG = {
    userId: '${user.userId}'
};
</script>

<script>

var inited = [];
var querys = [];
querys[0] = function() {
    $.get('${urlPath}health/items.do?userId=' + PAGE_CONFIG['userId'], function(list){
        if(list.length == 0) {
            return;
        }
        list.forEach(function(item){
            item.createTime = item.createTime.substring(0, 19);
        });
        $('#healthData').html(template("healthDataTpl", {list: list}));
        	
    });
};

$('#tabs').tabs({
    onSelect:function(title, index) {
        if(!inited[index]) {
            inited[index] = true;
            querys[index]();
        }
    }
});
</script>
</body>
</html>