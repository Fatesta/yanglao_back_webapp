var locIconManage = {
    formatters: {
        color: function(hex) {
            return '<div style="width: 30px; height: 30px; margin: 5px auto 5px; background-color: #' + hex + '; border-radius: 100%"></div>';
        }
    }
}


require(['rgbaster.min'], function(rgbaster) {
    RGBaster = rgbaster;
})

$('#tbrLocIcon [name=add]').click(function(){
    var dlg = openEditDialog({
        width: 510,
        height: 476,
        title: '增加区域项目',
        modal: true,
        href: 'view/telecare/locIcon/form.do',
        onLoad: function() {
            var colorSpectrum = $("#telecare-locicon-form-color");
            $('[name=uploadButton]', dlg).click(function(){
                openUploadImageDialog({
                    url: 'telecare/locIcon/upload.do',
                    onSuccess: function(data) {
                        $('[name=locIconImage]', dlg).attr('src', data.url).unbind().click(function() {
                            window.open(this.src);
                        });
                        $('[name=icon]', dlg).val(data.url);
                        
                        colorSpectrum.spectrum("option", 'palette', []);
                        colorSpectrum.spectrum("option", 'palette',
                            _.toArray(_.groupBy(data.rgbPalette, function(num, index){ return Math.floor(index/9);})));
                        colorSpectrum.spectrum('set', data.rgbPalette[0]);
                    }
                });
              });
            require(['spectrum/spectrum'], function(spectrum) {
                require(['spectrum/i18n/jquery.spectrum-zh-cn'], function() {
                    colorSpectrum.spectrum({
                        preferredFormat: "hex",
                        flat: true,
                        showPalette: true,
                        showInput: true,
                        allowEmpty:true
                    });
                });
            });
        },
        onSave: function(dlg) {
            if (!$('[name=icon]', dlg).val()) {
                alertInfo('请上传图标');
                return;
            }
            var selectColor = $("#telecare-locicon-form-color").spectrum('get');
            if (!selectColor) {
                alertInfo('请选择颜色');
                return;
            }
            formSubmit('#frmLocIcon', {
                url: 'telecare/locIcon/save.do',
                success: function(ret) {
                    if (ret.success) {
                        $('#dgLocIcon').datagrid('reload');
                        dlg.dialog('destroy');
                    }
                    ret.message = ret.code == 2 ? '区域已存在' : ret.message;
                    showOpResultMessage(ret);
                }
            });
        }
    });
});

$('#tbrLocIcon [name=delete]').click(function(){
    var row = $('#dgLocIcon').datagrid('getSelected');
    if(!row) return;
    openConfirmDeleteDialog(function(){
        $.post(CONFIG.baseUrl + 'telecare/locIcon/delete.do', row, function(ret){
            showOpResultMessage(ret);
            $('#dgLocIcon').datagrid('reload');
        });
    });
});