var TimeSegManager = function() {
    var editIndex = -1;
    
    var timeEditor = {
        type: 'timespinner',
        options: {
            required: true
        }
    };
    
    var formatters = {
        op: function(_, row) {
            return UICommon.buttonHtml({
                title: '删除',
                icon: 'delete',
                clickCode: 'TimeSegManager._deleteTimeSeg(' + row.id + ')'
            });
        },
        productName: function(val) {
            return val ? val : '<span style="display:inline;color:gray;font-style:italic">点击选择产品</span>';
        }
    }
    
    $('#dgTimeSeg').datagrid({
        idField: 'id',
        columns: [[
            {field:'startTime',title:'开始时间',width: 70,align:'left', editor: timeEditor},
            {field:'endTime',title:'结束时间',width: 70,align:'left', editor: timeEditor}, 
            {field:'productName',title:'产品名称',width: '60%',align:'left', formatter: formatters.productName},
            {field:'-',title:'',width: 40,align:'left', formatter: formatters.op},
        ]],
        onClickRow: function(index) {
            if (editIndex != index) {
                if (endEditing()) {
                    $('#dgTimeSeg').datagrid('endEdit', editIndex);
                    $('#dgTimeSeg').datagrid('selectRow', index).datagrid('beginEdit', index);
                    editIndex = index;
                } else {
                    $('#dgTimeSeg').datagrid('selectRow', editIndex);
                }
            }
        },
        onClickCell: function(rowIndex, field, value) {
            if (field != 'productName')
                return;
            if (!endEditing())
                return;
            
            openProviderToProductSelectDialog({
                onSubmit: function(product) {
                    // 更新
                    var row = $('#dgTimeSeg').datagrid('getRows')[rowIndex];
                    var startTimeEditor = $('#dgTimeSeg').datagrid('getEditor', {index: rowIndex, field:'startTime'});
                    row.startTime = $(startTimeEditor.target).timespinner('getValue');
                    var endTimeEditor = $('#dgTimeSeg').datagrid('getEditor', {index: rowIndex, field:'endTime'});
                    row.endTime = $(endTimeEditor.target).timespinner('getValue');
                    row.productName = product.name;
                    row.productId = product.productId;
                    
                    $('#dgTimeSeg').datagrid('endEdit', rowIndex)
                        .datagrid('refreshRow', rowIndex).datagrid('beginEdit', rowIndex);
                }
            });
        }
    });

    $('#addTimeSeg').click(function() {
        if (!endEditing())
            return;
        var rows = $('#dgTimeSeg').datagrid('getRows');

        if (rows.length > 0) {
            // 排序已有行
            sortAndReload(rows);
        }

        var index = rows.length;
        // 往前排时间,间隔1小时
        var startTime = moment(index > 0 ? rows[index - 1].endTime : '07:00', 'HH:mm').add(1, 'hour');
        var endTime = moment(startTime).add(1, 'hour');
        $('#dgTimeSeg').datagrid('insertRow', {
            index: index,
            row: {
                startTime: startTime.format('HH:mm'),
                endTime: endTime.format('HH:mm'),
                id: new Date().getTime(),
                productId: null
            }
        })
        editIndex = index;

        // 编辑新行
        $('#dgTimeSeg').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
    });
    
    TimeSegManager._deleteTimeSeg = function(id) {
        $('#dgTimeSeg').datagrid('deleteRow', $('#dgTimeSeg').datagrid('getRowIndex', id));
        editIndex = -1;
    }
    
    function endEditing() {
        if (editIndex == -1) return true;

        // 检查
        if (!$('#dgTimeSeg').datagrid('validateRow', editIndex)) {
            $.messager.alert("提示", '第' + (editIndex + 1) +'行: 未编辑时间', "warning");
            return false;
        }
        
        var startTimeEditor = $('#dgTimeSeg').datagrid('getEditor', {index: editIndex, field:'startTime'});
        var startTime = $(startTimeEditor.target).timespinner('getValue');
        var endTimeEditor = $('#dgTimeSeg').datagrid('getEditor', {index: editIndex, field:'endTime'});
        var endTime = $(endTimeEditor.target).timespinner('getValue');
        
        // 检查时间
        if (!moment(startTime, 'HH:mm').isBefore(moment(endTime, 'HH:mm'))) {
            $.messager.alert("提示", '第' + (editIndex + 1) +'行: 开始时间迟或等于结束时间', "error");
            return false;
        }
        
        // 更新时间
        var row = $('#dgTimeSeg').datagrid('getRows')[editIndex];
        row.startTime = startTime;
        row.endTime = endTime;
        $('#dgTimeSeg').datagrid('endEdit', editIndex);
        editIndex = -1;
        return true;
    }
    
    function sortAndReload(rows) {
        rows.sort(function(row1, row2) {
            return moment(row1.startTime, 'HH:mm').isBefore(moment(row2.startTime, 'HH:mm')) ? -1 : 1;
        })
        $('#dgTimeSeg').datagrid('loadData', rows);
    }
    
    return {
        endEditing: endEditing,
        sortAndReload: sortAndReload,
        clear: function() {
            $('#dgTimeSeg').datagrid('clear');
            editIndex = -1;
        },
        loadData: function(data) {
            $('#dgTimeSeg').datagrid('loadData', data);
            editIndex = -1;
        }
    };
    
}

