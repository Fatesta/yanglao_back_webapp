<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tabs" class="easyui-tabs" data-options="fit:true">
    <div id="lunbo" title="轮播图管理" data-options="selected:true,closable:false">
        <%@ include file="../element/elementDatagrid.jsp" %>
	</div>
	
    <div id="guanggaowei" title="广告位管理">
        <%@ include file="../element/elementDatagrid.jsp" %>
	</div>
</div>

<script src="${modulePath}shop/pro/providerToProductSelect.js"></script>
<script src="${modulePath}shopcms/category/category.js"></script>
<script src="${modulePath}shopcms/element/element.js"></script>
<script>
var lunboElementManage = new ElementManage({
    parent: '#lunbo',
    pageLevel: 2,
    blockType: ElementManage.blockType.lunbo
});
lunboElementManage.query();

var guanggaoweiElementManage = new ElementManage({
    parent: '#guanggaowei',
    pageLevel: 2,
    blockType: ElementManage.blockType.guanggaowei
});
guanggaoweiElementManage.query();
</script>
</body>
</html>