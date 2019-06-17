<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <div class="model-form-panel">
	    <form id="frmSendSms" enctype="multipart/form-data" method="post">
	        <table class="form model-form">
                <tr>
                    <td style="width:9%;">手机号码输入方式</td>
                    <td>
                        <select id="mobileInputType" name="mobileInputType" class="easyui-combobox" style="width:100px;">
                            <option value="csv">输入</option>
                            <option value="csvFile">CSV文件</option>
                        </select>
                        <span class="tip-info" style="display:none">CSV即字符分隔值，一种格式。例如<code>x,y,z</code>，用逗号分隔3个数据项。注意：请在一个CSV文件中，只使用一种分隔符</span>
                    </td>
                </tr>
	            <tr id="mobileTr">
	                <td style="width:6%;">手机号码</td>
	                <td>
	                    <textarea class="easyui-validatebox" name="mobileCsv" style="width: 30%;height:100px;"
	                        data-options="required:true"></textarea>
	                    <span class="tip-info">多个用英文逗号( , )隔开</span>
	                </td>
	            </tr>
                <tr id="importMobileTr" style="display:none">
                    <td style="width:6%;"></td>
                    <td>
                        <input class="easyui-filebox" name="mobileCsvFile" style="width:200px;" data-options="buttonText:'导入',accept:'text/plain'">
                        <span style="margin-left: 10px;">此CSV文件所用分隔符：</span>
                        <select name="delimiter" class="easyui-combobox" style="width:140px;">
                            <option value=",">英文逗号（,）</option>
                            <option value="line">换行（每行一个记录）</option>
                            <option value="space">空白（Tab和Space）</option>
                        </select>
                        <span><a id="checkCsvFile" class="easyui-linkbutton" data-options="iconCls:'icon-check'" style="margin-left: 20px;">检查文件</a></span>
                    </td>
                </tr>
	            <tr>
	                <td>短信内容</td>
	                <td>
	                    <textarea rows="3" class="easyui-validatebox" name="content"
	                        data-options="required:true, validType:'length[4,300]'" style="width: 90%;height: 100px;" ></textarea>
	                </td>
	            </tr>
	        </table>
	    </form>
        <div class="form-submit-buttons">
            <a id="submit" class="easyui-linkbutton" data-options="iconCls:'icon-message'">发送</a>
            <a id="close" class="easyui-linkbutton" data-options="iconCls:'icon-back'">关闭</a>
        </div>
    </div>
    <script src="${modulePath}sendSms/sendSms.js"></script>
</body>
</html>