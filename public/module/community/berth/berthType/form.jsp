<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<form id="frmCommunityBerthType" method="post">
	    <input type="hidden" name="id" value="${berthType.id}">
	    <input type="hidden" name="communityId" value="${berthType.communityId}" />
	    <input type="hidden" name="createTime" value="${berthType.createTime}" />
	    <input type="hidden" name="changeParentId" value="${berthType.changeParentId}" />
	    <table class="form">
	    	<tr>
	    		<td>名称</td>
	    		<td>
	    			<input class="easyui-textbox" name="name" value="${berthType.name}" style="width: 150px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
	        <tr>
	            <td>价格</td>
	            <td>
	               <input class="easyui-numberbox" name="monthPrice" value="${berthType.monthPrice}" data-options="precision:2,required:true"  style="width: 60px;">
	               <span class="info">元/月(30天)</span>
	            </td>
	        </tr>
	    	<tr>
                <td>说明</td>
                <td>
                    <textarea rows="3" style="width: 300px;height: 60px;" class="easyui-validatebox" name="remark" data-options="validType:'length[0,512]'">${berthType.remark}</textarea>
                </td>
	    	</tr>
	    </table>
	</form>
