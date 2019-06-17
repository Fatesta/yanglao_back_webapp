<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <div class="model-form-panel">
	    <form id="frmBerthLeave" method="post">
	        <input type="hidden" name="berthId" value="${checkin.berthId}"/>
	        <input type="hidden" name="endTime"/>
	        <table class="form model-form">
	            <tr>
	                <td style="width:30%">床位</td>
	                <td>
	                    ${berth.berthNo}
	                </td>
	            </tr>
	            <tr>
	                <td>床位类型</td>
	                <td>${berthType.name}；价格${berthType.monthPrice}元/月
	                </td>
	            </tr>
	            <tr>
	                <td>入住日期</td>
	                <td name="startTime">
	                    <input class="easyui-datebox" id="startTimeBox"
	                    value='<fmt:formatDate value="${checkin.startTime}" pattern="yyyy-MM-dd" />'
	                    data-options="readonly:true, required:true" style="width: 100px;"></td>
	            </tr>
	            <tr>
	                <td>退住日期</td>
	                <td><input class="easyui-datebox" id="endTimeBox"
	                    value='<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" />'
	                    data-options="required:true"
	                    style="width: 100px;"></td>
	            </tr>
	            <tr>
	                <td>入住时长</td>
	                <td name="duration"></td>
	            </tr>
                <tr>
                    <td>总费用</td>
                    <td>
                        <input class="easyui-numberbox" id="yingfu" name="amount" data-options="required:true,precision:2" style="width: 80px;">
                        <br>
                        <span class="info">
                                                              计算公式：
                            <code>
                               <p><var>床位日价格</var> = <var>床位类型每月价格</var> / 30天</p>
                               <p><var>总费用</var> = <var>床位日价格</var>&times;<var>入住时长天数</var> = <span id="calcMoney"></span></p>
	                        </code></span>
                    </td>
                </tr>
                <tr>
                    <td>押金</td>
                    <td><input id="deposit" class="easyui-numberbox" value="${checkin.deposit}" data-options="precision:2,disabled:true" style="width: 80px;"></td>
                </tr>
                <tr>
                    <td>实交金额</td>
                    <td>
                        <input class="easyui-numberbox" name="paidMoney" data-options="precision:2" style="width: 80px;">
                    </td>
                </tr>
                <tr>
                    <td>欠款</td>
                    <td>
                        <input class="easyui-numberbox" id="qiankuan" data-options="precision:2,disabled:true" style="width: 80px;">
                        <span id="qiankuanDesc" style="display:inline-block;width: 140px;">未交清</span>   
                        <span class="info">计算公式：<code><var>总费用</var> - <var>押金</var> - <var>实交金额</var></code></span>
                    </td>
                </tr>
	        </table>
	    </form>
        <div class="form-submit-buttons">
            <a id="submit" class="easyui-linkbutton" data-options="iconCls:'icon-save'">提交</a>
            <a id="back" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
        </div>
    </div>
    
    <script>
    var berthCheckinId = '${berth.berthCheckin.id}';
    </script>
    <script src="${modulePath}community/berth/tool.js"></script>
    <script src="${modulePath}community/berth/checkin/js/leaveForm.js?v=1.4"></script>
</body>
</html>
