<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<body>
<style>
#orderFlowInfo {
    margin-top: 20px;
    margin-left: 16px;
}
table.orderFlowInfo td {
    padding-bottom: 10px;
}
.section {
    font-size: 1.2em;
    font-weight: bold;
    margin-top: 10px;
    margin-bottom: 10px;
}
.imggroup img{
    width: 80px;
    height: 80px;
    margin-left: 6px;
}
</style>

<div id="orderFlowInfo">
	<h1 class="section">开始信息</h1>
	<table class="orderFlowInfo">
	    <tr>
	        <td>执行人：</td>
	        <td name="orderStartOperator"></td>
	    </tr>
	    <tr>
	        <td>开始时间：</td>
	        <td name="orderStartTime"></td>
	    </tr>
	    <tr>
	        <td>开始位置：</td>
	        <td name="orderStartAddress"></td>
	    </tr>
	    <tr>
	        <td>描述：</td>
	        <td name=""></td>
	    </tr>
	    <tr>
	        <td>配图：</td>
	        <td name="orderStartImage" class="imggroup"></td>
	    </tr>
	</table>
	
    <h1 class="section">结束信息</h1>
    <table class="orderFlowInfo">
        <tr>
            <td>执行人：</td>
            <td name="orderEndOperator"></td>
        </tr>
        <tr>
            <td>结束时间：</td>
            <td name="orderEndTime"></td>
        </tr>
        <tr>
            <td>结束位置：</td>
            <td name="orderEndAddress"></td>
        </tr>
        <tr>
            <td>描述：</td>
            <td name=""></td>
        </tr>
        <tr>
            <td>配图：</td>
            <td name="orderEndImage" class="imggroup"></td>
        </tr>
    </table>
    
    <h1 class="section">评价</h1>
    <table class="orderFlowInfo">
        <tr>
            <td>综合评价：</td>
            <td name="starLevel"></td>
        </tr>
        <tr>
            <td>文字评价：</td>
            <td name="appraiseMessage"></td>
        </tr>
        <tr>
            <td>图片：</td>
            <td name="appraiseImage" class="imggroup"></td>
        </tr>
    </table>
</div>

<script>
(function() {
    
    function raty(elem, val) {
	    var html = '';
        for (var n = 0; n < 5; n++) {
            html += '<img src="${urlPath}images/stars/star-'
                + (n < val ? 'on' : 'off') + '.png">';
        }
	    $(elem).html(html);
    }
    
	var orderCode = '${orderCode}';
	$.get('${urlPath}shop/order/orderFlowInfo.do?orderCode=' + orderCode, function(orderFlowInfoMap) {
	    for (var name in orderFlowInfoMap) {
	        var val = orderFlowInfoMap[name];
	        var elem = $('#orderFlowInfo [name=' + name + ']');
	        if (name.toLowerCase().indexOf('image') != -1) {
	            if (val) {
		            var urls = val.split(',');
		            urls.forEach(function(url) {
		                elem.append('<a href="' + url + '" target="_blank"><img src="' + url + '"></a>');
		            });
	            } else {
	                elem.text('无');
	            }
	        } else if (name == 'starLevel') {
	            if (val) {
		            raty(elem, val);
	            } else {
	                elem.text('无');
	            }
	        } else {
	            elem.text(val);
	        }
	    }
	});
})();
</script>
</body>
</html>