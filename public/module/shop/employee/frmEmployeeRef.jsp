<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <form id="frmEmployeeRef" method="post">
    	<input type="hidden" name="providerId" value="">
	    <table class="form">
	    	<tr>
    			<td><label for="username">工号</label></td>
    			<td><input class="easyui-textbox" name="username" data-options="required:true,validType:'length[1,20]'" style="width:140px;"></td>
	    	</tr>

	    </table>
	</form>