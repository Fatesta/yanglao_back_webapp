$(function(){
   $('#userAnswerDetail').click(function(){
       var row = $('#dgAnswerer').datagrid('getSelected');
       if (!row) return;
       openTab('mainTab', 'view/survey/userAnswerDetail.do?_func_id=' + $(this).data('funcid') + '&surveyId=' + PAGE_CONFIG['surveyId'] + '&userId=' + row.userId, '用户[' + row.userName + '] - 问卷答案详情');
   });
   
   $('#highQuery').click(function(){
       var queryDialog = DialogManager.openSimpleDialog({
           width: $(document).width() - 200,
           heightFit: true,
           href: 'view/survey/answererHighQuery.do?surveyId=' + PAGE_CONFIG['surveyId'], 
           title: '高级查询',
           buttons: [
            {
                text:"查询",
                handler:function(){
                    // 输出 <问题1id>=选项1id,选项2id..&<问题2id>=... 如31=138,139,140,141&32=82
                    // 遍历每个问题
                    var qstr = $('#dgQuestionForAnswererFilter').datagrid('getData').rows.map(function(q) {
                        var checkeds = queryDialog.find('[name=q_' + q.id + ']:checked');
                        return checkeds.length > 0 ? 
                            q.id + '=' + checkeds.map(function(){
                                return this.value;
                            }).get().join(',') : null;
                    }).filter(Boolean).join('&');
                    
                    $('#dgAnswerer').datagrid('load', {q: qstr});
                }
            },
            {
                text:"重置选中",
                handler:function() {
                    var q = $('#dgQuestionForAnswererFilter').datagrid('getSelected');
                    queryDialog.find('[name=q_' + q.id + ']').prop('checked', false).change();
                }
            },
            {
                text:"重置全部",
                handler:function() {
                    queryDialog.find(':checkbox, :radio').prop('checked', false).change();
                }
            },
            {
                text: '关闭',
                handler: function() {
                    queryDialog.dialog('destroy');
                }
            }
           ]
       });
   });
});