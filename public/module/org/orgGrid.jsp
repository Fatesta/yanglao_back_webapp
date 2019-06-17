<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body id="layout" class="easyui-layout">
	<div data-options="title:'组织结构',region:'west',split:true,collapsible:false,minWidth:300" style="width:300px;display:none;">
		<div id="orgGridToolbar" style="padding:5px;">
		    <table class="form">
		        <tr>
		            <td>
				    <c:if test="${not empty session_role_leaf_fn_map['101']}">
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
					            onclick="showSaveNodeForm(false)">添加</a>
				    </c:if>
					<c:if test="${not empty session_role_leaf_fn_map['102']}">
					    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
					            onclick="showSaveNodeForm(true)">修改</a>
				    </c:if>
					<c:if test="${not empty session_role_leaf_fn_map['103']}">
					    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete'"
					            onclick="deleteOrg()">删除</a>
				    </c:if>
				    </td>
				</tr>
				<tr>
				    <td>
	                <c:if test="${not empty session_role_leaf_fn_map['104']}">
	                    <a href="#" id="btnManageDevice" class="easyui-linkbutton" data-options="iconCls:'icon-device-allocate'"
	                            onclick="manageDevice()">管理设备</a>
	                </c:if>
	                <c:if test="${not empty session_role_leaf_fn_map['174']}">
	                    <a href="#" id="manageOrgCamera" class="easyui-linkbutton" data-options="iconCls:'icon-camera'" onclick="manageOrgCamera()">管理摄像头</a>
	                </c:if>
	                </td>
				</tr>
			</table>
		</div>
		<table id="orgGrid" class="easyui-treegrid"  toolbar="#orgGridToolbar">
		    <thead>
		        <tr>
		            <th data-options="field:'name',width:'98%',halign:'center'">组织名称</th>
		        </tr>
		    </thead>
		</table>
	    <div id="orgDlg"></div>
	</div>
	<div data-options="title:'社区信息',region:'east',split:true,collapsible:false" style="width:84%;display:none">
	   <iframe id="module-iframe-community-info-right" src="${urlPath}view/community/info/form.do?mode=nopadding" style="width:100%;height:100%;">
	   </iframe>
	</div>
