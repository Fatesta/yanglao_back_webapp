<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<style>
    .item {
        line-height: 20px;
        margin-right: 30px;
    }
    .title {
        font-weight: bold;
    }
    .purse-balance {
        font-weight: bold;
    }
    #balance { color: rgb(0,0,160) }
    #points { color: rgba(250,0,0, 0.6) }
	#oldCardBlance {color: blueviolet; }
    #restCouponCount { color: goldenrod }
    #consumeCardCount { color: rgb(0,160,0) }

	#oldCardBalanceSpan { display: none; }
</style>
</head>
<body class="easyui-layout">
    <div data-options="region:'north', title:'余额'" style="height: 58px;padding: 4px;display:none;">
         <p>
            <span class="item"><span class="title">余额：</span><span id="balance" class="purse-balance"></span></span>
            <span class="item"><sapn class="title">积分：</sapn><span id="points" class="purse-balance"></span></span>
			 <span class="item" id="oldCardBalanceSpan"><sapn class="title">老年卡余额：</sapn><span id="oldCardBlance" class="purse-balance"></span></span>
			 <span class="item"><sapn class="title">可用劵数量：</sapn><span id="restCouponCount" class="purse-balance"></span></span>
            <span class="item"><sapn class="title">消费卡数量：</sapn><span id="consumeCardCount" class="purse-balance"></span></span>
         </p>
    </div>
	<div data-options="region:'center',split:true" style="display:none">
		<div id="tabs" class="easyui-tabs" data-options="fit:true">
		    <div id="consumeCardBuy" title="优惠券" data-options="selected:true,closable:false">
		        <%@ include file="coupon.jsp" %>
			</div>
		    <div id="consumeCard" title="服务卡">
		    	<%@ include file="consumeCardInfo.jsp" %>
			</div>
			
		</div>
	</div>
<script>
var PAGE_CONFIG = {userId: '${userId}'};
</script>
<script src="${modulePath}user/purse/consumeCardInfo.js?v=1.3"></script>
<script src="${modulePath}user/purse/coupon.js?v=1.1"></script>
<script src="${modulePath}user/purse/index.js?v=1.3"></script>
</body>
</html>