$(function(){
   $('#tbrServicePlanDetail #add').click(function(){
       edit(false);
   });
   $('#tbrServicePlanDetail #update').click(function(){
       edit(true);
   });
   $('#tbrServicePlanDetail #delete').click(function(){
       var row = $('#dgServicePlanDetail').datagrid('getSelected');
       if(!row) return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'servicePlan/template/detail/delete.do?tid=' + row.tid + '&planDate=' + row.planDate, function(ret){
               showOpResultMessage(ret);
               $('#dgServicePlanDetail').datagrid('load');
           });
       });
   });
   $('#tbrServicePlanDetail #expandAll').click(function(){
       var expanded = $(this).data('expanded');
       for (var i = 0, t = $('#dgServicePlanDetail').datagrid('getData').total; i < t; i++) {
           $('#dgServicePlanDetail').datagrid(expanded ? 'collapseRow' : 'expandRow', i);
       }
       $(this).data('expanded', !expanded);
   });
   
   var selectedTemplate = null; //当前选择的模板
   templateManager.signals.selected.add(function(template){
       selectedTemplate = template;
       query({tid: template.tid});
       $('#tbrServicePlanDetail #expandAll').data('expanded', false);
   });
   templateManager.signals.loaded.add(function(){
       selectedTemplate = null;
       $('#dgServicePlanDetail').datagrid('clear');
   });
   
   function edit(update) {
       if (selectedTemplate && selectedTemplate.state != 0) {
           alertInfo('模板已启用, 不能修改');
           return;
       }
       
       var row;
       var url = 'servicePlan/template/detail/form.do';
       if (update) {
           row = $('#dgServicePlanDetail').datagrid('getSelected')
           if (row) {
               url += '?tid=' + row.tid;
           }
       }
       var timeSegManager;
       var dlg = openEditDialog({
           title: '编辑计划细节',
           width: 600,
           height: 340,
           href: url,
           modal: false,//注意非模态
           onLoad: function() {
               timeSegManager = new TimeSegManager();
               
               if (selectedTemplate) {
                   setTemplate();
               }
               
               templateManager.signals.selected.add(function(template){
                   setTemplate(template);
                   queryTimeSges($('#planDate').datebox('getValue'));

               });
               templateManager.signals.loaded.add(function(){
                   setTemplate(null);
               });
               
               function setTemplate(newValue) {
                   if (typeof newValue != 'undefined')
                       selectedTemplate = newValue;
                   if (selectedTemplate) {
                       $('#templateTitle').textbox('setValue', selectedTemplate.title);
                       $('[name=tid]').val(selectedTemplate.tid);
                   } else {
                       $('#templateTitle').textbox('setValue', '');
                       $('[name=tid]').val('');
                   }
               }
               
               $('#planDate').datebox({
                   onChange: function(date) {
                       queryTimeSges(date);
                   }
               });
               if (update && row) {
                   $('#planDate').datebox('setValue', row.planDate);
               }
               
               function queryTimeSges(date) {
                   if (!selectedTemplate)
                       return;
                   $.get(CONFIG.baseUrl + 'servicePlan/template/detail/getTimeSegs.do',
                       {tid: selectedTemplate.tid, planDate: moment(date).format('YYYY-MM-DD')},
                       function(data) {
                           if (data.length) { //如已存在记录,才进行加载
                               timeSegManager.loadData(data);
                               $('#planDateTip').text('');
                           } else {
                               $('#planDateTip').text('新日期');
                           }
                       });
               }
           },
           onSave: function() {
               // 验证是否指定了模板
               if (!selectedTemplate) {
                   alertInfo('未选择模板');
                   return;
               }
               
               var planDate = moment($('#planDate').datebox('getValue'));
               if (!((planDate.isSame(selectedTemplate.startDate) || planDate.isAfter(selectedTemplate.startDate))
                       && planDate.isBefore(selectedTemplate.endDate))) {
                   $.messager.alert("提示", '设置不一致: 不在计划日期范围内', "error");
                   return;
               }
               
               var timeSegs = $('#dgTimeSeg').datagrid('getRows');
               
               if (!timeSegs.length) {
                   return;
               }
               
               
               if (!timeSegManager.endEditing())
                   return;
               
               timeSegManager.sortAndReload(timeSegs);
               
               // 检查时间重叠
               for (var index = 0; index < timeSegs.length - 1; index++) {
                   if (moment(timeSegs[index].endTime, 'HH:mm').isAfter(moment(timeSegs[index + 1].startTime, 'HH:mm'))) {
                       $.messager.alert("提示", '第' + (index + 1) +'行: 与' + (index + 2) +'行时间段重叠', "error");
                       return;
                   }
               }
               
               // 检查产品选择
               for (var index in timeSegs) {
                   if (!timeSegs[index].productId) {
                       $.messager.alert("提示", '第' + (+index + 1) +'行: 未选择产品', "warning");
                       return;
                   }
               }
               
               $('[name=timeSegSv]').val(timeSegs.map(function(ts){
                   return ts.startTime + ',' + ts.endTime + ',' + ts.productId;
               }).join('|'));
               
               formSubmit({
                   url: 'servicePlan/template/detail/save.do',
                   success: function(ret) {
                       //重置表单,但不关闭窗口,以方便继续添加
                       $('#planDate').datebox('reset');
                       $('#planDateTip').text('');
                       timeSegManager.clear();
                       
                       if (ret.success) {
                           $('#dgServicePlanDetail').datagrid('load');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   }
   
   var inited = false;
   function query(queryParams) {       
       if (!inited) {
           $('#dgServicePlanDetail').datagrid({
               url: CONFIG.baseUrl + 'servicePlan/template/detail/page.do',
               queryParams: queryParams,
               idField: 'tdId',
               loadFilter: function(data) {
                   data.rows.forEach(function(row) {
                       row.timeSegs.sort(function(ts1, ts2) {
                           return moment(ts1.startTime, 'HH:mm').isBefore(moment(ts2.startTime, 'HH:mm')) ? -1 : 1;
                       });
                   });
                   return data;
               },
               pageList: [10, 20, 50],
               fit: true,
               fitColumns: true,
               rownumbers: true,
               view: detailview,
               detailFormatter:function(index,row){
                   return '<div style="padding:2px;"><table class="ddv"></table></div>';
               },
               onExpandRow: function(index, row){
                   if (!$(this).datagrid('getRowDetail',index).data('loaded')) {
                       var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
                       ddv.datagrid({
                           data: row.timeSegs,
                           rownumbers: true,
                           width: '100%',
                           height:'auto',
                           pagination: false,
                           fit:false,
                           columns:[[
                               {field:'startTime',title:'开始时间',align:'center', width: 70},
                               {field:'endTime',title:'结束时间',align:'center', width: 70},
                               {field:'productName',title:'产品名称',width: 250},
                               {field:'providerName',title:'店铺名称',width: 250}
                           ]],
                           onResize:function(){
                               $('#dgServicePlanDetail').datagrid('fixDetailRowHeight',index);
                           },
                           onLoadSuccess:function(){
                               setTimeout(function(){
                                   $('#dgServicePlanDetail').datagrid('fixDetailRowHeight',index);
                               },0);
                           }
                       });
                       $(this).datagrid('getRowDetail',index).data('loaded', true);
                   }
                   
                   $('#dgServicePlanDetail').datagrid('fixDetailRowHeight',index);
               },
               onLoadSuccess: function() {
                   //不选择以免给干扰信息
                   $('#dgServicePlanDetail').datagrid('unselectAll');
               }
           });
           inited = true;
       } else {
           $('#dgServicePlanDetail').datagrid("load", queryParams);
       }
   }
});