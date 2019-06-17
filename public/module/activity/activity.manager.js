/**
 * 旅游活动管理
 * 
 * @author hulang
 */
var formatters = {
	status : function(v) {
		return {
			0 : '取消',
			1 : '有效'
		}[v];
	},	
	formatOper : function(value,row,index){
		 var code = 'UICommon._fullCellValueDialog('
                + "'" + ('dgActivity') + "'" + ','
                + "'" + index + "'" +  ','
                + "'" + 'datagrid' + "'" + ','
                + "'" +'description'+ "'" + ')';
          
		return '<a  class="easyui-linkbutton" data-options="iconCls:\'color:fff\'"  onclick = "signPeople('+index+')">查看参与人</a>'
		+'&nbsp&nbsp'+'<a class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" style="cursor:pointer"'
        + 'onclick="' + code + '" >'
        + '活动简介' + '</a>';
	} 
};
//操作
function signPeople(index){
	var row=$('#dgActivity').datagrid('getRows')[index];
	if(row){
		parent.openTab({
			url : CONFIG.baseUrl +'view/activity/signInForm.do?activityId='+row.id,
			title : "参与人列表"
		});
	}
};

var activityManager = (function() {
	var that = new Observable();
	var inited = false;
	that.query = function() {
		var params = $('#tbrDgActivity #frmQuery').serializeObject();
		if (!inited) {
			$("#dgActivity").datagrid({
				url : CONFIG.baseUrl + "activity/activityPage.do",
				pagination : true,
				pagePosition : 'bottom',
				pageNumber : 1,
				pageSize : 20,
				pageList : [ 10, 20, 50, 100 ],
				singleSelect : false,
				fit : true,
				queryParams : params,
				onSelect : function(rowIndex, rowData) {
					that.setChanged().notifyObservers({
						event : "onSelect",
						args : {
							rowIndex : rowIndex,
							rowData : rowData
						}
					});
				},
				onLoadSuccess : function(data) {
					that.setChanged().notifyObservers({
						event : "onLoadSuccess",
						args : data
					});
				}
			});
			inited = true;
		} else {
			$("#dgActivity").datagrid("load", params);
		}
	}

	$(function() {
		that.query();
	});

	$('#tbrDgActivity #selectProvider').click(function() {
	    openProviderSelectDialog({
	        displayIndustries: ['activity'],
	        defaultSelectIndustry: 'activity',
	        onDone: function(provider) {
	            provider.providerName = provider.name;
	            $('#tbrDgActivity #frmQuery').form('load', provider);
	            that.query();
	            return true;
	        }
	    });
	});
	
	$("#tbrDgActivity [name=add]").click(function() {
		edit(true);
	});

	$("#tbrDgActivity [name=delete]").click(
			function() {

				var rows = $("#dgActivity").datagrid("getSelections");
				if (rows.length == 0) {
					return false;
				}
				showConfirm("确认操作", "确认删除活动信息", function() {
					$.post(CONFIG.baseUrl
							+ "activity/deleteActivity.do?"
							+ $.arrayPickParam("ids", rows, "id"), function() {
						that.query();
					});
				});
			});

	$("#tbrDgActivity [name=cancel]").click(function() {
		var row = $('#dgActivity').datagrid('getSelected');
		if (!row || row.status == 0)
			return;
		showConfirm("确认操作", "确认取消", function() {
			$.post(CONFIG.baseUrl + 'activity/updateStatus.do', {
				id : row.id,
				status : 0
			}, function(ret) {
				showOpResultMessage(ret);
				$('#dgActivity').datagrid('reload');
			});
		});
	});

	$("#tbrDgActivity [name=review]").click(function() {
		var row = $("#dgActivity").datagrid("getSelected");
		if (!row)
			return;
		parent.openTab({
			url : 'activity/reviewForm.do?activityId='+row.id,
			title : "图文回顾"
		});
	});

	function edit(isAdd) {
		var dlg = openEditDialog({
			title : "编辑活动",
			width : 550,
			height : 560,
			href : "activity/frmActivity.do?providerId=" + providerId,
			onLoad: function() {
                if (isAdd && !providerId) {
                    $('#frmActivity #selectProvider').click(function() {
                        openProviderSelectDialog({
                            displayIndustries: ['activity'],
                            defaultSelectIndustry: 'activity',
                            onDone: function(provider) {
                                $('#frmActivity [name=providerId]').val(provider.providerId);
                                $('#frmActivity #providerName').textbox('setValue', provider.name);
                                return true;
                            }
                        });
                    });
                }

		        $('#communityLimit').change(function() {
                    if ($(this).prop('checked')) {
                        $('[comboname=orgId]').combobox({required: true}).combobox('enable');
                    } else {
                        $('[comboname=orgId]').combobox({required: false}).combobox('setValue', -1).combobox('disable');
                    }
                });
                
                var inited = false;
                var orgId = +$('[comboname=orgId]').data('value') || -1;
                $('[comboname=orgId]').combobox({
                    required: false,
                    valueField: 'id',
                    textField: 'text',
                    url:CONFIG.baseUrl + '/activity/orgs.do',
                    value: orgId,
                    loadFilter: function(data) {
                        data.push({id: -1, text: ''});
                        return data;
                    },
                    checkbox: true,
                    multiple: false,
                    cascadeCheck: false,
                    onLoadSuccess: function() {
                        if (!inited) {
                            if (orgId != -1) {
                                $('#communityLimit').prop('checked', true);
                            }
                            $('#communityLimit').change();
                            inited = true;
                        }
                    }
                });
			},
			onSave : function() {
				if (!$("#frmActivity").form('validate'))
					return;
				$('#frmActivity [name=description]').val(
						'<p>' + $('#frmActivity [name=description]').val()
								+ '</p>');
				formSubmit("#frmActivity", {
					url : "activity/saveActivity.do",
					success : function(ret) {
						if (ret.success) {
							that.query();
							dlg.dialog('destroy');
						}
						showOpResultMessage(ret);
					}
				});
			}
		});
	}

	return that;
})();
