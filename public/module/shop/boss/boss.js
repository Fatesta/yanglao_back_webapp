/* 商户老板管理
 * @author: hulang
 **/
function BossManager() {}
BossManager.prototype = new Observable();

var boss = (function(){
    var self = new BossManager();
    
    self.signals = {
        selected: new Signal(),
        loaded: new Signal()
    };
    
    self.formatters = {
        status: function(value,rowData,rowIndex) {
            return "<div class='icon-{0}'>&nbsp</div>".format(value == 1 ? "enable" : "disable");
    	},
    	balance: function(b, row) {
            return '<span style=\"margin-left: 4px\">' + (row.moneyType == 1 ? '¥&nbsp;' + b : b) + '</span>';
        }
    };
    
    var inited = false;
    self.query = function() {
        var params = $("#frmSearchBoss").serializeObject();
        if(!inited) {
            $("#dgBoss").datagrid({
                url: CONFIG.baseUrl + 'shop/boss/bossPage.do',
                fit:true,
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
        } else {
            $("#dgBoss").datagrid("load", params);
        }
    };
    
    self.add = function() {
    	edit();
    };
    self.updateById = function(id) {
    	var row = $("#dgBoss").datagrid("getSelected");
    	if(!row) return;
    	edit(row.id);
    };
    
    function edit(id) {
        var params = {};
    	if (id) {
    	    params.id = id;
    	}
    	var href = "shop/boss/frmBoss.do?" + $.param(params);
    	var dlg = openEditDialog({
    	    title: "编辑商户老板",
    	    width: 340,
    	    height: 280,
    	    href: href,
    	    onSave: function(){
				$("#frmBoss").form("submit", {
				    url:CONFIG.baseUrl + "shop/boss/saveBoss.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog('destroy');
				    		$("#dgBoss").datagrid("load");
				    		showMessage('提示', data.message);
				    	} else {
				    		showMessage('提示', data.code == 1 ? data.message : "输入的邮箱已存在");
				    	}
				    }
				});
    		}
    	});
    }
    
    $("#tbrDgBoss [name=query]").click(function(){
    	self.query();
    });
    $("#tbrDgBoss [name=add]").click(function(){
    	self.add();
    });
    $("#tbrDgBoss [name=update]").click(function(){
    	self.updateById();
    });

    return self;
})();
