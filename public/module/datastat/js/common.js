$.extend($.fn, {
    styledNumber: function(num) {
        $(this).html(num == 0 ? warpHtml(0) : (function f(n) {
            return n > 0 ? arguments.callee(Math.floor(n / 10)) + warpHtml(n % 10) : '';
        })(num));
        
        function warpHtml(n) {
            return '<span class="num">' + n + '</span>';
        }
    },
    title: function(s) {
    	$(this).html('<img src="' + CONFIG.modulePath + 'datastat/img/title_left.png">'
    			+ '<span>' + s + '</span>'
    			+ '<img src="' + CONFIG.modulePath + 'datastat/img/title_right.png">');
    }
});
