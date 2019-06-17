var couponUserManager = (function(){
   var thiz = {};
   thiz.query = function(params) {
       if(!$('#dgCouponBatchUser').datagrid('options').url) {
           $("#dgCouponBatchUser").datagrid({
               url: CONFIG.baseUrl +'coupon/user/page.do',
               queryParams: params,
               fit:true
           });
       } else {
           $("#dgCouponBatchUser").datagrid("load", params);
       }
   };
   
   thiz.clear = function(params) {
       $("#dgCouponBatchUser").datagrid("clear");
   };
   
   return thiz;
})();


$(function(){
   var CouponBatchState = {EDITING: 0, PENDING : 1, PASS: 2, REJECT: 3};
   
   $('#tbrCoupon #type').comboboxFromDict({
       dict: DictMan.items('coupon.type')
   });
   $('#tbrCoupon [comboname=isPublic]').comboboxFromDict({
       dict: DictMan.items('yesno')
   });
   $('#tbrCoupon #range').combobox({
       onChange: function(opt) {
           $('#selectProviderTr').hide();
           switch(opt) {
           case 0:
               $('[name=providerId]').val('');
               break;
           case 1:
               $('#selectProviderTr').show();
               $('#providerName').textbox('clear');
               $('[name=providerId]').val('');
               openProviderSelectDialog({
                   onDone: function(provider) {
                       $('#providerName').textbox('setValue', provider.name);
                       $('[name=providerId]').val(provider.providerId);
                       return true;
                   }
               });
               break;
           case 2:
               $('[name=providerId]').val(0);
               break;
           }
       }
   });

   $('#tbrCoupon #selectProviderTr').click(function(){
       openProviderSelectDialog({
           onDone: function(provider) {
               $('#providerName').textbox('setValue', provider.name);
               $('[name=providerId]').val(provider.providerId);
               return true;
           }
       });
   });
   
   var inited = false;
   $('#tbrCoupon #query').click(function(){
       if(!inited) {
           $("#dgCoupon").datagrid({
               url: CONFIG.baseUrl +'coupon/batch/page.do',
               fit:true,
               onSelect: function(i,row) {
                   couponUserManager.query({batchId: row.id});
               },
               onLoadSuccess: function() {
                   couponUserManager.clear();
               }
           });
           inited = true;
       } else {
           $("#dgCoupon").datagrid("load", $("#frmQuery").serializeObject());
       }
   });
   $('#tbrCoupon #query').click();
   
   $('#tbrCoupon #add').click(function(){
       openEditDialog({
           title: '增加平台优惠券',
           width: 500,
           height: 400,
           href: 'view/coupon/batch/form.do',
           onLoad: function(dlg) {
               $('#form #type').comboboxFromDict({
                   dict: DictMan.items('coupon.type'),
                   enableEmptyItem: false
               });
           },
           onSave: function(dlg) {
               formSubmit({
                   url: 'coupon/batch/add.do',
                   success: function(ret){
                       if (ret.success) {
                           $('#dgCoupon').datagrid('reload');
                           dlg.dialog('destroy');
                       }
                       showOpResultMessage(ret);
                   }
                });
           }
       });
   });
   
   $("#tbrCoupon #pass").click(function(){
       audit(CouponBatchState.PASS);
   });
   $("#tbrCoupon #reject").click(function(){
       audit(CouponBatchState.REJECT);
   });
   
   function audit(state) {
       var row = $('#dgCoupon').datagrid('getSelected');
       if (!row) return;
       if (row.status != CouponBatchState.PENDING) {
           alertInfo('该状态不能操作');
           return;
       }
       
       var title = {};
       title[CouponBatchState.PASS] = '通过';
       title[CouponBatchState.REJECT] = '驳回';
       title = title[state];
       var dlg = openEditDialog({
           href: 'view/coupon/batch/frmAudit.do?' + $.param({id: row.id, status: state}),
           width: 400,
           height: 210,
           title: title,
           onSave: function() {
               formSubmit('#frmAudit', {
                   url: 'coupon/batch/audit.do',
                   success: function(ret){
                       if (ret.success) {
                           $('#dgCoupon').datagrid('reload');
                           dlg.dialog('destroy');
                       }
                       showOpResultMessage(ret);
                   }
                });
           }
       });
       
   }
});
