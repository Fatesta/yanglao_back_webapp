<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <form id="form" method="post">
        <input type="hidden" name="id"/>
        <input type="hidden" name="resourceId" />
        <input type="hidden" name="industryId" />
        <input type="hidden" name="status" />
        <input type="hidden" name="isvalid" />
        <input type="hidden" name="content" />
        <table class="form">
            <tr>
                <td>类型</td>
                <td>
                    <input class="easyui-combobox" id="type" name="type"
                        data-options="required:true,editable:false" style="width: 80px">
                    <span id="typeNote" class="tip-info"></span>
                </td>
            </tr>
            <tr colspan="2" id="titleTr" style="display:none">
                <td>标题</td>
                <td><input class="easyui-textbox" name="title" data-options="required:true,validType:['length[2,100]']" style="width:240px;"></td>
            </tr>
	        <tr id="resourceSelectTr">
                <td>资源</td>
                <td>
                    <input id="selectedResource" class="easyui-textbox" data-options="required:true,editable:false" style="width:240px;"></div>
	                <a id="selectResource" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"></a>
                </td>
	        </tr>
	        <tr id="openEditTr" style="display:none">
	           <td>图文</td>
	           <td>
	               <a id="openEdit" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"></a>
	           </td>
	        </tr>
            <tr id="pointTr" style="display:none">
               <td>积分</td>
               <td colspan="3" class="form">
                   <input class="easyui-numberbox" name="sendPoint" value=0 data-options="min:0,precision:0,required:true"  style="width: 50px;"></td>
            </tr>
        </table>
    </form>