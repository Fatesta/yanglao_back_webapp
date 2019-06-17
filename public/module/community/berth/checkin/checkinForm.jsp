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
	    <form id="frmCheckin" method="post">
	        <input type="hidden" name="berthId" value="${berthId}"/>
	        <input type="hidden" name="userId" value=""/>
	        <input type="hidden" name="startTime"/>
	        <input type="hidden" name="paidMoney" value="0"/>
	        <table class="form model-form">
	            <caption>填写入住信息</caption>
                <tr>
                    <td>入住床位</td>
                    <td>
                        ${berthNo}
                    </td>
                </tr>
	            <tr>
	                <td>入住人</td>
	                <td>
	                    <input id="userName" class="easyui-textbox" data-options="required:true,readonly:true, validType:'length[1,20]'" style="width: 120px;">
	                    <a id="selectUser" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择用户</a>
	                </td>
	            </tr>
	            <tr>
	                <td>实际入住日期</td>
	                <td><input class="easyui-datebox" id="startTimeBox"
	                   value='<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" />'
	                   data-options="required:true"
                       style="width: 100px;"></td>
	            </tr>
                <tr>
                    <td>已付押金</td>
                    <td><input class="easyui-numberbox" name="deposit" data-options="precision:2"  style="width: 80px;"></td>
                </tr>
	        </table>
	    </form>
	    <div class="form-submit-buttons">
		    <a id="submit" class="easyui-linkbutton" data-options="iconCls:'icon-save'">提交</a>
		    <a id="back" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
        </div>
    </div>

    <script src="${modulePath}user/select.js?v=1"></script>
    <script src="${modulePath}community/berth/checkin/js/checkinForm.js?v=1.3"></script>
</body>
</html>