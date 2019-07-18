<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
	<style>
	#accountCanvasDiv > div {
		margin: 0 auto !important;
	}
	</style>
</head>
<body>
<div data-options="fit:true" class="easyui-layout">
	<div id="tabs" class="easyui-tabs" data-options="fit:true">
			    <div id="order" title="订单统计" data-mod-id="order">
			    	<%@ include file="orderStat.jsp" %>
				</div>
			    <div id="account" title="交易统计" data-mod-id="account">
					<%@ include file="providersAccountStat.jsp" %>
				</div>

	</div>
	
	<script src="${libPath}ichart.1.2.1.min.js"></script>
	<script src="${libPath}utils/require.js"></script>
	<script>
	$(function() {
		top.app.$refs.navMenu.collapsed = true;
	    var mods = [];
		$('#tabs').tabs('tabs').forEach(function(tab) {
	        mods.push(CONFIG.modulePath + 'shop/stat/' + $(tab).data('mod-id') + '.stat.js?v=2');
	    });
	    if (!mods.length)
	        return;
	    require(mods, function(OrderStatQuerier, AccountStatQuerier) {
	        var queriers = [];
	        $('#tabs').tabs({
	            selected: 0,
	            onSelect:function(title, index) {
	                var querier = queriers[index];
	                if (!querier) {
	                    querier = queriers[index] = new [OrderStatQuerier, AccountStatQuerier][index];
	                }
	                
	                querier.query();
	            }
	        });
	        
	        $('#tabs').tabs('options').onSelect(null, 0);
	    });
	});

	</script>
</div>
</body>
</html>