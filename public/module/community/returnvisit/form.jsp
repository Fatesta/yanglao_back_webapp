<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp"%>
</head>
<body>
<div class="model-form-panel">
	<form id="frmReturnvisit" method="post">
		<input type="hidden" name="id" value="${returnvisit.id}" /> <input
			type="hidden" name="userId" value="${returnvisit.userId}" /> <input
			type="hidden" name="communityId" value="${returnvisit.communityId}" />
		<table  class="form model-form">
			<caption>增加回访记录</caption>
			<tr>
				<td>回访用户</td>
				<td><input id="userName"  class="easyui-textbox"
					data-options="required:true,readonly:true, validType:'length[1,20]'"
					style="width: 120px;"> <a id="selectUser" href="#"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'">选择用户</a>
				</td>
			</tr>
			<tr>
				<td>工作人员</td>
				<td><input class="easyui-textbox" name="visitor"
					
					data-options="required:true,validType:'length[1,20]'" style="width: 120px;"></td>
			</tr>
			<tr>
				<td>回访时间</td>
				<td><input class="easyui-datetimebox" name="visitTime"
					 style="width: 144px;" data-options="required:true"></td>
			</tr>
			<tr>
				<td>回访内容</td>
				<td><textarea style="width: 360px; height: 250px" rows="5"
						class="easyui-validatebox" name="subject"
						data-options="required:true,validType:'length[0,500]'"></textarea>
				</td>
			</tr>

		</table>
	</form>
	    <div class="form-submit-buttons">
		    <a id="save" class="easyui-linkbutton" data-options="iconCls:'icon-save'">提交</a>
		    <a id="back" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
        </div>
</div>

	<script src="${modulePath}user/select.js?v=1"></script>
	<script>
		$('#selectUser').click(
				function() {
					openUserSelectDialog({
						onSelectDone : function(user) {
							$('#frmReturnvisit [name=userId]').val(
									user.userId);
							$('#frmReturnvisit #userName').textbox(
									'setValue', user.aliasName);
							return true;
						}
					});
				});

		$("#save").click(function() {
			formSubmit("#frmReturnvisit",{
				url : 'community/returnvisit/save.do',
				success : function(ret) {
					showOpResultMessage(ret);				
				}
			});
		});
		$('#back').click(closeCurrentModule);
	</script>
</body>
</html>