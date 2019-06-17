<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',split:true" style="height:50%;">
		<div id="tbrConsumeCard">
		    <form id="frmQuery">
		        <table class="form">
		            <tr>
                        <td><a id="buy" class="easyui-linkbutton" data-options="iconCls:'icon-add'">购买服务卡</a></td>
		            </tr>
		        </table>
		    </form>
		</div>
		<table id="dgConsumeCard" class="easyui-datagrid" toolbar="#tbrConsumeCard">
		    <thead>
		        <tr>
		            <th data-options="field:'cardName', width:'12%', halign:'center', align:'left'">卡名称</th>
		            <th data-options="field:'cardNumber',width:'100px',halign:'center'">卡号</th>
		            <th data-options="field:'coverImage', width:'5%', halign:'center', align:'center', formatter: UICommon.datagrid.formatter.generators.image({height: 30})">封面图片</th>
		            <th data-options="field:'contactNumber', width:'8%', halign:'center', align:'left'">联系电话</th>
		            <th data-options="field:'price', width:'6%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.money">价格</th>
		            <th data-options="field:'startTime', width:'10%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">有效开始时间</th>
                    <th data-options="field:'endTime', width:'10%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">有效结束时间</th>
		        </tr>
		    </thead>
		</table>
	</div>
	<div data-options="region:'south',title:'',split:true" style="height:50%;">
        <div class="easyui-layout" data-options="fit:true">
		    <div data-options="region:'center',title:'',split:true" style="width:40%">
		        <div id="tabs" class="easyui-tabs" data-options="fit:true">
		            <div title="服务列表" data-options="selected:true,closable:false">
						<table id="dgService" class="easyui-datagrid" data-options="pagination:false">
						    <thead>
						        <tr>
						            <th data-options="field:'serviceName', width:'26%', halign: 'center', align:'left'">服务名称</th>
						            <th data-options="field:'serverFlag', width:'12%', halign: 'center', align:'left', formatter: formatters.serverFlag">服务类别</th>
                                    <th data-options="field:'times', width:'8%', halign: 'center', align:'center'">次数</th>
                                    <th data-options="field:'restTimes', width:'12%', halign: 'center', align:'center'">剩余次数</th>
						            <th data-options="field:'serviceDesc', width:'38%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'serviceDesc'})">服务介绍</th>
						            
						            </tr>
						    </thead>
						</table>
		            </div>
		        </div>
	        </div>
	        
	        <div data-options="region:'east',title:'',split:true" style="width:60%">
                <div id="serviceRelatedTabs" class="easyui-tabs" data-options="fit:true">
                    <div title="服务产品列表 " data-options="selected:true,closable:false">
						<table id="dgServiceProduct" class="easyui-datagrid" data-options="pagination:false">
						    <thead>
						        <tr>
			                        <th data-options="field:'imageFile',width:'80px',halign:'center', formatter:formatters.imageFile">商品图片</th>
			                        <th data-options="field:'productName',width:'30%',halign:'center'">名称</th>
			                        <th data-options="field:'simpleDescription',width:'50%',halign:'center', formatter:formatters.description">描述</th>
                                </tr>
						    </thead>
						</table>
                    </div>
                    <div title="支持服务的门店列表">
                        <table id="dgServiceProvider" class="easyui-datagrid" data-options="pagination:false">
                            <thead>
                                <tr>
                                     <th data-options="field:'name',width:'30%',halign:'center'">店铺名称</th>
                                     <th data-options="field:'industryId',width:'14%',halign:'center', formatter: formatters.industryId">所属行业</th>
                                     <th data-options="field:'address',width:'40%',halign:'center'">店铺地址</th>
                                    </tr>
                            </thead>
                        </table>
                    </div>
                    
                </div>
	        </div>
        </div>
	</div>
</div>
