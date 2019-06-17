function resDgOnSelect(index, row) {
    var params = $('#frmQuery').serializeObject();
    params.url = row.url;
    $('#dg').datagrid('load', params);
}

$(function(){
   $('#query').click(function(){
       $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
   });
   $('#add').click(function(){
       var res = $('#dgRes').datagrid('getSelected');
       if (!res) {
           alertInfo('请先选择一个学习课件');
           return;
       }
       var rows = $('#dg').datagrid('getRows');
       if (rows.length) {
           alertInfo('只能添加一个记录');
           return;
       }
       var url = 'mbkf/classesLearningPlan/form.do';
       
       var dlg = openEditDialog({
           title: '编辑',
           width: 500,
           height: 300,
           href: url,
           onLoad: function() {
               // 创建七天checkboxs
               var weekNames = '一二三四五六日'.split('');
               var html = '<tr>';
               for (var i = 0; i < 7; i++) {
                   html += '<td style="width:50px;">';
                   html += '<input id="day' + (i+1) + '" type="checkbox"><label for="day' + (i+1) + '">周' + weekNames[i] + '</label>';
                   html += '</td>';
               }
               html += '</tr>';
               $('#weekDayTable').html(html);
               
               // 为更新设置加载旧设置
               var weekDays = $('[name=weekDay]').val().split(''); // 旧数据
               for (var i = 0; i < 7; i++) {
                   $('#day' + (i+1)).prop('checked', Boolean(weekDays[i]));
               }
               
               // 增加时间点按钮事件
               $('#addWeekTime').linkbutton({onClick: function(){
                   var weekTimeId = $('#weekTimeTable tr').length + 1;
                   var value = new Date().getHours()+ ":" + new Date().getMinutes();
                   // 时间点html
                   var weekTimeTr = "<tr id='weekTime" + weekTimeId + "' >" +
                       "<td>第" + weekTimeId + "次</td>" +
                       "<td><input class=\"easyui-timespinner\" value=\"" + value + "\" style=\"width:80px;\"  data-options=\"showSeconds:false,required:true\"></td>" +
                       "<td><a id=\"deleteWeekTime" + weekTimeId + "\" href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete'\" data-id=" + weekTimeId + "></a></td>" +
                       "</tr>";
                   $('#weekTimeTable').append(weekTimeTr);

                   $.parser.parse($("#weekTime" + weekTimeId));
                   
                   // 删除时间点
                   $('#deleteWeekTime' + weekTimeId).click(function(){
                       $('#weekTime' + $(this).data('id')).remove();
                   })
                   
                   weekTimeId++;
               }});
           },
           onSave: function() {
               $('[name=classesId]').val(PAGE_CONFIG['classesId']);
               $('[name=url]').val(res.url);
               $('[name=fileName]').val(res.filename);
               
               var weekDayValue = '';
               $('#weekDayTable input').each(function(){
                   weekDayValue += +$(this).prop('checked')
               });
               if (+weekDayValue == 0) {
                   alertInfo('请设置天');
                   return;
               }
               $('[name=weekDay]').val(weekDayValue);
               
               var weekTimes = $('#weekTimeTable .easyui-timespinner').map(function(){
                   return $(this).timespinner('getValue');
               }).toArray();
               if (weekTimes.length == 0) {
                   alertInfo('请设置时间点');
                   return;
               }
               // 判时间点重复
               var same = false;
               for (var i = 0; !same && i < weekTimes.length; i++) {
                   for (var j = 0; j < weekTimes.length; j++) {
                       if (i != j && weekTimes[i] == weekTimes[j]) {
                           same = true;
                           break;
                       }
                   }
               }
               if (same) {
                   alertInfo('存在重复时间点');
                   return;
               }
               
               $('[name=weekTime]').val(weekTimes.join(','));
               
               formSubmit({
                   url: 'mbkf/classesLearningPlan/save.do',
                   success: function(ret) {
                       if (ret.success) {
                           dlg.dialog('destroy');
                           $('#dg').datagrid('reload');
                       }
                       showOpResultMessage(ret);
                   }
               });
           }
       });
   });
   $('#delete').click(function(){
       var row = $('#dg').datagrid('getSelected');
       if(!row)
           return;
       openConfirmDeleteDialog(function(){
           $.post(CONFIG.baseUrl + 'mbkf/classesLearningPlan/delete.do', {classesId: PAGE_CONFIG['classesId'], id: row.planId}, function(ret){
               showOpResultMessage(ret);
               $('#dg').datagrid('reload');
           });
       });
    });
});

var formatters = {
    duration: function(secs) {
        var h = Math.floor(secs / 3600);
        var m = Math.floor(secs % 3600 / 60);
        var s = secs % 3600 % 60;
        var text = '';
        if (h > 0) text += h + '时';
        if (m > 0) text += m + '分';
        if (s > 0) text += s + '秒';
        return text;
    },
    weekDay: function(value) {
        var html = "";
        var names = ['sun','mon','tue','wed','tus','fri','sat'];
        for (var i = 0; i < 7; i++) {
            var selected = +value[i] ? 'y' : 'n';
            html += "<div class='icon-date-ic-" + names[i] + "-" + selected + "' style='float:left;width:16px;'>&nbsp;</div>";
        }
        return html;  
    },
    weekTime: function(value) {
        return value.replace(/,/g, '、');
    }
}