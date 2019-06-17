<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post"  enctype="multipart/form-data">
        <input type="hidden" name="cardId" value="${serviceCard.cardId}" />
        <input type="hidden" name="coverImage" value="" />
        <table class="form">
            <tr>
                <td>名称</td>
                <td>
                    <input class="easyui-textbox" name="cardName" value="${serviceCard.cardName}" style="width: 300px;"
                        data-options="required:true,validType:'length[1,100]'">
                </td>
            </tr>
            <tr>
                <td>封面图片</td>
                <td>
                    <img id="coverImage" src="${serviceCard.coverImage}" style="max-width:180px;max-height:140px">
                    <a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${serviceCard.cardId == null ? "上传" : "重新上传"}</a>
                    <select id="cardTypeSelect" class="easyui-combobox" style="width:100px;">
                        <option value="">或选择:</option>                         
                        <option value="${staticPath}images/servicecard/card_experience.png">体验卡</option>
                        <option value="${staticPath}images/servicecard/card_diamond.png">钻石卡</option>
                        <option value="${staticPath}images/servicecard/card_golden.png">金卡</option>
                        <option value="${staticPath}images/servicecard/card_platinum.png">铂金卡</option>
                        <option value="${staticPath}images/servicecard/card_silver.png">银卡</option>
                    </select>
                </td>
            </tr>
	        <tr>
	            <td>价格</td>
	            <td><input class="easyui-numberbox" name="price" value="${serviceCard.price}" data-options="precision:2,required:true"  style="width: 80px;"></td>
	        </tr>
<%--             <tr>
                <td>卡发行数量</td>
                <td><input class="easyui-numberbox" name="quantity" value="${serviceCard.quantity}" data-options="precision:0,required:true"  style="width: 80px;"></td>
            </tr> --%>
            <tr>
                <td>有效期</td>
                <td>
                    <select id="expirationDate" class="easyui-combobox" name="expirationDate" value="${serviceCard.expirationDate}" style="width: 80px;"
                        data-options="required:true,precision:0"></select>天
                </td>
            </tr>
            <tr>
                <td>联系电话</td>
                <td>
                    <input class="easyui-textbox" name="contactNumber" value="${serviceCard.contactNumber}" style="width: 140px;"
                        data-options="required:true,validType:'length[1,30]'">
                </td>
            </tr>
            <tr>
                <td>特权说明</td>
                <td>
                    <textarea rows="5" cols="80" class="easyui-validatebox" name="privilegeSpecification" data-options="validType:'length[0,500]'">${serviceCard.privilegeSpecification}</textarea></td>
            </tr>
            <tr>
                <td>使用须知</td>
                <td>
                    <textarea rows="5" cols="80" class="easyui-validatebox" name="useNotice" data-options="validType:'length[0,500]'">${serviceCard.useNotice}</textarea></td>
            </tr>
            <tr>
                <td>描述</td>
                <td>
                    <textarea rows="5" cols="80" class="easyui-validatebox" name="description" data-options="validType:'length[0,500]'">${serviceCard.description}</textarea></td>
            </tr>
        </table>
    </form>
</body>
</html>