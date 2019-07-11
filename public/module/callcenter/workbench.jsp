<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
	<link rel="stylesheet" type="text/css" href="//g.alicdn.com/acca/workbench-sdk/0.4.3/main.min.css" />
	<link rel="stylesheet" type="text/css" href="${modulePath}callcenter/main.css?v=2.1" />
    <script src="${libPath}utils/require.js"></script>
</head>

<body id="layout" class="easyui-layout">
    <div data-options="region:'west', collapsible: true" style="width:290px;display:none">
	    <div id="leftTabs" class="easyui-tabs" style="width:100%;height:100%;">
			<div id="workbench" title="呼叫中心"></div>
            <div id="agent" title="坐席" data-options="fit:true">
                <div class="info">
	                <table cellspacing="0" cellpadding="0" width="100%">
	                    <tr class="">
	                        <td>
	                            <a id="imageLocation" href="javascript:void(0);" onclick="chooseImg();"><img src="${modulePath}callcenter/img/5.png"></a>
	                        </td>
	                        <td>
	                            <span class="name"></span>
	                            <span class="phone" id="havePhone">02759769039</span>
	                            <p class="duration" style="margin-top:5px;" id="nowTime">00:00:00</p>
	                        </td>
	                    </tr>
	                </table>
                </div>
				<div class="seat" id="seatDiv" style="display: block">
					<div class="gp_s">
						<span class="f_l">座席状态</span><a id="onlineCount">0</a>
					</div>
					<div class="group">

						<span>
							<p>
								<span class="f_l"><span name="deptName">02759769039</span>
									[<span name="onlineAgent">0</span>/<span name="countAgent">0</span>]</span>
								<font style="display: none"> <span name="waitCount">0</span>
								</font>
							</p>

						</span>

					</div>
				</div>
			</div>

		</div>
	</div>
	<div data-options="region:'center'" style="display:none">
	    <div class="easyui-tabs" style="width:100%;height:100%"> 
	        <div title="通话记录">
		        <%@ include file="callrecord.jsp" %>
            </div>
            <!--
            <div title="客户中心">
                <%@ include file="crm/index.jsp" %>
            </div>  -->
	   </div>
	</div>

	<script>
	var cccInstanceId = '${instanceId}';
	var isDevMode = '${isDevMode}' == 'true';
	</script>
	<script src="https://g.alicdn.com/crm/acc-phone/1.1.2/SIPml-api.js"></script>
	<script src="https://g.alicdn.com/crm/acc-phone/1.1.2/index.js"></script>
	<script src="${modulePath}callcenter/workbench.js?v=3.5"></script>
	<script src="${modulePath}callcenter/record.js?v=2.8"></script>
	<script src="${modulePath}user/basicInfo.js?v=1"></script>
</body>
</html>