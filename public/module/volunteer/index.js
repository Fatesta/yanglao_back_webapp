var volunteer = {};
(function(){
    volunteer.formatters = {
        profession: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('volunteer.profession')),
        address: UICommon.datagrid.formatter.generators.omit({dgId: 'dgVolunteer', field: 'address',min: 14}),
        planDateAndServiceTime: function(_, row) {
            return row.planDate.substring(0, 10) + ' ' + row.serviceTime;
        },
        serviceDuration: function(v) {
            return v == 0 ? '1次' : v + '小时';
        },
        customer: function(_, row) {
            return row.linkName + ' (' + row.linkPhone + ')';
        },
        publisher: function(_, row) {
            return row.publisherName + ' (' + row.publisherPhone + ')';
        },
        orderStatus: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('volunteer.orderStatus')),
        op: function(v, row) {
            return row.orderStatus == -1 ? '' : UICommon.buttonHtml({
                text: '查看任务',
                icon: 'order-trace',
                clickCode: 'volunteer.openOrderDetails(\'' + row.serviceId + '\', \'' + row.orderCode + '\')'
            });
        }
    }

    volunteer.openOrderDetails = function(serviceId, orderCode) {
        openTab({
            title: '互助任务详情 - ' + orderCode,
            url: 'volunteer/order/details.do?serviceId=' + serviceId
        });
    }


   $('#tbrVolunteer #orderStatus').comboboxFromDict({
       dict: DictMan.items('volunteer.orderStatus')
   });
    
   $('#tbrVolunteer #selectPublisher').click(function() {
       $('#tbrVolunteer [name=frmQuery] [name=publisher]').val('');
       $('#tbrVolunteer [name=frmQuery] #publisherName').textbox('clear');
       openUserSelectDialog({
            required: false,
            onSelectDone: function(user){
                $('#tbrVolunteer [name=frmQuery] [name=publisher]').val((user && user.userId) ? user.userId : '');
                $('#tbrVolunteer [name=frmQuery] #publisherName').textbox('setValue', (user && user.userId) ? user.aliasName : '');
                return true;
            }
        });
   });
   
   $('#tbrVolunteer #query').click(function(){
       $('#dgVolunteer').datagrid('load', $('#tbrVolunteer [name=frmQuery]').serializeObject()); 
   });
   $('#tbrVolunteer #add').click(function(){
       edit(false);
   });
   $('#tbrVolunteer #update').click(function(){
       edit(true);
   });
   $('#tbrVolunteer #delete').click(function(){
       var row = $('#dgVolunteer').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'volunteer/help/delete.do?serviceId=' + row.serviceId, function(ret){
               showOpResultMessage(ret);
               $('#dgVolunteer').datagrid('load');
           });
       });
   });
   
   $('#tbrVolunteer #review').click(function(){
       var row = $('#dgVolunteer').datagrid('getSelected');
       if (!row) return;
       if (row.orderStatus == 4 || row.orderStatus == 5) {
           alertInfo('不能重复审核');
           return;
       }
       if (row.orderStatus == -1) {
           alertInfo('未接单');
           return;
       }
       
       var dlg = openEditDialog({
           width: 480,
           height: 220,
           href: 'view/volunteer/reviewForm.do?orderno=' + row.orderCode + '&serviceId=' + row.serviceId,
           onSave: function() {
               var newStatus = +dlg.find('[name=status]:checked').val();
               if (isNaN(newStatus)) return;
               if (newStatus == 4) {
                   if (row.orderStatus == 1) {
                       alertInfo('现在任务状态为未完成, 不能选择完成');
                       return;
                   }
                   if (row.orderStatus == 3) {
                       alertInfo('现在任务状态为取消, 不能选择完成');
                       return;
                   }
               }
               
               formSubmit({
                   url: 'volunteer/order/review.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dgVolunteer').datagrid('load');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   });
       
   function edit(update) {
       var url = 'volunteer/help/form.do';
       if (update) {
           var row = $('#dgVolunteer').datagrid('getSelected')
           if(!row) return;
           url += '?serviceId=' + row.serviceId;
       }
       
       var dlg = openEditDialog({
           width: 500,
           height: 440,
           href: url,
           onSave: function() {
               formSubmit({
                   url: 'volunteer/help/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dgVolunteer').datagrid('load');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
})();
