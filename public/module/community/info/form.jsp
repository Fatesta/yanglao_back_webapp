<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <script src="${libPath}utils/require.js"></script>
    <script><jsp:include page="/lib/utils/require-config.js" /></script>
    <style>
        #map {
            width: 100%;
            height: 100%;
        }
        #r-result {
            position: absolute;
            width: 100%;
            overflow: scroll;
        }
        <c:if test="${mode == 'nopadding'}">
        .model-form-panel {
            margin-top: 1px;
        }
        .model-form {
            width: 100%;
            height: 93%;
        }
        </c:if> 
    </style>
</head>
<body class="model-form-panel">
    <form id="form" method="post" >
        <input type="hidden" name="id" value="${community.id}" />
        <input type="hidden" name="serviceContent" />
        <input type="hidden" name="latitude" />
        <input type="hidden" name="longitude" />
        <table class="form model-form">
            <tr>
                <td>社区名称：</td>
                <td colspan="4"><input class="easyui-textbox" name="name" data-options="validType:['length[2,100]']" style="width:300px;"></td>
            </tr>
            <tr rowspan="60">
                <td style="width:100px;">社区简介：</td>
                <td colspan="4" style="height:333px">
                    <script id="infoEditor" type="text/plain" style="width:100%;"></script>
                </td>    
            </tr>
            <tr>
                <th>社区人口：</th>
                <td>
                     <input class="easyui-numberbox" name = "peoples"data-options="precision:0" style="width:300px;"/>
                     <span class="info">人</span>
                </td>
                <th>老人占比：</th>
                <td id="alignCell" colspan="2">
                     <input class="easyui-numberbox" name = "oldmanPercentage" data-options="precision:0" style="width:40%"/>
                     <span class="info">%</span>
                </td>
            </tr>
            <tr>
                <td>服务内容：</td>
                <td colspan="4">
                     <input class="easyui-textbox" name = "remark"style="width:300px;"/>
                </td>
            </tr>
            <tr>
                <td>服务热线：</td>
                <td>
                     <input class="easyui-textbox" name = "serviceTel" style="width:300px;"/>
                </td>
                <th rowspan="4" style="vertical-align: top;">社区地址：</th>
                <td rowspan="4" style="vertical-align: top;width:20%;">
                    <div id="addressCell" style="position:relative;">
	                    <input class="easyui-textbox" name="address" data-options="multiline:true,validType:['length[0,500]']" style="width:100%;height:100px;" />
	                    <a id="searchLocal" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="float:right;margin-top: 4px;">搜索</a>
                    </div>
                </td>
                <td rowspan="4" style="position:relative;vertical-align: top;width:30%;">
                    <div id="map"></div>
                    <div id="r-result"></div>
                </td>
            </tr>
            <tr>
                <td>联系人：</td>
                <td>
                    <input class="easyui-textbox" name = "contactName" style="width:300px;"/>
                </td>
            </tr>     
	        <tr>
	            <td>联系电话：</td>
	            <td>
	                 <input class="easyui-textbox" name = "contactTel" style="width:300px;"/>
	            </td>
	        </tr>
            <tr>
                <td>邮箱：</td>
                <td>
                     <input class="easyui-textbox" name = "email" style="width:300px;"/>
                </td>
            </tr>
        </table>
    </form>
    <div class="form-submit-buttons">
        <a id="save" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
    </div>
<script>
window.UEDITOR_HOME_URL = '${libPath}ueditor1_4_3_3-utf8-jsp/';
$(function() {
    $('#alignCell > .textbox').width($('#addressCell').width());
});
</script>
<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.config.js"></script>
<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.all.js"> </script>
<script type="text/javascript" src="https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc"></script>
<script src="${modulePath}community/info/form.js?v=2.1"></script>
<script>
require(['/lib/ueditor1_4_3_3-utf8-jsp/third-party/zeroclipboard/ZeroClipboard.js'], function (ZeroClipboard) {
    window['ZeroClipboard'] = ZeroClipboard;
    CommunityInfo.init();
});
</script>
</body>
</html>