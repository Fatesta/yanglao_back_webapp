<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<form id="communityDepartmentForm" method="post">
	    <input type="hidden" name="id" value="${department.id }">
    	<input type="hidden" name="level" value="${department.level}">
    	<input type="hidden" name="parentId" value="${department.parentId }">
    	<input type="hidden" name="communityId" value="${department.communityId}">
	    <table class="form">
	    	<tr>
	    		<td>名称</td>
	    		<td>
	    			<input class="easyui-textbox" name="name" value="${department.name}" style="width: 250px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
		 	<tr>
		 		<td>简介</td>
                <td>
                    <textarea name="remark" class="easyui-validatebox" rows="3" style="width: 320px;height: 60px;">${department.remark}</textarea>
                </td>
            </tr>
	    </table>
	</form>
