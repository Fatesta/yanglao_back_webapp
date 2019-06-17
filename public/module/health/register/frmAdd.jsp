<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<form id="frm" method="post">
        <input type="hidden" id="userId" name="userId" value="">
		<input type="hidden" name="status" value="2">
		<table class="form">
		    <tr>
		    	<td>用户姓名</td>
		    	<td>
		    		<input class="easyui-textbox" id="userName" data-options="required:true,editable:false" style="width:200px"/>
		    		<a id="selectUser" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">选择用户</a></td>
		    </tr>
            <tr>
                <td>身份证号码</td>
                <td>
                    <input class="easyui-textbox" id="idcard" name="idcard" data-options="required:true,validType:'length[15,18]'" style="width:200px">
                </td>
	    	</tr>
            <tr>
                <td>用户手机号</td>
                <td><input class="easyui-numberbox" id="phone" name="phone" data-options="required:true,validType:{length:[11,11]},precision:0"  style="width:200px"></td>
            </tr>
            <tr>
                <td>医院负责人手机号</td>
                <td>
                <input class="easyui-numberbox" name="doctor" data-options="required:true,validType:{length:[11,11]},precision:0" style="width:100px">
                <span class="tip-info">（用于接收短信）</span>
                </td>
            </tr>
            <tr>
                <td>预约时间</td>
                <td>
                    <input class="easyui-datebox" data-options="required:true,editable:false" name="reservationDate" style="width:100px">
                    <input class="easyui-combobox" name="reservationTime"
                        data-options="required:true, data:(function(){
                            var arr = [];
                            for (var h = 8; h < 17; h++) {
                              if (h < 12 || h > 13) {
                                var val = String.leftPad0(h) + ':00' + '-' + String.leftPad0(h + 1) + ':00';
                                arr.push({value: val, text: val});
                              }
                            }
                            return arr;
                        })()" style="width:97px"></td>
            </tr>
	    	<tr>
	    		<td>医院名称</td>
	    		<td><input class="easyui-textbox" name="hospital" data-options="required:true" style="width:200px"></td>
	    	</tr>
	    	
	    	<tr>
	    		<td>病因</td>
	    		<td><textarea rows="4" class="easyui-validatebox" name="illness" data-options="required:true,validType:{length:[1,60]}"  style="width:270px"></textarea></td>
	    	</tr>
	    </table>
	</form>

	<script src="${modulePath}user/select.js"></script>