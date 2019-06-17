var formatters = {
    type: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('scan.type')),
    status: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('scan.status')),
    isvalid: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-enable')),
    resourceTitle: function(s) {
        return s;
    },
    resourceId: function(v) {
        return v;
    },
    qrcode: function(_, row) {
        return UICommon.buttonHtml({
            id: 'scan_' + row.id,
            title: '查看',
            icon: 'code',
            clickCode: ''
        });
    }
};
(function(m) {
    var openedDialog = null;
    
    m.onLoadSuccess = function(page) {
        page.rows.forEach(function(row) {
            $('#scan_' + row.id).mouseover(function() {
                openedDialog && openedDialog.dialog('destroy');
                m.openFullQRCodeDialog(row);
            });
        });
    }
    
    $(document).click(function() {
        openedDialog && openedDialog.dialog('destroy');
        openedDialog = null;
    });
    
    m.openFullQRCodeDialog = function(row) {
        var title = row.title.length > 20 ? (row.title.substring(0, 20) + "...") : row.title;
        var html = '<div style="overflow:hidden;padding-top:10px;"><h4 style="text-align:center;">' + title + '</h4>'
            + '<img src="' + m.qrcodeUrl(row,300,300) + '" style="margin: 0 auto;display: block;"/></div>';
        openedDialog = DialogManager.openSimpleDialog({
            width: 310,
            height: 370,
            title: '扫一扫二维码',
            href: null,
            modal: false,
            content: html,
            buttons: [],
            onClose: function() {
                $(this).dialog('destroy');
                openedDialog = null;
            }
        });
    }
    
    m.qrcodeUrl = function (record, width, height) {
        return CONFIG.baseUrl + 'scan/qrcode.do?'
            + 'resourceId=' + record.resourceId
            + '&type=' + record.type
            + '&industryId=' + record.industryId
            + '&width=' + width + '&height=' + height;
    }
})(window);

