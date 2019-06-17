<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="lookupfrm" method="post">
        <input type="hidden" name="id" value="${returnvisit.id}"/>
        <table class="form">
            
            <tr>
                <td>回访时间</td>
                <td name="visitTime"></td>
            </tr>
            <tr>
                <td>回访内容</td>
                <td>
                    <textarea style="width: 260px" name= "subject" rows="5" class="easyui-validatebox" name="subject" data-options="readonly:true,validType:'length[0,500]'">${returnvisit.subject}</textarea>
                </td>
            </tr>
        <tr>
                <td>回访结果</td>
                <td>
                    <textarea style="width:260px;" rows="5" class="easyui-validatebox" name="result" data-options="readonly:true,validType:'length[0,500]'">${returnvisit.result}</textarea>
                </td>
            </tr>
            <tr>
                <td>星级评分</td>
                <td>
                    <div id = "score" name = "score"></div>
                </td>
            </tr> 
        </table>
    </form>
     <script src="${libPath}jquery.raty.min.js"></script>
   </body></html>