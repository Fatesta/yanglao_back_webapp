var formatters = $.extend(formatters || {}, {
    op: function(val, row, index){
        return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:#fff\'" onclick="showChoiceStat(\'' + index + '\')">图表</a>';
    }
});
$("#tbrQuestion #export").click(function(){
    showMessage("提示", "后台正在处理导出，请稍等...");
    location.href = CONFIG.baseUrl +"survey/stat/export.do?t=" + +new Date() + "&surveyId=" + PAGE_CONFIG['surveyId'];
});

$('#tbrQuestion #query').click(query);
$('#tbrQuestion #expandAll').click(function(){
    var expanded = $(this).data('expanded');
    for (var i = 0, t = $('#dgQuestion').datagrid('getData').total; i < t; i++) {
        $('#dgQuestion').datagrid(expanded ? 'collapseRow' : 'expandRow', i);
    }
    $(this).data('expanded', !expanded);
});

query();

var inited = false;
function query() {
    var params = $("#frmQuery").serializeObject();
    
    if (!inited) {
        $('#dgQuestion').datagrid({
            url: CONFIG.baseUrl + 'survey/stat/questionPage.do?surveyId=' + PAGE_CONFIG['surveyId'],
            idField: 'id',
            loadFilter: function(data) {
                data.rows.forEach(function(q){
                    q.options.forEach(q.total == 0 ?
                        function(o) { o.percent = 0; } :
                        function(o) { o.percent = o.total / q.total * 100; });
                });
                return data;
            },
            pageList: [10, 20, 50],
            fit: true,
            fitColumns: true,
            rownumbers: false,
            view: detailview,
            detailFormatter:function(index,row){
                return '<div style="padding:2px"><table class="ddv"></table></div>';
            },
            onExpandRow: function(index, row){
                if (!$(this).datagrid('getRowDetail',index).data('loaded')) {
                    var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
                    ddv.datagrid({
                        data: row.options,
                        rownumbers: false,
                        width: '90%',
                        height:'auto',
                        columns:[[
                            {field:'orderno',title:'序号',align:'center',width: 50},
                            {field:'content',title:'内容',width: '86%'},
                            {field:'total',title:'人数',align:'center',width: '5%'},
                            {field:'percent',title:'百分比',align:'center',width: '%3', formatter: function(v) { return v.toFixed(2) + '%'; }}
                        ]],
                        onResize:function(){
                            $('#dgQuestion').datagrid('fixDetailRowHeight',index);
                        },
                        onLoadSuccess:function(){
                            setTimeout(function(){
                                $('#dgQuestion').datagrid('fixDetailRowHeight',index);
                            },0);
                        }
                    });
                    $(this).datagrid('getRowDetail',index).data('loaded', true);
                }
                
                $('#dgQuestion').datagrid('fixDetailRowHeight',index);
            },
            onLoadSuccess: function(data) {
                if (inited)
                    return;
                var delay = 0;
                for (var i = 0; i < data.total; i++) {
                    (function(i){
                        setTimeout(function(){
                            $('#dgQuestion').datagrid('expandRow', i);
                        }, delay += 50);
                    })(i);
                }
            }
        });
        inited = true;
    } else {
        $('#dgQuestion').datagrid("load", params);
    }
}

function showChoiceStat(index) {
    var row = $('#dgQuestion').datagrid('getRows')[index];
    var dlg = DialogManager.openSimpleDialog({
        width: 1000,
        heightFit: true,
        href: 'view/survey/stat/statDialog.do?' + $.param(row), 
        title: ' '
    });
}
