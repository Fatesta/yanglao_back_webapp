<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

   <form id="frmPro" method="post"  enctype="multipart/form-data">
   	<input type="hidden" name="id" value="${pro.id }">
	<input type="hidden" name="bossId" value=""/>
	<input type="hidden" name="orgId" value="${pro.id != null ? pro.orgId : ''}">
   	<input type="hidden" name="imgUrl" value="${pro.imgUrl}" />
    <table class="form">
        <c:if test="${pro.id == null}">
        <tr>
            <td>所属商家</td>
            <td id="selectBoss" colspan="3">
                <input class="easyui-textbox" id="bossName" data-options="required:true,validType:'length[1,20]',readonly:true" style="width:140px;">
            </td>
        </tr>
        </c:if>
    	<tr>
    		<td>店铺封面</td>
    		<td colspan="3">
    			<a id="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">${pro.id == null ? "上传" : "修改"}</a>
    		</td>
    	</tr>
        <tr>
            <td></td>
            <td colspan="3">
                <img id="imgPro" <c:if test="${pro.id != null}">src="${pro.imgUrl}"</c:if> style="width:140px;height:100px" />
            </td>
        </tr>
    	<tr>
    		<td>店铺名称</td>
    		<td colspan="3"><input class="easyui-textbox" name="name" data-options="value:'${pro.name}',required:true,validType:'length[1,100]'"  style="width: 250px;"></td>
    	</tr>
    	<tr>
    		<td>所属行业</td>
    		<td colspan="3">
				<input class="easyui-combobox" name="industryId" style="width: 135px;"
   					data-options="
   					    data: DictMan.items('product.industry'),
   					    value: '${pro.industryId}',
   					    required: true,
   					    editable: false">
    		</td>
    	</tr>
    	<tr>
    		<td>所在地区</td>
    		<td>
				<input id="province" name="province" class="easyui-combobox" value="${pro.province}" style="width: 135px;" 
   					data-options="required:true">
    		</td>
    		<td>
				<input id="city" name="city" class="easyui-combobox" value="${pro.city}" style="width: 135px;"
   					data-options="required:true">
    		</td>
    		<td>
				<input id="area" name="area" class="easyui-combobox" value="${pro.area}" style="width: 135px;"
   					data-options="required:true">
    		</td>
    	</tr>
        <tr>
           <td><label for="communityLimit">限制服务社区</label></td>
           <td colspan="3">
               <input class="easyui-combobox" id="cboOrgId" data-value="${pro.id != null ? pro.orgId : ''}" style="width:250px;"/>
           </td>
        </tr>
    	<tr>
    		<td>地址</td>
    		<td colspan="3">
    			<input class="easyui-textbox" name="address" data-options="required:true,validType:'length[0,255]'" value="${pro.address}" style="width: 300px;"/>
    		</td>
    	</tr>
    	<tr>
    		<td>服务范围</td>
    		<td colspan="3">
    			<input class="easyui-numberbox" name="serviceArea" value="${pro.id == null ? 0 : pro.serviceArea}" data-options="required:true,validType:'precision:0'">
    			<span class="tip-info">(单位米，0表示无限制)</span>
    		</td>
    	</tr>
	    <tr>
	    	<td>营业时间</td>
	    	<td colspan="3">
	    		<input class="easyui-textbox" name="serviceTime" data-options="required:true" value="${pro.serviceTime}"/>
	    		<span class="tip-info">(例如：08:30 ~ 22:30)</span>
	    	</td>
	    </tr>
    	<tr>
    		<td>联系人</td>
    		<td colspan="3"><input class="easyui-textbox" name="linkman" data-options="required:true,value:'${pro.linkman}',validType:'length[0,50]'"></td>
    	</tr>
    	<tr>
    		<td>联系电话</td>
    		<td colspan="3"><input class="easyui-numberbox" name="telephone" value="${pro.telephone}" data-options="required:true,validType:'precision:0'"></td>
    	</tr>
    	<tr>
    	   <td><label for="businessMode">是否派单模式</label></td>
    	   <td colspan="3"><input id="businessMode" name="businessMode" type="checkbox" <c:if test="${pro.businessMode}">checked</c:if> /></td>
    	</tr>
    	<tr>
    		<td>店铺描述</td>
    		<td colspan="3">
    			<textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="description" data-options="required:true,validType:'length[0,1000]'">${pro.description}</textarea>
    		</td>
    	</tr>
    </table>
</form>

<script src="${libPath}cityselect.js"></script>
