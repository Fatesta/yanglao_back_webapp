var couponManage = (function() {
    var inited = false;
    $(function() {
        $('#tbrCoupon [comboname=type]').comboboxFromDict({
            dict: DictMan.items('coupon.type'),
            emptyItem: {text: '全部', value: '0'},
            value: 0
        });
        $('#tbrCoupon [comboname=scope]').comboboxFromDict({
            dict: DictMan.items('coupon.status')
        });
        $('#tbrCoupon [name=query]').click(function() {
            query();
        });
        $('#tbrCoupon #range').combobox({
            onChange: function(opt) {
                $('#selectProviderTr').hide();
                switch(opt) {
                case 0:
                    $('[name=providerId]').val('');
                    break;
                case 1:
                    $('#selectProviderTr').show();
                    $('#providerName').textbox('clear');
                    $('[name=providerId]').val('');
                    openProviderSelectDialog({
                        onDone: function(provider) {
                            $('#providerName').textbox('setValue', provider.name);
                            $('[name=providerId]').val(provider.providerId);
                            return true;
                        }
                    });
                    break;
                case 2:
                    $('[name=providerId]').val(0);
                    break;
                }
            }
        });
        $('#tbrCoupon #selectProviderTr').click(function(){
            openProviderSelectDialog({
                onDone: function(provider) {
                    $('#providerName').textbox('setValue', provider.name);
                    $('[name=providerId]').val(provider.providerId);
                    return true;
                }
            });
        });
        
    });
    
    function query() {
        var qparams = $('#tbrCoupon form').serializeObject();
        if (!inited) {
            $('#dgCoupon').datagrid({
                url: CONFIG.baseUrl + 'user/purse/coupon/page.do',
                fit: true,
                queryParams: qparams
            });
            inited = true;
        } else {
            $('#dgCoupon').datagrid('load', qparams);
        }
    }

    return {
        query: query
    };
})();
