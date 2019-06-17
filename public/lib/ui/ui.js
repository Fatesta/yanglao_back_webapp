UI(window);
function UI(window) {
    var $ = window.$;
    var document = window.document;
    var exports = window;

    /**
     * 打开Tab，如果Tabs中已有相同标题的Tab，只选中
     * @param options
     */
    exports.openTab = function(tabsId, url, title, iconCls) {
        //新版本object传参方式,兼容旧版本
        var options = {};
        if (typeof tabsId == 'object') {
            options = tabsId;
            url = options.url;
            title = options.title;
        }
        app.openTab({attributes: {url: url}, text: title, id: new Date().getTime(), isNoNode: true});
    }
    
    /**
     * 显示消息
     * 
     * @param title
     *            标题
     * @param msg
     *            消息
     */
    exports.showMessage = function(title, msg) {
        $.messager.show({
            title:title,
            msg:msg,
            timeout:3000,
            showType:'slide'
        });
    }
    
    exports.ALERT_ICON_ERROR = "error";
    
    exports.ALERT_ICON_QUESTION = "question";
    
    exports.ALERT_ICON_INFO = "info";
    
    exports.ALERT_ICON_WARNING = "warning";
    
    /**
     * 提示框
     * 
     * @param title
     *            标题
     * @param msg
     *            消息
     * @param icon
     *            图标，默认为警告图标
     * @param fn
     *            关闭回调函数
     */
    exports.showAlert = function(title, msg, icon, fn) {
        if (!icon) {
            icon = ALERT_ICON_WARNING;
        }
        if (!fn) {
            fn = new Function();
        }
        $.messager.alert(title,msg,icon,fn);
    }
    
    exports.alertInfo = function(msg, fn) {
        $.messager.alert("提示", msg, "info", fn | function(){});
    }
    
    /**
     * 确认框
     * 
     * @param title
     *            标题
     * @param msg
     *            消息
     * @param ok
     *            确认回调
     * @param cancel
     *            取消回调
     */
    exports.showConfirm = function(title, msg, ok, cancel) {
        if (!ok) {
            ok = new Function();
        }
        if (!cancel) {
            cancel = new Function();
        }
        $.messager.confirm(title, msg, function(r){
            if (r){
                ok();
            } else {
                cancel();
            }
        });
    }
    

    /**
     * 打开图片文件上传窗口
     * @author hulang
     */
    exports.openUploadImageDialog = (function() {
        // 全局自增窗口id
        var gDialogID = 1;
        
        var html = '<form id="frmUploadImage" enctype="multipart/form-data" method="post">' 
            + '<input id="file" name="file" type="file" accept="image/gif, image/jpeg, image/png" style="width: 384px;height: 54px;">'
            + '</form>';
            
        return function (options) {
            var dialogId = 'upload_dialog_' + (gDialogID++);
            if ($("#" +dialogId).length == 0)
                $("<div id=" + dialogId + " style='display:none'></div>").appendTo(document.body);
            var dialog = $("#" + dialogId);
            dialog.append(html);
            
            setTimeout(function() {
                dialog.find('#frmUploadImage #file').change(function(){
                    exports.formSubmit(dialog.find('#frmUploadImage'), {
                        url: options.url || "util/upload.do",
                        onSubmit: options.onSubmit,
                        success: function(ret){
                            if (ret.success) {
                                options.onSuccess && options.onSuccess(ret.data);
                                dialog.remove();
                            } else {
                                exports.alertInfo('上传文件失败')
                            }
                        }
                    });
                }).click();
            });
            
            return dialog;
        }
    
    })();

    /**
     * 打开视频文件上传窗口
     * @author hulang
     */
    exports.openUploadVideoDialog = (function() {
        // 全局自增窗口id
        var gDialogID = 1;

        var html = '<form id="frmUploadVideo" enctype="multipart/form-data" method="post">'
            + '<input id="file" name="file" type="file" accept="video/*" style="width: 384px;height: 54px;">'
            + '</form>';

        return function (options) {
            var dialogId = 'upload_dialog_' + (gDialogID++);
            if ($("#" +dialogId).length == 0)
                $("<div id=" + dialogId + " style='display:none'></div>").appendTo(document.body);
            var dialog = $("#" + dialogId);
            dialog.append(html);

            setTimeout(function() {
                dialog.find('#frmUploadVideo #file').change(function(){
                    exports.formSubmit(dialog.find('#frmUploadVideo'), {
                        url: options.url || "util/upload.do",
                        onSubmit: options.onSubmit,
                        success: function(ret){
                            if (ret.success) {
                                options.onSuccess && options.onSuccess(ret.data);
                                dialog.remove();
                            } else {
                                exports.alertInfo('上传文件失败')
                            }
                        }
                    });
                }).click();
            });

            return dialog;
        }

    })();

    /**
    Easyui界面复用组件
    @author hulang
    @date 2017-05-04
     */
    var UICommon = {
        datagrid: {
            formatter: {
                generators: {}
            }
        }
    };
    
    UICommon._fullCellValueDialog = function(dgId, index, type, field) {
        var elem = $("#" + dgId);
        var row;
        if (type == 'datagrid') {
            row = elem.datagrid("getRows")[index];
        } else {
            var id = index;
            row = elem.treegrid('find', id);
        }
        var html = row[field].replaceAll('\n', '<br>').replaceAll(' ', '&nbsp;&nbsp;');
        var divDlg = $("<div>" + html + "</div>");
        divDlg.appendTo($(document.body));
        divDlg.dialog({
            title: "完整内容",
            width: 600,
            height: 400,
            closed: false,
            cache: false,  
            modal: false,
            resizable: true,
            maximizable: true
        });
    }
    UICommon.datagrid.formatter.generators.omit = function(params) {
        params = params || {};
        params.min = params.min || 10;
        return function(value, rowData, rowIndex) {
            var type = 'datagrid';
            if (rowIndex == undefined) {
                type = 'treegrid';
                rowIndex = rowData.id;
            }
            var displayText = '';
            if (params.displayText) {
                displayText = params.displayText;
            } else if(value) {
                displayText = (value.substring(0, params.min) + (value.length > params.min ? " ..." : ""));
            }
            var code = 'UICommon._fullCellValueDialog('
                + "'" + (params.dgId || 'dg') + "'" + ','
                + "'" + rowIndex + "'" +  ','
                + "'" + type + "'" + ','
                + "'" + params.field + "'" + ')';
            return '<a class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" style="cursor:pointer"'
                + 'onclick="' + code + '" >'
                + displayText + '</a>';
        };
    }
    UICommon.datagrid.formatter.generators.image = function(params) {
        return function(value) {
            var html = '';
            if (value) {
                html += '<img src="' + value;
                html += '" height="' + params.height + 'px"';
                if (params.width)
                    html += ' width="' + params.width + 'px"';
                html += '/>';
            } else {
                html = '<div height="' + params.height + 'px"></div>';
            }
            return html;
        };
    }
    UICommon.datagrid.formatter.generators.dict = function(dict) {
        var map = dict.toMap ? dict.toMap() : dict;
        return function(value,rowData,rowIndex) {
            return map[value];
        }
    }
    UICommon.datagrid.formatter.generators.substring = function(start, end) {
        return function(value,rowData,rowIndex) {
            return value ? value.substring(start, end) : "";
        }
    };
    UICommon.datagrid.formatter.wraptip = function(value, rowData, rowIndex) {
        if(!value) return "";
        return '<span title="' + value  + '" >' + value + '</span>';
    }
    UICommon.datagrid.formatter.money = function(value,rowData,rowIndex) {
        return  value.toFixed(2);
    }
    UICommon.datagrid.formatter.integer = function(value,rowData,rowIndex) {
        return value ? parseInt(value) : '';
    }
    UICommon.datagrid.formatter.toEmpty = function(value) {
        return value ? value : '';
    }
    UICommon.datagrid.formatter.enable = function(value,rowData,rowIndex) {
        return value ?
            "<div class='icon-enable'>&nbsp</div>" : "<div class='icon-disable'>&nbsp</div>";
    };
    UICommon.iconHtml = function(name, title) {
        return "<div class='icon-" + name + "' title='" + (title || '') + "'>&nbsp</div>";
    };
    UICommon.buttonHtml = function(options) {
        var html = '<a href="#" title="' + (options.title||"") + '" class="row-op-button"';
        if (options.id) {
            html += ' id="' + options.id + '"';
        }
        html += ' onclick="' + options.clickCode + '">'
        html += ' <span class=\'icon-' + options.icon + '\'>&nbsp;</span>';
        if (options.text)
            html += '<span>' + options.text + '</span>';
        html += '</a>';
        return html;
    }
    UICommon.linkHtml = function(options) {
        var html = '<a href="#"';
        if (options.title) {
            html += ' title=\'' + options.title + '\'';
        }
        if (options.id) {
            html += ' id=\'' + options.id + '\'';
        }
        html += ' onclick=\'' + options.clickCode + '\'>'
        html += options.text + '</a>';
        return html;
    }

    window.DialogManager = exports.DialogManager;
    exports.UICommon = UICommon;
    //todo: 属性继承,更好的统一options
    exports.DialogManager = (function() {
        var dialogId = 1;
        
        return {
            getNewDialogId: function() {
                return dialogId++;
            },
            openSimpleDialog: function(options){
                // 元素id
                var id = 'dialog_' + (options.id || window.DialogManager.getNewDialogId());
                
                // 创建dom元素
                if ($("#" +id).length == 0)
                    $("<div id=" + id + "></div>").appendTo(document.body);
                var elem = $("#" + id);
                
                // 计算合适的尺寸
                if (options.heightFit) {
                    options.height = $(document).height() - 4;
                    delete options.fit;
                }
                if (options.widthFit) {
                    options.width = $(document).width();
                    delete options.fit;
                }
                if (options.href)
                    options.href = '/' + options.href;
                
                var dialog;
                options = $.extend(
                    {
                        closed: false,
                        cache: false,
                        modal: true,
                        shadow: false,
                        resizable: true,
                        maximizable: true,
                        title: ' ',
                        buttons:[{
                            text:"关闭",
                            handler:function() {
                                dialog.dialog('destroy');
                            }
                        }],
                        onClose: function() {
                            dialog.dialog('destroy');
                        }
                    },
                    options);
                dialog = elem.dialog(options);
                
                return dialog;
            }
        };
    })();
    /**
     * 
    @param options 继承easyui-dialog的属性,还包括如下:
      heightFit 同fit,但只是高度
      widthFit  同fit,但只是宽度
    @author hulang
    */
    exports.openEditDialog = (function(){
        return function(options) {
            // 元素id
            var id = 'dialog_' + (options.id || window.DialogManager.getNewDialogId());
            
            // 创建dom元素
            if ($("#" +id).length == 0)
                $("<div id=" + id + " style='position:relative;'></div>").appendTo(document.body);
            var elem = $("#" + id);

            // 计算合适的尺寸
            if (options.heightFit) {
                options.height = $(document).height() - 4;
                delete options.fit;
            }
            if (options.widthFit) {
                options.width = $(document).width();
                delete options.fit;
            }

            if (options.href)
                options.href = '/' + options.href;
                
            var dialog;
            options = $.extend(
                {
                    closed: false,
                    cache: false,
                    modal: false,
                    minimizable: true,
                    maximizable: true,
                    resizable: true,
                    shadow: false,
                    title: '编辑',
                    buttons:[{
                        text: options.okButtonText || "保存",
                        handler:function() {
                            options.onSave(dialog);
                        }
                    },{
                        text:"取消",
                        handler:function(){
                            if (options.onCancel) {
                                options.onCancel();
                            } else {
                                dialog.dialog("destroy");
                            }
                        }
                    }],
                    onClose: function() {
                        dialog.dialog('destroy');
                    },
                    onMinimize: function () {
                        $(this).window('move', {
                            top: "95%"
                        }).window('collapse').window('open');
                    },
                    onMaximize: function () {
                        if ($(this).panel('options').collapsed) {
                            $(this).window('expand');
                        }
                    },
                    onRestore: function() {
                        $(this).window('center');
                    }
                },
                options);
            dialog = elem.dialog(options);
        
            return dialog;
        }
    })();
    
    exports.openQueryDialog = function(options) {
        options.okButtonText = '查询';
        return exports.openEditDialog(options);
    };
    
    exports.openSimpleDialog = exports.DialogManager.openSimpleDialog;
    
    exports.openDataSelectDialog = function(options) {
        options.okButtonText = options.okButtonText || '选择';
        return exports.openEditDialog(options);
    };
    
    exports.showOpOkMessage = function(s) {
        return $.messager.show({
            title: '提示',
            msg: s || '操作成功',
            timeout:3000,
            showType:'slide'
        });
    }
    
    exports.showOpFailMessage = function(s) {
        return $.messager.alert('提示', s || '操作失败', 'warning');
    }
    
    exports.showOpResultMessage = function(ret) {
        if (typeof ret == 'object') {
            if (typeof ret.success != 'undefined' && typeof ret.message != 'undefined')
                return showStateMessage(ret.success, ret.message);
            else if (typeof ret.success != 'undefined')
                return showStateMessage(ret.success);
            else if (typeof ret.success == 'undefined' && typeof ret.message != 'undefined')
                return showTextMessage(ret.message);
        } else if (typeof ret == 'number') {
            return showStateMessage(ret == 0);
        } else if (typeof ret == 'boolean') {
            return showStateMessage(ret);
        } else if (typeof ret == 'string') {
            return showTextMessage(ret);
        }
        
        function showStateMessage(success, msg) {
            msg = msg || (success ? '操作成功' : '操作失败')
            if (success) {
                return sideShow(msg);
            } else {
                return $.messager.alert("提示", msg, "warning");
            }
        }
        
        function showTextMessage(msg) {
            if (msg == '操作成功')
                return showStateMessage(true);
            else if (msg == '操作失败')
                return showStateMessage(false);
            else
                return sideShow(msg);
        }
        
        function sideShow(msg) {
            return $.messager.show({
                title: '提示',
                msg: msg,
                timeout:3000,
                showType:'slide'
            });
        }
    }
    
    exports.alertInfo = function(msg, fn) {
        return $.messager.alert("提示", msg, "info", fn | function(){});
    }
    
    exports.alertError = function(msg, fn) {
        return $.messager.alert("提示", msg, "error", fn | function(){});
    }
    
    exports.openConfirmDialog = function(msg, ok, cancel) {
        return $.messager.confirm("确认", msg, function(r){
            r ? ok && ok() : cancel && cancel();
        });
    }
    
    exports.openConfirmDeleteDialog = function(ok, cancel) {
        return openConfirmDialog("确认删除?", ok, cancel);
    }
    

    /**
     * 提交表单
     * 
     * @param formId
     *            表单ID
     * @param url
     *            提交路径
     * @param success
     *            回调函数
     * @param onSubmit
     *            提交事件
     */
    exports.submitForm = function(formId, url, success, onSubmit) {
        if (!success) {
            success = new Function();
        }
        if (!onSubmit) {
            onSubmit = new Function();
        }
        $("#" + formId).form('submit', {
            url : url,
            onSubmit : onSubmit,
            success : success
        });
    }

    exports.formSubmit = function(selector, options) {
        if (arguments.length == 1) {
            options = arguments[0];
            selector = '#form';
        }
        options.onSubmit = options.onSubmit || function() {};
        
        if (!options.notValidate && !$(selector).form('validate')) {
            return false;
        }
        
        $(selector).form('submit', {
            url: '/' + options.url,
            onSubmit: options.onSubmit,
            success: function(jsonRes) {
                var ret = JSON.parse(jsonRes);
                if (options.success) {
                    options.success(ret);
                } else {
                    exports.showOpResultMessage(ret);
                }
            }
        });
        return true;
    }

    exports.DatagridToolbarFunctions = function(options) {
        var datagrid = options.datagrid;
        var toolbar = $($(datagrid).datagrid('options').toolbar);
        options.functions.forEach(function(func) {
            var requireRow = !func.code.endWiths('add') && !func.code.toLowerCase().endWiths('query');
            $('[id="' + func.code + '"]', toolbar).click(function() {
                if (requireRow) {
                    var row = $(datagrid).datagrid('getSelected');
                    if (!row) {
                        exports.showOpResultMessage({message: '请先选择一行'});
                        return;
                    }
                    func.onClick(row);
                } else {
                    func.onClick();
                }
            });
        });
    }
    
    exports.toggleColumns = function(options) {
    	var datagrid = $(options.datagrid);
    	var cols = datagrid.datagrid('getColumnFields');
		var showCols;
		var hideCols = options.hideColumns;
		if (hideCols) {
			showCols = _.difference(cols, hideCols);
			hideCols.forEach(function(col) {
				datagrid.datagrid('hideColumn', col);
			});
		} else {
			showCols = cols;
		}
		showCols.forEach(function(col) {
			datagrid.datagrid('showColumn', col);
        });
    }
}
