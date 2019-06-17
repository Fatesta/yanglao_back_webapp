<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script>
var CONFIG = {};
CONFIG["baseUrl"] = '${urlPath}';
CONFIG["libPath"] = "${libPath}";
CONFIG['modulePath'] = '${modulePath}';
CONFIG['imagePath'] = '${imagePath}';
</script>
<script src="${libPath}dicts.js?v=1.3"></script>
<script>
//数据字典
DictMan.fetch();
</script>
<script src="${libPath}utils/underscore-min.js"></script>
<script src="${libPath}utils/require.js"></script>
	<script><jsp:include page="/lib/utils/require-config.js" /></script>
<link rel="stylesheet" type="text/css" href="${modulePath}datastat/css/index.css">
</head>
<body>
	<div id="charts-layout" class="easyui-layout charts-bg" style="overflow: hidden;">
		<div id="charts">
		    <div class="title">
		        <div class="main-title"></div>
		    </div>
			<div class="grid">
			    
			     <div class="row" style="height: 45%;">
	                   <div class="col-4">
	                       <div class="chart" id="shopanalysis"></div>
	                   </div>
	                   <div class="col-2">
	                       <div class="chart total">
                            <div style="margin-top: -3em;">
                                <p class="total-title">商户数</p>
                                <p id="bosscount" class="total-number"></p>
                            </div>
                            <div style="margin-top: 3em;">
                                <p class="total-title">店铺数</p>
                                <p id="shopcount"  class="total-number"></p>               
                            </div>                 
	                       </div>
	                   </div>
	                     <div class="col-2">
	                       <div class="chart total">
                            <div style="margin-top: -3em;">
                                <p class="total-title">商品数</p>
                                <p id="productcount"  class="total-number"></p>
                            </div>
                            <div style="margin-top: 3em;">
                                <p class="total-title">订单数</p>
                                <p id="ordercount" class="total-number"></p>
                            </div>	                    
                       </div>
	                   </div>
	                   <div class="col-4">
	                       <div class="chart" id="productanalysis"></div>
	                   </div>
	               </div>
	               
	               <div class="row" style="height: 50%;">
	                   <div class="col-12">
	                       <div class="chart" id="bossmanagernumbers"></div>
	                   </div>
	               </div>
			</div>
		</div>
	</div>
	<script src="${modulePath}datastat/js/common.js"></script>
    <script src="${modulePath}datastat/js/bossindex.js?v=1"></script>
</body>
</html>
