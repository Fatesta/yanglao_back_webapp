var planCycleDayManage = (function(){
    var signals = {
        selected: new Signal(),
        loaded: new Signal(),
        refresh: new Signal()
    };
    var lastSelected = null;

    planManage.signals.loaded.add(function() {
        $('#dgPlanDay').datagrid('clear');
        lastSelected = null;
    });
    planManage.signals.selected.add(function(plan) {
        if (lastSelected) {
            $('#dgPlanDay').datagrid('clearSelections');
            lastSelected = null;
        }
        if (!$('#dgPlanDay').datagrid('options').url) {
            $('#dgPlanDay').datagrid({
                url: CONFIG.baseUrl + 'health/house/plan/plan/cycle/days.do',
                queryParams: {planId: plan.id},
                idField: 'day',
                pagination: false,
                onLoadSuccess: function() {
                    if (lastSelected) {
                        $('#dgPlanDay').datagrid('selectRecord', lastSelected.day);
                    } else {
                        signals.loaded.dispatch();
                    }
                },
                onSelect: function(_, row) {
                    signals.selected.dispatch({planId: $('#dgPlan').datagrid('getSelected').id, day: row.day});
                    lastSelected = row;
                }
            });
        } else {
            $('#dgPlanDay').datagrid('load', {planId: plan.id});
        }
    });

    signals.refresh.add(function() {
        $('#dgPlanDay').datagrid('reload');
    });

    return {
        signals: signals
    };
})();

var planCycleDayStepManage = (function(){
    var lastQparams = null;
    planCycleDayManage.signals.loaded.add(function(plan) {
        $('#dgPlanDayStep').datagrid('clear');
        lastQparams = null;
    });
    planCycleDayManage.signals.selected.add(function(qparams) {
        if (!$('#dgPlanDayStep').datagrid('options').url) {
            $('#dgPlanDayStep').datagrid({
                url: CONFIG.baseUrl + 'health/house/plan/plan/cycle/daySteps.do',
                queryParams: qparams,
                pagination: false
            });
        } else {
            $('#dgPlanDayStep').datagrid('load', qparams);
        }
        lastQparams = qparams;
    });

    $('#tbrDayStep #add').click(function(){
        if (!lastQparams) {
            alertInfo('请先选择天');
            return;
        }
        var addStep = 0;
        var ascSteps = $('#dgPlanDayStep').datagrid('getRows');
        if (ascSteps.length == 0) {
            addStep = 1;
        } else {
            addStep = 2;
            if (ascSteps[0].step > 1) {
                addStep = ascSteps[0].step - 1;
            } else {
                addStep = null;
            }
        }
        var params = $.extend({step: addStep}, lastQparams);
        var dlg = openEditDialog({
            title: '增加单日配置',
            width: 380,
            height: 240,
            href: 'view/health/house/plan/plan/cycle/frmStep.do?' + $.param(params),
            onLoad: function() {
                $('#frmStep #newArticle').click(function(){
                    openTab({
                        title: '新增计划文章',
                        url: CONFIG.baseUrl + 'view/health/house/plan/article/edit.do?saveAfter=planStepSave'
                    });
                });

                $('#frmStep #refArticle').click(function() {
                    var dialog = openDataSelectDialog({
                        width: 630,
                        height: 400,
                        title: '选择一篇文章',
                        href:'view/health/house/plan/article/index.do?selectMode=true',
                        onSave: function() {
                            var article = $('#dgArticle', dialog).datagrid('getSelected');
                            if (!article) {
                                return;
                            }
                            setArticleToStepFrom(article);
                            dialog.dialog('destroy');
                        }
                    });
                });
            },
            onSave: function() {
                if (!$('#frmStep [name=articleId]').val()) {
                    alertInfo('还未完成设置文章');
                    return;
                }

                formSubmit('#frmStep', {
                    url: 'health/house/plan/plan/cycle/add.do',
                    success: function(ret) {
                        if (ret.success) {
                            dlg.dialog('destroy');
                            $('#dgPlanDayStep').datagrid('reload');
                            planCycleDayManage.signals.refresh.dispatch();
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    });

    $('#tbrDayStep #delete').click(function(){
        var row = $('#dgPlanDayStep').datagrid('getSelected');
        if (!row) {
            return;
        }
        $.post(CONFIG.baseUrl + 'health/house/plan/plan/cycle/delete.do?stepId=' + row.id, function(ret) {
            showOpResultMessage(ret);
            if (ret.success) {
                openConfirmDialog('同时删除其关联的文章吗？', function(){
                    $.post(CONFIG.baseUrl + '/health/house/plan/article/delete.do?id=' + row.articleId, function(ret) {
                        showOpResultMessage(ret);
                    });
                });
                $('#dgPlanDayStep').datagrid('reload');
                planCycleDayManage.signals.refresh.dispatch();
            }
        });
    });

    var m = {
        signals: {
          articleSaved: new Signal()
        },
        editArticle: function(articleId) {
            openTab({
                title: '编辑计划文章',
                url: CONFIG.baseUrl + 'view/health/house/plan/article/edit.do?articleId=' + articleId
                    + '&saveAfter=planStepSave'
            });
        },
        formatters: {
            op: function(_, row) {
                var html = '';
                html += UICommon.buttonHtml({
                    text: '查看/编辑文章',
                    icon: 'detail ',
                    clickCode: 'planCycleDayStepManage.editArticle(' + row.articleId + ')'})
                return html;
            }
        }
    };
    m.signals.articleSaved.add(function(article) {
        openModuleByCode('hh_plan');
        if ($('#frmStep').length) {
            setArticleToStepFrom(article);
        } else {
            $('#dgPlanDayStep').datagrid('reload');
        }
    });
    return m;

    function setArticleToStepFrom(article) {
        $('#frmStep [name=articleId]').val(article.id);
        $('#frmStep #selectedArticleTitle').textbox('setValue', article.title);
    }
})();