$(function(){
    $('#query').click(function(){
        $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
    });
    $('#add').click(function(){
        edit(false);
    });
    $('#update').click(function(){
        edit(true);
    });
    $('#delete').click(function(){
        var row = $('#dg').datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'scan/delete.do?id=' + row.id, function(ret){
                showOpResultMessage(ret);
                $('#dg').datagrid('load');
            });
        });
    });
    
    $("#publish").click(function(){
        var row = $("#dg").datagrid("getSelected");
        if (!row || row.status != 0)
            return;
        post(CONFIG.baseUrl + 'scan/publish.do', {id: row.id}, function(ret){
            if (ret.success)
                $("#dg").datagrid("reload");
            showOpResultMessage(ret);
        });
    });
    
    $('#genQRCode').click(function() {
        var row = $("#dg").datagrid("getSelected");
        if (!row)
            return;
        var width = prompt('像素宽度', '');
        if (width == null)  return;
        var height = prompt('像素高度', '');
        if (height == null)  return;
        width = +width;
        height = +height;
        if (isNaN(+width) || isNaN(+height)) {
            alert('宽度或高度值错误');
            return;
        }

        window.location.href = qrcodeUrl(row, width, height) + '&attachment=true';
    });
    
    function edit(isUpdate) {
        var row;
        if (isUpdate) {
            row = $('#dg').datagrid('getSelected')
            if (!row) return;
        }
        var dlg = openEditDialog({
            width: 400,
            height: 300,
            title: (isUpdate ? '修改' : '增加') + "扫一扫",
            href: 'view/scan/form.do',
            modal: true,
            onOpen: function() {
                setTimeout(function() {
                    $(dlg).parent().css({zIndex: 999, position: 'absolute'});
                }, 0);
                $('.window-mask').css({zIndex: 998});
            },
            onLoad: function() {
                if (isUpdate) {
                    get('scan/get.do', {id: row.id}, function(info){
                        changeUIByType(info.type);
                        $('#form').form('load', info);
                        $('#selectedResource').textbox('setValue', '-');
                    });
                } else {
                    $('#form').form('load', {status: 0, isvalid: true});
                }
                
                $('#type').comboboxFromDict({
                    dict: DictMan.items('scan.type'),
                    enableEmptyItem: false,
                    onChange: function(type) {
                        changeUIByType(type);
                    }
                });
                
                $('#openEdit').click(function() {
                    window.scanEditorSignals = {
                        readyed: new Signal()
                    };
                    var editor;
                    var dlg = openEditDialog({
                        id: 'scanEditorDialog',
                        width: '80%',
                        height: '90%',
                        href: 'view/scan/edit.do' + (isUpdate ? ('?id=' + row.id) : ''),
                        title: "编辑扫一扫图文",
                        onOpen: function() {
                            setTimeout(function() {
                                $(dlg).parent().css({zIndex: 1000, position: 'absolute'});
                            }, 0);
                        },
                        onLoad: function() {
                            scanEditorSignals.readyed.add(function(_editor) {
                                editor = _editor;
                                editor.setContent($("[name=content]").val());
                            });
                            
                        },
                        onCancel: function() {
                            this.onSave();
                        },
                        onSave: function() {
                            var content = editor.getContent();
                            $("[name=content]").val(content);
                            dlg.dialog('destroy');
                        }
                    });
                });
                
                function changeUIByType(type) {
                    $('#titleTr').hide();
                    $('[textboxname=title]', dlg).textbox({required: false});
                    $('#resourceSelectTr').hide();
                    $('#selectedResource').textbox({required: false});
                    $("[name=content]").val('');
                    $("[name=resourceId]").val("");
                    $('#selectedResource').textbox('setValue', '');
                    $("[name=industryId]").val('');
                    $('[textboxname=sendPoint]').textbox('setValue', '0');
                    $('#pointTr').hide();
                    $('#openEditTr').hide();

                    var typeNotes = {
                        0: '线上活动预约模式',
                        1: '线下活动签到模式',
                        2: '',
                        3: ''
                    };
                    $('#typeNote').text(typeNotes[type]);

                    switch(+type) {
                    case 0:
                        $('#resourceSelectTr').show();
                        $('#selectedResource').textbox({required: true});
                        $("[name=industryId]").val('activity');
                        //$('#pointTr').show();
                        break;
                    case 1:
                        $('#titleTr').show();
                        $('[textboxname=title]', dlg).textbox({required: true});
                        $("[name=industryId]").val('activity');
                        $('#pointTr').show();
                        $('#openEditTr').show();
                        break;
                    case 2:
                    case 3:
                        $('#resourceSelectTr').show();
                        $('#selectedResource').textbox({required: true});
                        break;
                    }
                }
                
                $('#selectResource').click(function() {
                    var type = $('#type').combobox('getValue');
                    if (!type) {
                        alertInfo('请先选择资源类型');
                        return;
                    }
                    
                    if (type == 1) {
                        return;
                    }
                    
                    var selectors = {
                        0: selectActivity,
                        2: selectCoupon,
                        3: selectProduct,
                    };
                    selectors[type](function(result) {
                        $('#selectedResource').textbox('setValue', result.resourceTitle);
                        $("[name=resourceId]").val(result.resourceId);
                        $("[name=industryId]").val(result.industryId);
                        $('[textboxname=title]', dlg).textbox('setValue', result.resourceTitle);
                    });
                    
                    // 选择优惠券
                    function selectCoupon(done) {
                        openDataSelectDialog({
                            title: '选择优惠券',
                            width: '90%',
                            height: 600,
                            href: 'view/coupon/couponSelect.do',
                            onSave: function(dlg) {
                                var coupon = $('#dgCoupon').datagrid('getSelected');
                                if (!coupon) {
                                    alertInfo('请选择一个优惠券');
                                    return;
                                }
                                done({resourceId: coupon.id, resourceTitle: coupon.subject});
                                dlg.dialog('destroy');
                            }
                        });
                    }

                    // 选择活动
                    function selectActivity(done) {
                        openProviderToProductSelectDialog({
                            displayIndustries: ['activity'],
                            defaultSelectIndustry: 'activity',
                            onSubmit: function(activity, provider) {
                                if (!activity) {
                                    alertInfo('请选择一个活动');
                                    return;
                                }
                                done({resourceId: activity.id, resourceTitle: activity.title, industryId: 'activity'});
                            }
                        })
                    }

                    // 选择商品
                    function selectProduct(done) {
                        openProviderToProductSelectDialog({
                            displayIndustries: ['mall', 'integral_mall', 'catering', 'housekeeping'],
                            defaultSelectIndustry: '',
                            onSubmit: function(product, provider) {
                                if (!product) {
                                    alertInfo('请选择一个商品');
                                    return;
                                }
                                done({resourceId: product.productId, resourceTitle: product.name, industryId: provider.industryId});
                            }
                        })
                    }
                });
            },
            onSave: function() {
                formSubmit({
                    url: 'scan/save.do',
                    success: function(ret) {
                        uploadedFile = null;
                        if (ret.success) {
                            $('#dg').datagrid('reload');
                            dlg.dialog('destroy');
                        }
                        showOpResultMessage(ret);
                    }
                });
            }
        });
    }
});