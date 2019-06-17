<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>

    <form id="form" enctype="multipart/form-data" method="post">
        <input type="hidden" name="batch" value="${grantBatch.batch}" />
        <input type="hidden" name="logDate" value="${grantBatch.logDate}" />
        <table class="form">
            <c:if test="${empty grantBatch.batch}">
            <tr>
                <td>数据文件</td>
                <td>
                    <input class="easyui-filebox" id="filebox" name="file" style="width:200px;" required="required" data-options="buttonText:'导入',accept:'application/vnd.ms-excel'">
                    <a id="match" class="easyui-linkbutton" data-options="iconCls:'icon-member'" href="#" style="display:none">检查匹配</a>
                </td>
            </tr>
            </c:if>
            <tr>
                <td>标题</td>
                <td>
                    <input class="easyui-textbox" name="title" style="width: 400px;"
                        value="${grantBatch.title}"
                        data-options="required:true,validType:'length[1,255]'">
                </td>
            </tr>
            <tr>
                <td>日期</td>
                <td>
                    <%
                     com.xtxk.hb.grant.model.GrantBatch acc = (com.xtxk.hb.grant.model.GrantBatch)request.getAttribute("grantBatch");
                     String logYear = null, logMonth = null;
                     if (acc.getBatch() == null) {
                         logYear = String.valueOf( java.util.Calendar.getInstance().get(java.util.Calendar.YEAR));
                         logMonth = String.valueOf( java.util.Calendar.getInstance().get(java.util.Calendar.MONTH) + 1);
                     } else {
                      logYear = acc.getLogDate().substring(0, 4);
                      logMonth = acc.getLogDate().substring(4);
                     }
                     request.setAttribute("logYear", logYear);
                     request.setAttribute("logMonth", logMonth);
                    %>
	                <input class="easyui-numberspinner" id="logYear" name="logYear" value="${logYear}"
	                    data-options="required: true, editable: false"
	                    style="width: 70px;">年
                    <input class="easyui-numberspinner" id="logMonth" name="logMonth" value="${logMonth}"
                        data-options="required: true, editable: false, min: 1, max: 12"
                        style="width: 46px;">月</td>
            </tr>
            <tr>
                <td>备注</td>
                <td>
                    <textarea rows="6" cols="40" class="easyui-validatebox" name="note"
                        value="${grantBatch.note}"
                        data-options="required:false,validType:'length[1,1000]'"></textarea>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>