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
<link rel="stylesheet" type="text/css" href="${modulePath}datastat/css/index.css?v=1.3">
<link rel="stylesheet" type="text/css" href="${modulePath}datastat/css/servicestat.css">
</head>
<body>
	
	<div id="charts-layout" class="easyui-layout charts-bg" style="overflow: hidden;">
		<div id="charts">
		    <div class="title">
		        <div class="main-title"> 
		        </div>
		    </div>
			<div class="grid">
			    <div class="row" style="height: 45%;">
			        <div class="col-4">
			            <div class="chart" id="pic1"></div>
			        </div>
	                <div class="col-4">
	                    <div class="totals">
	                        <div class="top-border"></div>
	                        <div class="numbers">
		                        <div>
			                        <div>服务量</div>
			                        <div><span id="serviceTotal">0</span><span>次</span></div>
		                        </div>
	                            <div>
	                                <div>客户量</div>
	                                <div><span id="customerTotal">0</span><span>人</span></div>
	                            </div>
                            </div>
                            <div class="bottom-border"></div>
	                    </div>
	                </div>
			        <div class="col-4">
			            <div class="chart" id="pic3"></div>
			        </div>
			    </div>
			    <div class="row" style="height: 55%;">
			        <div class="col-4">
                        <div class="chart-title">客户服务需求TOP3</div>
					    <div class="chart service-need-rank">
					    </div>
			        </div>
                    <div class="col-4">
                        <div class="chart-title">服务状态</div>
                        <div class="service-state">
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="chart" id="serviceCategory"></div>
                    </div>
			    </div>                   
			</div>
		</div>
	</div>
	<script>
	var nowAdminUsername = '${curAdmin.username}';//临时代码
	</script>
    <script src="${modulePath}datastat/js/common.js"></script>
    <script src="${modulePath}datastat/js/servicestat.js?v=1.3"></script>
</body>
</html>
