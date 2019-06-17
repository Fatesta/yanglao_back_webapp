<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
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
			<div class="grid" title="单击以全屏">
			    
			     <div class="row" style="height: 20%;">
	                   <div class="col-4"> </div>
	                   <div class="col-2">
	                       <div class="chart total">
	                       	<div style="margin-top: 1.5 em;" >	                       
		                        <p class="total-title">总活动数</p>		                      
		                        <p id="totalcount" class="total-number"></p>
							 </div>	                    
	                       </div>
	                   </div>
	                   
	                     <div class="col-2">
	                       <div class="chart total">
	                       	<div style="margin-top: 1.5	em;">		                   
		                        <p class="total-title">总参与人次</p>
		                        <p id="totalpeople" class="total-number"></p>		                        	                      
	                        </div>  	                    
                       </div>
	                   </div>
	                   <div class="col-4"> </div>
	               </div>
	               
	               <div class="row" style="height: 75%;">
	                   <div class="col-6">
	                       <div class="chart" id="activitymanager1"></div>
	                   </div>
	                   <div class="col-6">
	                       <div class="chart" id="activitymanager2"></div>
	                   </div>
	               </div>
			</div>
		</div>
	</div>	
	<script src="${modulePath}datastat/js/common.js"></script>
    <script src="${modulePath}datastat/js/activitymanager.js"></script>
</body>
</html>
