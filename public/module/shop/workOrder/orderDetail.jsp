<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
	<style>
	body {
	   font-size: 0.9em;
	}
    .section {
        position: relative;
        width: 70%;
        margin: 18px auto;
    }
    .section h1 {
        margin-bottom: 4px;
		padding-bottom: 6px;
        font-size: 1.2em;
        font-weight: bold;
        color: rgb(34, 139, 34);
		border-bottom: 1px solid #ccc;
    }
    .section h2 {
        font-size: 0.9em;
        font-weight: bold;
    }
    .section > .datagrid {
        border: 1px solid #ccc !important;
    }

    .model-form {
        width: 100%;
        margin: 0;
    }
    .model-form caption {
        margin-bottom: 0px;
        padding-left: 38px;
        text-align: left;
        font-size: 1em;
    }
    .model-form td {
        background: none !important;
    }

    .imggroup {
        height: 90px;
    }
	.imggroup img{
	    width: 100px;
	    height: 100px;
	    margin-left: 6px;
	}
	.imggroup img:hover {
		transform: rotate(-90deg);
		transition: transform 0.5s ease-in-out;
	}
	</style>

</head>
<body>
    <div class="section">
        <h1>工单详情</h1>
        <table id="orderInfo" class="form model-form">
            <tr>
                <th style="width:90px">工单号：</th>
                <td name="orderno"></td>

                <th style="width:90px;">工单状态：</th>
                <td name="status" style="font-weight: bold;"></td>
            </tr>
            <tr>
                <th>联系人：</th>
                <td name="linkman"></td>
				<th>联系电话：</th>
				<td name="linkphone"></td>
            </tr>
            <tr>
				<th>下单人：</th>
				<td name="creatorName"></td>
                <th>下单时间：</th>
                <td name="createTime"></td>
            </tr>
			<tr>
				<th>工单地址：</th>
				<td name="address" colspan="3"></td>
			</tr>
            <tr>
                <th>商家店铺：</th>
                <td name="providerName" colspan="3"></td>
            </tr>
			<tr>
				<th>备注：</th>
				<td name="remark" colspan="3"></td>
			</tr>

        </table>
    </div>
    <div class="section">
        <table id="dgOrderDetail" class="easyui-datagrid"
            data-options="
               url: '${urlPath}shop/order/orderDetailPage.do?orderno=${orderCode}',
               fit: false,
               rownumbers: false,
               pagination: false
            ">
            <thead>
                <tr>
                    <th data-options="field:'imageFile',width:'10%',halign:'center', formatter: UICommon.datagrid.formatter.generators.image({width: 60, height: 50})">商品图片</th>
                    <th data-options="field:'productName',width:'50%',halign:'center'">商品名称</th>
                    <th data-options="field:'price',width:'10%',align:'center', formatter: UICommon.datagrid.formatter.money">单价</th>
                    <th data-options="field:'quantity',width:'10%',align:'center'">数量</th>
                    <th data-options="field:'amount',width:'10%',align:'center', formatter: UICommon.datagrid.formatter.money">总金额</th>
                </tr>
            </thead>
        </table>
    </div>
	<div id="orderFlowInfo" class="section">
	    <h1>服务过程</h1>
		<table class="form model-form">
		    <caption>签入</caption>
		    <tr>
		        <th style="width: 90px">操作人：</th>
		        <td name="orderStartOperator" colspan="3"></td>
	        </tr>
	        <tr>
		        <th>签入时间：</th>
		        <td name="orderStartTime" style="width: 160px"></td>
	
		        <th style="width: 90px">签入位置：</th>
		        <td name="orderStartAddress"></td>
		    </tr>
		    <tr>
		        <th>描述：</th>
		        <td name="orderStartRemark" colspan="3"></td>
		    </tr>
		    <tr>
		        <th>签入照片：</th>
		        <td name="orderStartImage" class="imggroup" colspan="3"></td>
		    </tr>
		</table>
		
	    <table class="form model-form">
	        <caption>签出</caption>
	        <tr>
	            <th style="width: 90px">操作人：</th>
	            <td name="orderEndOperator" colspan="3"></td>
	        </tr>
	        <tr>
	            <th>签出时间：</th>
	            <td name="orderEndTime" style="width: 160px"></td>
	
	            <th style="width: 90px">签出位置：</th>
	            <td name="orderEndAddress"></td>
	        </tr>
	        <tr>
	            <th>描述：</th>
	            <td name="orderEndRemark" colspan="3"></td>
	        </tr>
	        <tr>
	            <th>签出照片：</th>
	            <td name="orderEndImage" class="imggroup" colspan="3"></td>
	        </tr>
            <tr>
                <th>录音：</th>
                <td colspan="3"><audio name="voiceFile" controls style="vertical-align: middle;"/></td>
            </tr>
	    </table>
	</div>
	<div class="section">
	    <h1>工单评价</h1>
	    <table id="orderComment" class="form model-form">
	        <tr>
	            <th style="width: 90px">分数评价：</th>
	            <td name="score" colspan="3"></td>
	        </tr>
	        <tr>
	            <th>文字评价：</th>
	            <td name="text" colspan="3" style="height: 40px;word-break: break-all;"></td>
	        </tr>
	    </table>
    </div>
<script src="${modulePath}shop/workOrder/common.js"></script>
<script>
var formatters = {
    orderDesc: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgOrderDetail", field: "orderDesc"
    })
};
(function() {
    var orderCode = '${orderCode}';
    
    $.get(CONFIG.baseUrl + 'shop/order/detail.do?orderCode=' + orderCode, function(orderInfo) {
        for (var name in orderInfo) {
            $('#orderInfo [name=' + name + ']').text(orderInfo[name] || '');
        }
        $('#orderInfo [name=status]').html(workOrder.statusHtmlByValue(orderInfo.status));
        $.get(CONFIG.baseUrl + 'user/getBasicInfo.do?userId=' + orderInfo.creator, function(user) {
            $('#orderInfo [name=sex]').text(user.sex == 1 ? '女' : '男');
            $('#orderInfo [name=age]').text(user.age);
        });
    });
    
    function raty(elem, val) {
	    var html = '';
        for (var n = 0; n < 5; n++) {
            html += '<img src="${urlPath}images/stars/star-'
                + (n < val ? 'on' : 'off') + '.png" />';
        }
	    $(elem).html(html);
    }
    
	$.get(CONFIG.baseUrl + 'shop/order/orderFlowInfo.do?orderCode=' + orderCode, function(orderFlowInfoMap) {
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
	        } else if (name == 'voiceFile') {
	            if (val)
	                elem.attr('src', val);
	        } else {
	            elem.text(val);
	        }
	    }
	});
	
	$.get(CONFIG.baseUrl + 'shop/order/comment/get.do?orderCode=' + orderCode, function(comment) {
	    raty('#orderComment [name=score]', comment.score);
	    $('#orderComment [name=text]').text(comment.text);
	});
})();

</script>
</body>
</html>