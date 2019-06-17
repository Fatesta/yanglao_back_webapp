<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<form id="alarmNoticePhoneConfigForm" method="post">
    <input type="hidden" name="hostId" value="${hostId}">
    <table class="form">
        <tr>
            <td>手机号码</td>
            <td>
                <input class="easyui-textbox" name="phone" data-options="required: true" style="width: 100px;">
            </td>
            <td>
                <a id="alarmNoticePhoneTest" class="easyui-linkbutton" data-options="iconCls:'icon-message'">短信发送测试</a>
            </td>
        </tr>
        <tr>
            <td>号码备注</td>
            <td colspan="2">
                <input class="easyui-textbox" name="memo"  style="width: 200px;">
            </td>
        </tr>

    </table>
</form>
</body>
</html>