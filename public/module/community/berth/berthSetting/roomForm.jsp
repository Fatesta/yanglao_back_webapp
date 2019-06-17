<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<form id="frmRoom" method="post">
	    <input type="hidden" name="id" value="${room.id}">
	    <input type="hidden" name="communityId" value="${room.communityId}" />
	    <input type="hidden" name="buildingId" value="${room.buildingId}" />
	    <input type="hidden" name="floorNo" value="${room.floorNo}" />
	    <table class="form">
	    	<tr>
	    		<td>房间编号</td>
	    		<td>
	    			<input class="easyui-textbox" name="roomNo" value="${room.roomNo}" style="width: 150px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
	    	<tr>
                <td>房间描述</td>
                <td>
                    <textarea rows="3" style="width: 300px;height: 60px;" class="easyui-validatebox" name="remark" data-options="validType:'length[0,512]'">${room.remark}</textarea>
                </td>
	    	</tr>
	    </table>
	</form>
