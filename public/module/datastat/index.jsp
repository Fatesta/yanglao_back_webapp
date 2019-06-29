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
</head>
<body>
	
	<div id="charts-layout" class="easyui-layout charts-bg" style="overflow-y: scroll;">
		<div id="charts">
		    <div class="title">
		        <div class="main-title"> 
		        </div>
		    </div>
			<div class="grid">
			    <div class="row" style="height: 50%;">
			        <div class="col-4">
			            <div class="chart" id="totalAndSex"></div>
			        </div>
	                <div class="col-4">
	                    <div class="chart total">
	                        <div style="margin-top: -2em;">
		                        <p class="total-title">总人数</p>
		                        <p id="total" class="total-number"></p>
	                        </div>
	                    </div>
	                </div>
			        <div class="col-4">
			            <div class="chart" id="age"></div>
			        </div>
			    </div>
			    <div class="row" style="height: 50%;">
			        <div class="col-4">
					    <div class="chart" id="ability"></div>
			        </div>
                    <div class="col-4">
                        <div class="chart" id="liveStyle"></div>
                    </div>

                    <div class="col-4">
                        <div class="chart" id="userType"></div>
                    </div>
			    </div>		                 <!--
				<div class="row" style="height: 40%;">
                    <div class="col-6">
                        <div class="chart" id="serviceNeed" ></div>
                    </div>
				</div>

                <div class="row" style="height: 32%;">
                    <div class="col-12">
                        <div class="chart" id="productProviderOrderCounts"></div>
                    </div>
                </div>
			    

			    <div class="row" style="height: 60%;">
			        
                    <div class="col-6">
                        <div class="chart" id="health"></div>
                    </div>
                    <div class="col-6">
                        <div class="chart" id="regionDist"></div>
                    </div>
	                <div class="col-6">
	                    <div class="chart" id="orgUserCount"></div>
	                </div>
			    </div>
			                 
		        <div class="row" style="height: 50%;">
		            <div class="col-6">
		                <div class="chart" id="economy"></div>
		            </div>
		        </div>
 -->
			</div>
		</div>
	</div>
    <script src="${modulePath}datastat/js/common.js"></script>
    <script src="${modulePath}datastat/js/userStat.js?v=2.7"></script>
</body>
</html>
