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
        margin: 14px auto;
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
        border: 1px solid #c0babc !important;
    }

    .model-form {
        width: 100%;
        margin: 0;
    }
    .model-form caption {
        margin-bottom: 0px;
        padding-left: 2px;
        text-align: left;
        border-bottom: 0px;
        font-size: 1em;
    }
    .model-form td {
        background: none !important;
    }

    .imggroup {
        height: 90px;
    }
	.imggroup img{
	    width: 90px;
	    height: 90px;
	    margin-left: 6px;
	}
	</style>

</head>
<body>
    <div class="section">
        <h1>服务信息</h1>
        <table class="form model-form">
            <tr>
                <th style="width:90px">服务号：</th>
                <td style="width: 300px">${order.orderno}</td>

                <th style="width:90px">服务状态：</th>
                <td id="orderStatus" style="font-weight: bold;">${order.status}</td>
            </tr>
            <tr>
                <th>服务对象：</th>
                <td>${help.linkName}</td>
                <th>联系电话：</th>
                <td>${help.linkPhone}</td>
            </tr>
            <tr>
                <th>服务时间：</th>
                <td colspan="3"><fmt:formatDate value="${help.planDate}" pattern="yyyy-MM-dd ${help.serviceTime}" /></td>
            </tr>
            <tr>
                <th>服务地址：</th>
                <td colspan="3">${help.address}</td>
            </tr>
            <tr>
                <th>服务类型：</th>
                <td id="profession"  colspan="3">${proccess.serviceName}</td>
            </tr>
            <tr>
                <th>服务时长：</th>
                <td colspan="3">
                <c:if test="${help.serviceDuration == 0}">1次</c:if>
                <c:if test="${help.serviceDuration != 0}">${help.serviceDuration}小时</c:if></td>
            </tr>
            <tr>
                <th>详细描述：</th>
                <td style="height: 60px;word-break: break-all;" colspan="3">${help.description}</td>
            </tr>
            <tr>
                <th>公益积分：</th>
                <td colspan="3">${help.taskIntegral}</td>
            </tr>
            <tr>
                <th>发布者：</th>
                <td>${help.publisherName}</td>
                <th>联系电话：</th>
                <td>${help.publisherPhone}</td>
            </tr>
        </table>
    </div>
	<div class="section">
	    <h1>服务过程</h1>
        <table class="form model-form">
            <tr>
                <th style="width: 90px">志愿者：</th>
                <td style="width: 60px">${proccess.volunteerName}</td>
                
                <th style="width: 90px">联系电话：</th>
                <td style="width: 100px">${proccess.volunteerTelephone}</td>
                
                <th style="width: 90px">身份证号：</th>
                <td>${proccess.volunteerIdcard}</td>
            </tr>
        </table>
		<table class="form model-form">
		    <caption>&nbsp;</caption>
	        <tr>
		        <th style="width: 90px">开始时间：</th>
		        <td style="width: 160px">${proccess.startTime}</td>
	
		        <th style="width: 90px">开始位置：</th>
		        <td>${proccess.startAddress}</td>
		    </tr>
		    <tr>
		        <th>开始照片：</th>
		        <td id="startPicture" class="imggroup" colspan="3"></td>
		    </tr>
		</table>
        <table class="form model-form">
            <caption>&nbsp;</caption>
            <tr>
                <th style="width: 90px">结束时间：</th>
                <td style="width: 160px">${proccess.endTime}</td>
    
                <th style="width: 90px">结束位置：</th>
                <td>${proccess.endAddress}</td>
            </tr>
            <tr>
                <th>结束照片：</th>
                <td id="endPicture" class="imggroup" colspan="3"></td>
            </tr>
        </table>
	</div>
	<div class="section">
	    <h1>服务评价</h1>
	    <table class="form model-form">
	        <tr>
	            <th style="width: 90px">分数评价：</th>
	            <td id="score" colspan="3">${proccess.starLevel}</td>
	        </tr>
	        <tr>
	            <th>文字评价：</th>
	            <td colspan="3" style="height: 40px;word-break: break-all;">${proccess.feedbackMessage}</td>
	        </tr>
	    </table>
    </div>
<script src="${modulePath}shop/workOrder/common.js"></script>
<script>
(function() {
    $('#orderStatus').text(DictMan.itemMap('volunteer.orderStatus')[ $('#orderStatus').text() ]);
    raty('#score', $('#score').text() || 0);
    function raty(elem, val) {
	    var html = '';
        for (var n = 0; n < 5; n++) {
            html += '<img src="${urlPath}images/stars/star-'
                + (n < val ? 'on' : 'off') + '.png">';
        }
	    $(elem).html(html);
    }
    createImages('#startPicture', '${proccess.startPicture}');
    createImages('#endPicture', '${proccess.endPicture}');
    function createImages(container, urls) {
        if (!urls)
            return;
        var html = '';
        urls.split(',').forEach(function(url) {
            html += '<a href="' + url + '" target="_blank"><img src="' + url + '" /></a>';
        });
        $(container).html(html);
    }
})();
</script>
</body>
</html>