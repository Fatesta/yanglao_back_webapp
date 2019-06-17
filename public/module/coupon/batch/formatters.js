var formatters = {
    type: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('coupon.type')),
    status: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('coupon.batch.status')),
    providerName: function(providerName, coupon) {
        return coupon.providerId == 0 ? '<span>【平台劵】</span>' : UICommon.datagrid.formatter.wraptip(providerName);
    },
    couponUser: {
        status: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('coupon.status'))
    }
};