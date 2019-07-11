<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<form id="frmBerth" method="post">
	    <input type="hidden" name="id" value="${berth.id}">
	    <input type="hidden" name="roomId" value="${berth.roomId}" />
	    <input type="hidden" name="isEmpty" value="${berth.isEmpty}" />
	    <input type="hidden" name="checkinId" value="${berth.checkinId}" />
        <input type="hidden" name="createTime" value="${berth.createTime}" />
        <input type="hidden" name="changeParentId" value="${berth.changeParentId}" />
	    <table class="form">
	    	<tr>
	    		<td>床位编号</td>
	    		<td>
	    			<input class="easyui-textbox" name="berthNo" value="${berth.berthNo}" style="width: 150px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
            <tr>
                <td>床位类型</td>
                <td>
                    <input class="easyui-combobox" name="berthTypeId"
                        data-options="
                            required: true,
                            value: '${berth.berthTypeId}',
                            url: '${urlPath}community/berth/berthType/page.do?rows=10000&page=1&resthomeId=${resthomeId}',
                            valueField: 'id',
                            textField: 'name',
                            loadFilter: function(page) { return page.rows; }"  style="width: 150px;"/>
                </td>
            </tr>
	    </table>
	</form>
