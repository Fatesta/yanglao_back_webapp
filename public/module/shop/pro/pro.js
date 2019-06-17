/* 店铺管理
 * @author: hulang
 */
/**
@class ProManager
*/
function ProManager() {}
// 模块命名为pro
var pro = (function () {
    var self = new ProManager();
    
    self.signals = {
        selected: new Signal(),
        loaded: new Signal()
    };
    
    self.columns = [
          {field:'imgUrl',title:"店铺封面",width:'60',halign:'center', formatter:
              function(value) {
                  return value ? '<img src="' + value  + '" width="60px" height="50px"/>' : '<div class="empty-value-box" style="width:60px;height:50px;"></div>';
              }
          },
          {field:'name',title:"店铺名称",width:'180',halign:'center', formatter:UICommon.datagrid.formatter.wraptip},
          {field:'industryText',title:"所属行业",width:'100',align:'center'},
          {field:'fullAddress',title:"店铺地址",width:'160',halign:'center', formatter:UICommon.datagrid.formatter.wraptip},
          {field:'linkman',title:"联系人",width:'80',halign:'center', formatter:UICommon.datagrid.formatter.wraptip},
          {field:'telephone',title:"联系电话",width:'90',halign:'center'},
          {field:'serviceTime',title:"营业时间",width:'110',halign:'center'},
          {field:'createTime',title:"注册日期",width:'130',align:'center'},
          {field:'businessMode',title:"派单模式",width:'60',align:'center',formatter:UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-yesno'))},
          {field:'description',title:"店铺描述",width:'140',halign:'center',formatter: UICommon.datagrid.formatter.generators.omit({
              dgId: "dgPro", field: "description", min: 10
          })},
          {field:'adminUsername',title:"所属商家工号",width:'90',halign:'center'},
     ];

    var inited = false;
    
    self.query = function() {
        var params = $("#frmSearchPro").serializeObject();
        if(!inited) {
            $("#dgPro").datagrid({
                url: CONFIG.baseUrl + 'shop/pro/proPage.do',
                fit:true,
                columns: [self.columns],
                pageSize: 50,
                queryParams: params,
                onSelect: function(rowIndex, rowData){
                    self.signals.selected.dispatch({
                        args: {rowIndex: rowIndex, rowData: rowData}});
                },
                onLoadSuccess: function(data){
                    self.signals.loaded.dispatch({args: data});
                }
            });
            inited = true;
        }
        else {
            $("#dgPro").datagrid("load", params);
        }
    };
    
    self.add = function () {
        edit();
    };
    
    self.updateById = function () {
        var row = $("#dgPro").datagrid("getSelected");
        if(!row) return;
        edit(row.id);
    };
    
    function edit(id) {
        var params = {};
        params.communityManagerId = $("#frmSearchPro [name=communityManagerId]").val();
        params.id = id;
        var href = "shop/pro/frmPro.do?" + $.param(params);
        var dlg = openEditDialog({
            title: "编辑店铺",
            width: 560,
            height: '90%',
            href: href,
            onLoad: function(){
                $('#uploadButton').click(function(){
                    openUploadImageDialog({
                        onSuccess: function(data) {
                            $('#imgPro').attr('src', data.url);
                            $('[name=imgUrl]').val(data.url);
                        }
                    });
                  });
                new CitySelect({
                    prov: "#province",
                    city: "#city",
                    dist: "#area",
                    valueField: "text",
                    textField: "text"
                });
                
                $('#frmPro #selectBoss').click(function() {
                    openBossSelectDialog({
                        onSelect: function(boss) {
                            $('#frmPro [name=bossId]').val(boss.adminId);
                            $('#frmPro #bossName').textbox('setValue', boss.realName);
                        }
                    });
                });
                
                var params = $("#frmSearchPro").serializeObject();
                if (params.bossId) {
                    $('#frmPro [name=bossId]').val(params.bossId);
                    $('#selectBoss').parent().hide();
                }

                var orgId = '' + ($('#cboOrgId').data('value') || -1);
                $('#cboOrgId').combobox({
                    required: false,
                    valueField: 'id',
                    textField: 'text',
                    url:CONFIG.baseUrl + 'shop/pro/orgs.do',
                    value: orgId,
                    loadFilter: function(data) {
                        data.unshift({id: '-1', text: '(不限社区)'});
                        return data;
                    },
                    checkbox: true,
                    multiple: true,
                    onSelect: function(item) {
                        if (item.id != -1) {
                            $(this).combobox('unselect', -1);
                        } else {
                            $(this).combobox('clear');
                            $(this).combobox('setValue', -1);
                        }
                    }
                });
            },
            onSave: function(){
                $("#frmPro [name=orgId]").val($('#cboOrgId').combobox('getValues').join(','));
                $("#frmPro").form("submit", {
                    url:CONFIG.baseUrl + "shop/pro/savePro.do",
                    success:function(data){
                        var data = str2Json(data);
                        if (data.success) {
                            
                            dlg.dialog('destroy');
                            $("#dgPro").datagrid("load");
                            showMessage('系统提示', data.message);
                        } else {
                            showAlert(data.title,data.message,'error');
                        }
                    }
                });
            }
        });
    };
    
	$(function () {
	    $.getScript(CONFIG.modulePath + 'shop/boss/select.js');
        $('#frmSearchPro #selectBoss').click(function() {
            openBossSelectDialog({
                onSelect: function(boss) {
                    $('#frmSearchPro [textboxname=adminUsername]').textbox('setValue', boss.username);
                    pro.query();
                }
            });
        });
    	$("#tbrDgPro [name=query]").click(function () {
        pro.query();
    	});
		$("#tbrDgPro [name=add]").click(function () {
        	pro.add();
    	});
    	$("#tbrDgPro [name=update]").click(function () {
        	pro.updateById();
    	});
	    $('#tbrDgPro [name=manageService]').click(function() {
	        var row = $('#dgPro').datagrid('getSelected');
	        if (!row) return;
	        openTab('mainTab', 'view/shop/proService/index.do?providerId=' + row.providerId, '店铺[' + row.name + '] - 服务管理');
	    });
	});
	
    return self;
})();
