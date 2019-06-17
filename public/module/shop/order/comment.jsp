<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form id="frmComment" method="post">
        <input type="hidden" name="orderno" value="${orderno}"/>
        <input type="hidden" name="feedbackPerson"/>
        <table class="form">
            <tr>
                <td>回访评分</td>
                <td>
                    <div id="starLevel"></div>
                </td>
            </tr>
            <tr>
                <td>文字评价</td>
                <td>
                    <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="feedbackMessage" data-options="validType:'length[0,500]'"></textarea>
                </td>
            </tr>
            <tr>
                <td>选择用户</td>
                <td>
                    <a id="selectUser" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择用户</a>
                                            已选择：<p id="userName" style="display:inline"></p>
                </td>
            </tr>
        </table>
    </form>

<script type="text/javascript" src="${libPath}jquery.raty.min.js"></script>
<script>

$('#starLevel').raty({
    score: 5,
    scoreName: 'starLevel',
    starOff: '${imagePath}/stars/star-off.png',
    starOn : '${imagePath}/stars/star-on.png'
});
</script>
</body>
</html>