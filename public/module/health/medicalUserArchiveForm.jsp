<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<form id="medicalUserArchiveForm" enctype="multipart/form-data" method="post">
		<input type="hidden" name="userId" value="${medicalUser.userId}">
		
		<table class="form">
          <tr>
              <td>病史</td>
              <td><textarea class="easyui-validatebox" name="remark" rows="10" cols="40" style="width: 440px">${medicalUser.remark }</textarea></td>
          </tr>
          <tr>
              <td>附件(病历文件)</td>
              <td><a class="easyui-linkbutton" data-options="iconCls:'icon-edit-add'" href="javascript:;" id="addFilebox">新增附件</a></td>
          </tr>
          <tr>
              <td></td>
              <td>
                  <div id="fileboxList"></div>
              </td>
          </tr>
		</table>
	</form>

<script src="${libPath}template.js"></script>
<script id="fileFileInputTpl" type="text/html">
    <input type="file" name="mfile" style="width:300px" data-options="buttonText:'选择文件'" />
</script>
<script id="fileTextInputTpl" type="text/html">
    <span style="width:300px; display: inline;"><a href="{{fileUrl}}" target="_blank">{{fileName}}</a></span>
	<input type="hidden" name="fileId" style="width:300px" value="{{fileId}}" />
</script>
<script id="fileboxTpl" type="text/html">
    <dd name="filebox">
            <div style="margin-top: 8px">
            	{{inputType}}
            	<a href="#" class="easyui-linkbutton" name="delFile" data-options="iconCls:'icon-delete'"></a>
            </div>
    </dd>
</script>
<script id="fileList" type="text/json">
[
<c:forEach var="f" items="${files}" varStatus="st">
  {"fileName": "${f.fileName}", "fileUrl": "${f.imgPath}", "imgPath": "${f.imgPath}", "fileId": "${f.fileId}"}
  <c:if test="${not st.last}">,</c:if>
</c:forEach>
]
</script>
<script>
$(function(){
	$("#addFilebox").click(function(){
		var fileboxList = $("#fileboxList");
		var fileTypeHtml = $("#fileFileInputTpl").text();
		var newFilebox = $($("#fileboxTpl").text().replace(/{{inputType}}/g, fileTypeHtml));
		var btnDel = newFilebox.find("[name=delFile]");
		btnDel.click(function(){
			$(this).parent().parent().remove();
		});
		fileboxList.append(newFilebox);
	});

	var files = JSON.parse($("#fileList").text());
	for(var i = 0; i < files.length; i++) {
		(function(fileData) {
			var fileboxList = $("#fileboxList");
			var fileTypeHtml = template('fileTextInputTpl', fileData);
			var newFilebox = $($("#fileboxTpl").text().replace(/{{inputType}}/g, fileTypeHtml));
			var btnDel = newFilebox.find("[name=delFile]");
			btnDel.click(function(){
				var fileId = $(this).prev("input[name=fileId]").val();
				$("#medicalUserArchiveForm").append("<input type=hidden name=delFileId value=" + fileId + ">")
				$(this).parent().parent().remove();
			});
			fileboxList.append(newFilebox);
		})(files[i]);
	}
});
</script>