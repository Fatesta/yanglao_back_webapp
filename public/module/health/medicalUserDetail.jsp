<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/material/easyui.css">
<link rel="stylesheet" type="text/css" href="${libPath}easyui/themes/icon.css">
<title>远程咨询 - 个人健康档案</title>
</head>
<body>
<div class="wc-view">
    <div class="head-view">
        <div class="head-line"></div>
        <div class="head-title">个人健康档案</div>
        <div class="head-body">
        	<c:set var="headUrl" value='${empty medicalUser.headUrl ? "../images/medicaluser_head.png" : medicalUser.headUrl}' />
            <img src="${headUrl}">
            <div class="head-content">
                <div class="row-view">
                    <div class="col33-view">姓名：${medicalUser.userName }</div>
                    <div class="col33-view">性别：${medicalUser.sex==0?'男':'女' }</div>
                    <div class="col33-view">年龄：${medicalUser.age }</div>
                </div>
                <div class="row-view">联系电话：${medicalUser.telephone }</div>
                <div class="row-view">家庭地址：${medicalUser.address }</div>
            </div>
        </div>
    </div>
    <div class="body-view">
        <dl class="dl1-view top-view">
            <dt>病史</dt>
            <dd>${medicalUser.remark }</dd>
        </dl>
        <dl class="dl1-view">
            <dt>附加信息</dt>
            <c:forEach var="f" items="${files}" varStatus="st">
            	<dd>附件名称：${f.fileName }<a href="${f.imgPath }" target="_blank">查看>></a></dd>
			</c:forEach>
        </dl>
        <dl id="inquiryRecords" class="dl1-view">
        </dl>
    </div>
    <a id="print" class="easyui-linkbutton" data-options="iconCls:'icon-print'">打印</a>
</div>

<script src="${libPath}easyui/jquery.min.js"></script>
<script src="${libPath}easyui/jquery.easyui.min.js"></script>
<script>
$(function(){
	$('#print').click(function(){
	    $.get("${urlPath}health/getMedicalUserInfoPDF.do?userId=${medicalUser.userId}", function(ret){
	        if(ret.flag) {
	            var a = $("<a href=" + ret.url + " target='_blank' ></a>").get(0);
	            var e = document.createEvent('MouseEvents');
	            e.initEvent('click', true, true);
	            a.dispatchEvent(e);
	        }
	    });
	});

	
	var inquiryRecords = ${inquiryRecords}.rows;
	
	var html = "<dt>咨询记录</dt>", r;
	for(var index=0; index<inquiryRecords.length; index++) {
		r = inquiryRecords[index];
		var time = r.createTime.substring(0, 10);
		var text = (r.medicalResult || "");
		text = text.substring(0, 40) + (text.length > 40 ? "..." : "");
		html += "<dd>" + time
			+ "&nbsp;&nbsp;<a href=javascript:checkFullContent(" + index + ")>"
			+ text + "</a></dd>";
	}
	if(inquiryRecords.length == 0) {
		html += "<dd>暂无咨询记录。</dd>";
	}
	$("#inquiryRecords").html(html);
	
	window.checkFullContent = function(index) {
		var content = inquiryRecords[index].medicalResult;
		var divDlg = parent$("<div style='word-wrap: break-word'>" + content + "</div>");
		divDlg.appendTo($(parent.document.body));
		divDlg.dialog({
		    title: "完整内容",    
		    width: 500,
		    height: 400,
		    closed: false,
		    cache: false,  
		    modal: true   
		});
	};
});
</script>
</body>
</html>