<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="funcGridToolbar" style="padding:5px;">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
            onclick="showSaveNodeForm(false)">添加</a>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
            onclick="showSaveNodeForm(true)">修改</a>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete'"
            onclick="deleteFunc()">删除</a>
</div>
<table id="funcGrid" class="easyui-treegrid"
        data-options="url:'${urlPath }func/listFunc.do',
        			  idField:'id',
        			  treeField:'funcName',
        			  toolbar:'#funcGridToolbar',
        			  fit:true,lines:true,
        			  onLoadSuccess: function() {
                        $(this).treegrid('collapseAll');
                      }">
    <thead>
        <tr>
            <th data-options="field:'funcName',width:300,halign:'center'">功能名称</th>
            <th data-options="field:'icon',width:70,halign:'center',formatter:formatIcon">图标</th>
            <th data-options="field:'isMenu',width:60,halign:'center',align:'center',formatter:formatRow">是否菜单</th>
            <th data-options="field:'isShow',width:60,halign:'center',align:'center',formatter:formatRow">是否显示</th>
            <th data-options="field:'url',width:400,halign:'center'">URL</th>
            <th data-options="field:'code',width:200,align:'left'">Code</th>        
            <th data-options="field:'id',width:60,align:'center'">ID</th>
            <th data-options="field:'orderno',width:50,align:'center'">序号</th>        
        </tr>
    </thead>
</table>
<script>

	function deleteFunc() {
		var funcGrid = $("#funcGrid");
		var rows = funcGrid.treegrid("getSelections");
		if (rows.length > 1) {
			alert('错误提示','不能同时编辑多行！','warning');
			return false;
		} else if (rows.length == 0) {
			alert('错误提示','必须选中一行才能进行编辑！','warning');
			return false;
		}
		showConfirm("确认操作", "确认删除功能权限！", function(){
			post("${urlPath }func/deleteFunc.do", {funcId:rows[0].id}, function(data){
				funcGrid.treegrid("load");
			   	showMessage('系统提示', data.message);
			});
		});
	}

	function formatRow(value,row,index) {
		if (value) {
			return '是';
		}
		return '否';
	}

	function formatIcon(value,row,index) {
		return '<div class='+value+' style=\'height:16px;text-align:left;padding-left:20px\'></div>';
	}

	function showSaveNodeForm(edit) {
		var href = "func/showFuncForm.do";
		var funcGrid = $("#funcGrid");
		var rows = funcGrid.treegrid("getSelections");
		if (edit) {
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			href = href + "?id=" + rows[0].id;
		} else if (rows.length > 0) {
			href = href + "?parentId=" + rows[0].id;
		}
		var dlg = openEditDialog({
		    title: "编辑功能",
		    width: 340,
		    height: 350,
		    href: href,
		    onLoad: function() {
                var funcs = [
                    {
                        funcName: '增加',
                        code: 'add',
                        icon: 'icon-add',
                        orderno: 1
                    },
                    {
                        funcName: '修改',
                        code: 'update',
                        icon: 'icon-edit',
                        orderno: 2
                    },
                    {
                        funcName: '删除',
                        code: 'delete',
                        icon: 'icon-delete',
                        orderno: 3
                    }
                ];
                
                $('[textboxname=funcName]').textbox({
                    onChange: function(v) {
                        queryAndAutoComplele({funcName: v});
                    }
                });
                $('[textboxname=code]').textbox({
                    onChange: function(v) {
                        queryAndAutoComplele({code: v});
                    }
                });
                function queryAndAutoComplele(qparams) {
                    var func = funcs.filter(function(func) {
                        var cond = true;
                        if(qparams.code)
                            cond = cond && new RegExp(qparams.code).test(func.code);
                        if(qparams.funcName)
                            cond = cond && new RegExp(qparams.funcName).test(func.funcName);
                        return cond;
                    })[0];
                    if (func) {
                        $('#funcForm').form('load', func);
                    }
                }
		    },
		    onSave:function(){
				$("#funcForm").form("submit", {
				    url:"${urlPath }func/saveFunc.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		funcGrid.treegrid("load");
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