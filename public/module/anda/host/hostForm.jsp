<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<form id="frmHost" method="post">
    <table class="form">
        <tr>
            <td>主机识别码</td>
            <td><input class="easyui-textbox" name="hostId" data-options="required: true, validType:'length[16,16]'" style="width:140px" ></td>
        </tr>
        <tr>
            <td>电话号码</td>
            <td><input class="easyui-textbox" name="telNumber" data-options="validType:'length[5,11]'" style="width:140px" ></td>
        </tr>
    </table>
</form>