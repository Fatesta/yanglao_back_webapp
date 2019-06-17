/* 员工管理
 * @author: hulang
 **/
function EmployeeManager(datagridId, frmSearchId) {
	var self = this;
	var datagrid = $("#dgEmployee");
	var frmSearch = $("#frmSearchEmployee");


  this.query = function() {
    if(!($("#frmSearchEmployee [name=bossId]").val() ||
      $("#frmSearchEmployee [name=providerId]").val()))
      return;

    var params = frmSearch.serializeObject();
    if(datagrid.datagrid("options").url == null) {
      datagrid.datagrid({
        url: CONFIG.baseUrl + 'shop/employee/employeePage.do',
        cache: false,
        multiSort:true,
        fit:true,
        queryParams: params
});
}
else {
  datagrid.datagrid("load", params);
}
};

if (window.pro) {
  pro.signals.selected.add(function (data) {
    frmSearch.find("[name=providerId]").val(data.args.rowData.id);
    self.query();
  });
  pro.signals.loaded.add(function () {
    frmSearch.find("[name=providerId]").val('');
    datagrid.datagrid("clear");
  });
} else {
  self.query();
}

$("#tbrDgEmployee [name=query]").click(function(){
  self.query();
});

$("#tbrDgEmployee [name=addEmployee]").click(function(){
  if(!frmSearch.find("[name=providerId]").val()) {
    showMessage("提示","请先选择一个店铺");
    return;
  }

  var dlg = openEditDialog({
    title: "增加员工",
    width: 340,
    height: 280,
    href: "shop/employee/frmEmployee.do",
    onSave: function(dlg) {
      var params = $("#frmSearchEmployee").serializeObject();
      $("#frmEmployee [name=orgId]").val(params.orgId);
      $("#frmEmployee [name=providerId]").val(params.providerId);

      $("#frmEmployee").form("submit", {
        url:CONFIG.baseUrl + "shop/pro/addEmployee.do",
        success:function(data){
          var data = str2Json(data);
          if (data.success) {
            dlg.dialog('destroy');
            datagrid.datagrid("load");
            showMessage('提示', data.message);
          } else {
            showMessage('提示', data.code == 1 ? data.message : "输入的邮箱已存在");
          }
        }
      });
    }
  });
});

$("#tbrDgEmployee [name=addEmployeeRef]").click(function(){
  if(!frmSearch.find("[name=providerId]").val()) {
    showMessage("提示","请先选择一个店铺");
    return;
  }

  var dlg = openEditDialog({
    width: 300,
    height: 120,
    title: '增加已存在员工',
    href: 'view/shop/employee/frmEmployeeRef.do',
    onLoad: function() {
      dlg.find('[name=providerId]').val(frmSearch.find("[name=providerId]").val());
    },
    onSave: function() {
      formSubmit(dlg.find('#frmEmployeeRef'), {
        url: "shop/pro/addEmployeeRef.do",
        success: function(ret){
          if(ret.success) {
            showMessage("操作提示", ret.message);
            datagrid.datagrid('reload');
            dlg.dialog('destroy');
          } else {
            var msg = {3: '不存在该工号', 2: "该店铺已经存在所选员工", 1: "操作失败"}[ret.code];
            showMessage("操作提示", msg || "操作失败");
          }
        }
      });
    }
  });
});

$("#tbrDgEmployee [name=setStatus]").click(function(){
  var emp = datagrid.datagrid("getSelected");
  if(!emp) return;
  showConfirm("提示","您真的要" + (emp.status ? "禁用" : "启用") + "该用户吗？", function(){
    $.post(CONFIG.baseUrl + "shop/employee/updateStatus.do", {adminId: emp.adminId, status: +!emp.status}, function(ret){
      showMessage("操作提示", ret.message);
      datagrid.datagrid('reload');
    });
  });
});

$("#tbrDgEmployee [name=update]").click(function(){
  var emp = datagrid.datagrid("getSelected");
  if(!emp) return;

  openEditDialog({
    title: "编辑员工",
    width: 340,
    height: 280,
    href: "shop/employee/frmEmployee.do?id=" + emp.id,
    onSave: function(dlg) {
      var params = $("#frmSearchEmployee").serializeObject();
      $("#frmEmployee [name=orgId]").val(params.orgId);
      $("#frmEmployee [name=providerId]").val(params.providerId);

      $("#frmEmployee").form("submit", {
        url:CONFIG.baseUrl + "shop/employee/saveEmployee.do",
        success:function(data){
          var data = str2Json(data);
          if (data.success) {
            dlg.dialog('destroy');
            datagrid.datagrid("load");
            showMessage('提示', data.message);
          } else {
            showMessage('提示', data.code == 1 ? data.message : "输入的邮箱已存在");
          }
        }
      });
    }
  });
});

$("#tbrDgEmployee [name=delete]").click(function(){
  var emp = datagrid.datagrid("getSelected");
  if(!emp) return;
  showConfirm("提示","您真的要删除吗？", function(){
    $.post(CONFIG.baseUrl + "shop/pro/deleteEmployee.do",
      {adminId: emp.adminId, providerId: emp.providerId}, function(ret){
        showMessage("操作提示", ret.message);
        datagrid.datagrid('reload');
      });
  });
});
}

EmployeeManager.formatters = {};
EmployeeManager.formatters.status = function(value,rowData,rowIndex) {
  return value == 1 ?
    "<div class='icon-enable'>&nbsp</div>" : "<div class='icon-disable'>&nbsp</div>";
};
EmployeeManager.formatters.providerNames = function(value,rowData,rowIndex) {
  return '<span title="' + value + '" >' + value + '</span>';
};
EmployeeManager.formatters.roleId = function(value,rowData,rowIndex) {
  return {3:"店员", 4:"店铺管理者"}[value];
};
$(function() {
  var employee = new EmployeeManager();
});
