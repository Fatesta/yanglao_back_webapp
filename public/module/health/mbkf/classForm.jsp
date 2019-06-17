<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <form id="form" method="post"  enctype="multipart/form-data">
        <input type="hidden" name="id" value="${classes.id}" />
		<input type="hidden" name="thumbnailUrl" value="${classes.thumbnailUrl}" />

        <table class="form">
        
        	<tr>
                <td>班次名称</td>
                <td>
                    <input class="easyui-textbox" name="className" value="${classes.className}" style="width: 200px;"
                        data-options="required:true,validType:'length[1,50]'">
                </td>
            </tr>
		    <tr>
		        <td>开班日期</td>
		        <td><input class="easyui-datebox" data-options="required:true,editable:false" name="startDate" value="${classes.startDate}"/></td>
		    </tr>
		    <tr>
		        <td>结束日期</td>
		        <td><input class="easyui-datebox" data-options="required:true,editable:false" name="endDate" value="${classes.endDate}"/></td>
		    </tr>
		    
		    <tr>
		            <td>封面图片</td>
		            <td>
		                <img id="imgPro" src="${classes.thumbnailUrl}" style="max-width:100px;max-height:300px">
						<a id="updateImg" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${pro.id == null ? "上传" : "修改"}</a>
  					</td>
		        </tr>
            <tr>
	        <tr>
	            <td>开班简介</td>
	            <td>
	                <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="remark" data-options="validType:'length[0,500]'">${classes.remark}</textarea>
	            </td>
	        </tr>
	        
	        
	        <tr>
	            <td>课程小结</td>
	            <td>
	                <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="summary" data-options="validType:'length[0,500]'">${classes.summary}</textarea>
	            </td>
	        </tr>
            <tr>
                <td>分类</td>
                <td>
                    <input class="easyui-combobox" name="category"
                        data-options="
                            required: true,
                            url: '${urlPath }dict/listByPid.do?pid=information_health',
                  			 valueField: 'did',
                            textField: 'name',
                            editable: false,
                            value: '${classes.category}'"
                        style="width:100px;"/>
                </td>
            </tr>
            
            
        	
        	<tr>
                <td>课程分类</td>
                <td>
                    <input class="easyui-combobox" name="courseType"
                        data-options="
                            required: true,
                            url: '${urlPath }dict/listByPid.do?pid=learning_class',
                            valueField: 'did',
                            textField: 'name',
                            editable: false,
                            value: '${classes.courseType}'"
                        style="width:100px;"/>
                </td>
            </tr>
            
            
            
            <tr>
        		<td>课程价格</td>	
                <td><input class="easyui-numberbox" name="coursePrice" 
                data-options="precision:2,required:true"  style="width: 100px;" value="${classes.coursePrice}">元</td>
        	</tr>
        </table>
    </form>
</body>
</html>