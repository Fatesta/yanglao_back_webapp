var updateSignal = new Signal();
updateSignal.add(function() {
    openModuleByCode('hh_plan_article');
    $('#dgArticle').datagrid('reload');
});

(function(){
    var editor;
    if (!selectMode) {
        $(function () {
            var panel = $('#layout').layout('panel', 'west');
            var width = $(document).width() - 500;
            panel.width(width);
            panel.parent().width(width);
            panel.parent().offset({left: 0});


            editor = new SArticleEditor('planArticleEditorContainer', {
                width: 420,
                height: $(document).height() - 20,
                previewMode: true
            });
        });
    }

    articleDatagridOnSelect = function(_, article) {
        if (selectMode) return;
        setTimeout(function() {
            editor.setValue(article.content);
        }, 0);
    }

    var inited = false;
    articleDatagridOnLoadSuccess = function() {
        if (selectMode) return;
        if (!inited) {
            $('#dgArticle').datagrid('selectRow', 0);
            inited = true;
        }
        editor.clear();
    }
})();

var formatters = {
    refCount: function(v) {
        return v ? v + '次' : '<span style="color: gray;">未被引用</span>';
    }
};

$('#tbrHealthPlanArticle #query').click(function(){
    $('#dgArticle').datagrid('load', $('#tbrHealthPlanArticle #frmQuery').serializeObject());
});
$('#tbrHealthPlanArticle #add').click(function(){
    openTab({
        title: '新增计划文章',
        url: CONFIG.baseUrl + 'view/health/house/plan/article/edit.do?saveAfter=articleListUpdate'
    });
});
$('#tbrHealthPlanArticle #update').click(function(){
    var row = $('#dgArticle').datagrid('getSelected');
    if (!row) {
        return;
    }
    openTab({
        title: '修改计划文章',
        url: CONFIG.baseUrl + 'view/health/house/plan/article/edit.do?saveAfter=articleListUpdate&articleId=' + row.id
    });
});

$('#tbrHealthPlanArticle #delete').click(function(){
    var row = $('#dgArticle').datagrid('getSelected');
    if (!row) {
        return;
    }
    openConfirmDeleteDialog(function(){
        $.post(CONFIG.baseUrl + '/health/house/plan/article/delete.do?id=' + row.id, function(ret) {
            if (ret.success) {
                showOpOkMessage();
                $('#dgArticle').datagrid('reload');
            } else {
                alertInfo({2: '该文章已被引用，不能删除'}[ret.code]);
            }
        });
    });
});
