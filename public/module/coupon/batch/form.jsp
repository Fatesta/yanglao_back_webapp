<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post">
        <input type="hidden" name="id" value="${couponBatch.id}" />
        <input type="hidden" name="adminId" value="${curAdmin.adminId}" />
        <input type="hidden" name="providerId" value="0" />
        <table class="form">
            <tr>
                <td>主题</td>
                <td>
                    <input class="easyui-textbox" name="subject" value="${couponBatch.subject}" style="width: 300px;"
                        data-options="required:true,validType:'length[1,225]'">
                </td>
            </tr>
            <tr>
                <td>类型</td>
                <td>
                    <input class="easyui-combobox" id="type" name="type" style="width:100px;"
                        data-options="required:true"/>
                </td>
            </tr>
            <tr>
                <td>开始时间</td>
                <td><input class="easyui-datetimebox" id="startTime" name="startTime" value="${servicePlanTemplate.startTime}" data-options="editable: false, required:true" ></td>
            </tr>
            <tr>
                <td>结束时间</td>
                <td><input class="easyui-datetimebox" id="endTime" name="endTime" value="${servicePlanTemplate.endTime}" data-options="editable: false, required:true, validType:{isAfter:['#startTime', '结束时间必须在开始时间之后']}" ></td>
            </tr>
            <tr>
                <td>内容</td>
                <td>
                    <textarea rows="3" cols="44" class="easyui-validatebox" name="content" data-options="validType:'length[0,1000]'">${couponBatch.content}</textarea></td>
            </tr>
	        <tr>
	            <td>条件最低金额</td>
	            <td><input class="easyui-numberbox" name="lowestMoney" value="${product.lowestMoney}" data-options="precision:2,required:true"  style="width: 80px;"></td>
	        </tr>
            <tr>
                <td>优惠金额</td>
                <td><input class="easyui-numberbox" name="discountAmount" value="${product.discountAmount}" data-options="precision:2,required:true"  style="width: 80px;"></td>
            </tr>
            <tr>
                <td>申请优惠卷数量</td>
                <td><input class="easyui-numberbox" name="couponQuantity" value="${product.couponQuantity}" data-options="precision:0,required:true"  style="width: 60px;"></td>
            </tr>
        </table>
    </form>
</body>
</html>