<script>
$(function() {
    function adjustSizes() {
		var panel = $('#layout').layout('panel', 'east');
		var width = $(document).width() - 300;
		panel.width(width);
		panel.parent().width(width);
		panel.parent().offset({left:300});
	}
    adjustSizes();
    
    getModuleContext('community-info-right', window).onload = function() {
        this.CommunityInfo.setOrgIdRequiredMode();
    };

    reloadOrgTree();
});
var lastSelectedOrgNode;
function reloadOrgTree(isFromDelete) {
    if (isFromDelete)
        lastSelectedOrgNode = {id:lastSelectedOrgNode.parentId};
    $.get('${urlPath }org/listOrg.do', function(data) {
        $('#orgGrid').treegrid({
            data: data,
            idField:'id',
            treeField:'name',
            fit:true,
            onSelect: function(rowData) {
                if (rowData.isCommunity) {
                    $("#btnManageDevice, #manageOrgCamera").linkbutton('enable');
                    var org = $('#orgGrid').datagrid('getSelected');
                    getModuleContext('community-info-right', window).CommunityInfo.loadByOrgId(org.id);
                } else {
                    $("#btnManageDevice, #manageOrgCamera").linkbutton('disable');
                    getModuleContext('community-info-right', window).CommunityInfo.clear();
                }
                lastSelectedOrgNode = rowData;
            },
            loadFilter: function(orgs) {
                return (function f(nodes, level){
                    nodes.forEach(function(node) {
                        node.iconCls = node.isCommunity ? 'icon-community' : 'icon-org';
                        if (level > 0 && node.children.length) {
                            node.state = 'closed';
                        }
                        f(node.children, level + 1);
                    });
                    return nodes;
                })(orgs, 0);
            },
            onLoadSuccess: function() {
                if (!lastSelectedOrgNode) return;
                $(this).treegrid('expandTo', lastSelectedOrgNode.id);
                $(this).treegrid('expand', lastSelectedOrgNode.id);
            }
        });
    });
}

	function searchUnmanageOrgDevice() {
		var d={};
		$("#searchUnmanageOrgDeviceForm").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#unmanageOrgDeviceGrid").datagrid("load", d);
	}
	
	function addOrgDevice() {
		var deviceGrid = $("#unmanageOrgDeviceGrid");
		var rows = deviceGrid.datagrid("getSelections");
		var deviceCodes = getObjectsPropertyArray(rows, "deviceCode");
		if (rows.length > 0) {
			post("${urlPath }org/addOrgDevice.do", {orgId:$("#myOrgId").val(), deviceCodes: deviceCodes}, function(data){
				if (data.success) {
				   	showMessage('系统提示', data.message);
				   	$("#orgDeviceTab").tabs("select", 0);
				   	$("#orgDeviceGrid").datagrid("reload");
				} else {
				    showDeviceAddFailedResult(data);
				}
			});
		}
	}
	
	function addDevice() {
		post("${urlPath }org/addOrgDevice.do", {orgId:$("#myOrgId2").val(), deviceCodes: $("#myDeviceCode").val()}, function(data){
			if (data.success) {
			   	showMessage('系统提示', data.message);
			   	$("#orgDeviceGrid").datagrid("reload");
			   	$("#myDeviceCode").numberbox("clear");
			} else {
			    showDeviceAddFailedResult(data);
			}
		});
	}
	
	function showDeviceAddFailedResult(ret) {
	    var msg = ret.message;
	    if(ret.code == 1) {
	        msg = "下列设备操作失败! 原因是已被分配：\n"
	        	+ _.pluck(ret.data.rows, "deviceCode").join("、");
	    }
		showAlert("错误提示", msg);
	}

	function importDevice() {
		var valid = $("#uploadDeviceForm").form("validate");
		if (valid) {
			$.messager.progress();
			submitForm("uploadDeviceForm", "${urlPath}org/manageDevice.do", function(data){
				data = str2Json(data);
				if (data.success) {
					showMessage("操作提示", "操作成功");
				} else {
					showAlert("错误提示", data.message, "warning");
				}
				$.messager.progress('close');
				$("[name=file]").filebox("clear");
				$("#orgDeviceGrid").datagrid("load");
			});
		}
	}

	function downloadTemplate() {
		location.href = CONFIG.modulePath + "org/org_device_template.xls";
	}


	
	function manageDevice() {
		var orgGrid = $("#orgGrid");
		var rows = orgGrid.treegrid("getSelections");
		if (rows.length > 1) {
			showAlert('错误提示','不能同时编辑多行！','warning');
			return false;
		} else if (rows.length == 0) {
			showAlert('错误提示','必须选中一行才能进行编辑！','warning');
			return false;
		}
		
		var href = "${urlPath }org/showOrgDeviceForm.do?orgId=" + rows[0].id;
		var dlg = $("#orgDlg").dialog({
		    title: "分配呼贝",
		    width: 650,
		    height: 480,
		    closed: false,
		    cache: false,
		    href: href,
		    buttons:[{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog("close");	
				}
			}],
		    modal: true
		});
	}
	
	function manageOrgCamera() {
	    var row = $("#orgGrid").treegrid("getSelected");
	    if(!row) return;
	    openTab("mainTab", "${urlPath }view/org/camera/index.do?orgId=" + row.id,
	        row.name + " - 管理摄像头");
	}
	
	function deleteOrg() {
		var orgGrid = $("#orgGrid");
		var row = orgGrid.treegrid("getSelected");
		if (!row) {
		    return;
        }
		
		var level = orgGrid.treegrid("getLevel", row.id);
		if (level == 1) {
			showAlert('错误提示','不能删除顶级！','warning');
			return false;
		}
		
		var children = orgGrid.treegrid("getChildren", row.id);
		if (children.length > 0) {
			showAlert('错误提示','不能删除有子组织的组织！','warning');
			return false;
		}
		showConfirm("确认操作", "确认删除组织和组织下的所有设备？", function(){
			post("${urlPath }org/deleteOrg.do", {orgId:row.id}, function(data){
				orgGrid.treegrid("load");
				if (data.success) {
                    reloadOrgTree(true);
				   	showMessage('系统提示', data.message);
				} else {
					showAlert("错误提示", data.message);
				}
			});
		});
	}
	
	function formatOp(value,row,index) {
		return '<a href="#" class="easyui-linkbutton" onclick="deleteDevice(\'' + row.orgId + '\',\'' + row.deviceCode + '\')"><div class=\'icon-delete\'>&nbsp;</div></a>';
	}
	
	function deleteDevice(orgId, deviceCode) {
		showConfirm("确认操作", "确认删除已管理的设备？", function(){
			post("${urlPath }org/deleteOrgDevice.do", {orgId:orgId,deviceCode:deviceCode}, function(data){
				$("#orgDeviceGrid").datagrid("load");
				if (data.success) {
				   	showMessage('系统提示', data.message);
				} else {
					showAlert("错误提示", data.message);
				}
			});
		});
	}

	function showSaveNodeForm(edit) {
		var href = "org/showOrgForm.do";
		var orgGrid = $("#orgGrid");
		var row = orgGrid.treegrid("getSelected");
        if (!row) return;
        var title = edit ? "编辑" : "增加";
        var level = row.level;

		if (edit) {
		    if (row.parentId == 0) {
		        alertInfo('无编辑权限');
		        return;
			}
			href = href + "?id=" + row.id;
		    level--;
		} else {
		    if (row.isCommunity) {
		        alertInfo('不能再增加下级节点');
		        return;
			}
			href += "?parentId=" + row.id + '&openState=true&level=' + level;
			if (level == 5) {
			    href += '&isCommunity=true';
			}
		}
        title += ['省', '市', '区', '街道', '社区'][level - 1];
		var dlg = openEditDialog({
		    title: title,
		    width: 380,
		    height: 200,
		    href: href,
		    onSave: function(){
				formSubmit("#orgForm", {
				    url:"org/saveOrg.do",
				    success:function(data){
				    	if (data.success) {
				    		dlg.dialog("destroy");
                            reloadOrgTree();
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		});
	}

</script>
</body>
</html>