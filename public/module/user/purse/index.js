
var purse = (function() {
    var data = null;
    
    return {
        refresh: function(){
            $.get(CONFIG.baseUrl + 'user/purse/get.do?userId=' + PAGE_CONFIG['userId'], function(d) {
                data = d;
                
                $('#balance').text(data.gold || 0);
                $('#points').text(data.silver);
                if (data.oldCardBlance != "-1" && data.oldCardBlance !== '') {
                    $('#oldCardBalanceSpan').show();
                    $('#oldCardBlance').text(data.oldCardBlance);
                }
                var restCoupons = 0;
                data.couponList.forEach(function(c) {
                    if (c.status == 0)
                        restCoupons++;
                });
                $('#restCouponCount').text(restCoupons);
                $('#consumeCardCount').text(data.cardList.length);
                consumeCardManage.loadData(data.cardList);
                couponManage.query();
            });
        },
        getBalance: function() { return data.gold; }
    };
})();


$(function(){
    couponManage.query();
    consumeCardManage.loadData([]);
    purse.refresh();
});

