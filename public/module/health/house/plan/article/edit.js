var editor = new SArticleEditor('planArticleEditorContainer', {
    width: 420,
    height: $(document).height() - 100,
    onReady: function() {
        if (PageConfig.isAdd) {
            return;
        }
        editor.startLoadContent();
        $.get(CONFIG.baseUrl + 'health/house/plan/article/get.do?id=' + PageConfig.articleId, function(article) {
            $('#frmArticle [textboxname=title]').textbox('setValue', article.title);
            $('#frmArticle [name=coverUrl]').val(article.coverUrl);
            $('#frmArticle #imgCover').attr('src', article.coverUrl).fadeIn();
            editor.setValue(article.content);
        });
    },
    onSave: function() {
        save();
    }
});

$('#coverUpload').click(function(){
    openUploadImageDialog({
        onSuccess: function(data) {
            $('#imgCover').attr('src', data.url).fadeIn();;
            $('#frmArticle [name=coverUrl]').val(data.url);
        }
    });
});


function save() {
    var article = {
        id: PageConfig.articleId,
        title: $('#frmArticle [textboxname=title]').textbox('getValue'),
        coverUrl: $('#frmArticle [name=coverUrl]').val(),
        content: JSON.stringify(editor.getSArtElements())
    };

    $.post(CONFIG.baseUrl + 'health/house/plan/article/save.do', article, function(ret) {
        article = ret.data;
        PageConfig.articleId = article.id;
        showOpResultMessage(ret);
        if (PageConfig.saveAfter == 'planStepSave') {
            var ctx = getModuleContext('hh_plan');
            if (ctx) {
                setTimeout(function() {
                    closeCurrentModule();
                    ctx.planCycleDayStepManage.signals.articleSaved.dispatch(article);
                }, 1000);
            }
        } else if (PageConfig.saveAfter == 'articleListUpdate') {
            var ctx = getModuleContext('hh_plan_article');
            if (ctx) {
                setTimeout(function() {
                    closeCurrentModule();
                    ctx.updateSignal.dispatch(article);
                }, 1000);
            }
        }
    });
}