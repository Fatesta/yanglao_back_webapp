<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
/* 网格布局 */
.row {
    margin-top: 10px;
    position: relative;
    width: 100%;
    height: 100px;
}

.col-6 {
    position: relative;
    width: 50%;
    height: 100%;
    float: left;
}

/* 表格容器 */
#telecare-weekStat-layout .table_container {
    padding: 0 50px 0 50px;
}
/* table */
#telecare-weekStat-layout table {
    border: 1px solid #e7e7e7;
    text-align: center;
    user-select: none;
}
#telecare-weekStat-layout table caption {
    font-size: 1.2em;
    font-weight: bold;
    margin-bottom: 10px;
}

#telecare-weekStat-layout table th, #telecare-weekStat-layout table td  {
    border: 1px solid #e7e7e7;
}
#telecare-weekStat-layout table th {
    width: 64px;
    height: 32px;
    background-color: #f9f9f9;
}
#telecare-weekStat-layout table td {
    width: 100px;
    height: 32px;
}
#telecare-weekStat-layout table td:hover {
    background: #f9f9f9;
}

#telecare-weekStat-layout table td:nth-child(1) {
    width: 160px;
    font-weight: bold;
    background-color: #f9f9f9;
}

/* 图例 */
#telecare-weekStat-layout .legend {
    margin: 2px auto;
}
#telecare-weekStat-layout .legend>div{
    margin-right: 12px;
    float: left;
    user-select: none;
    cursor: pointer;
}
#telecare-weekStat-layout .legend .unselected {
    color: rgba(0, 0, 0, 0.5);
    opacity: 0.5;
    filter: alpha(opacity=50);
}
</style>
<div id="telecare-weekStat-layout" class="easyui-layout">
    <div class="row">
	    <div class="col-6">
	       <div class="table_container"></div>
	    </div>
	    <div class="col-6">
	       <div class="table_container"></div>
	    </div>
    </div>
</div>

<script>
define('telecare.report.weekStat', function() {
    return function (queryParams) {
        var layout = $('#telecare-weekStat-layout');
        
        createTable($('.table_container:eq(0)', layout), {
            id: 't1',
            caption: '近一周生活习惯统计表',
            endDate: queryParams.date,
            legend: {
                items: [
                    [1, 'sleep', '睡眠'],
                    [2, 'exercise_light', '运动量低'],
                    [3, 'exercise_middle', '运动量中'],
                    [4, 'exercise_high', '运动量高']
                ]
            },
            data: [
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
                [2, 2, 2, 3, 3, 4, 2],
                [3, 3, 3, 3, 3, 3, 3],
                [2, 2, 2, 2, 2, 2, 2],
                [3, 2, 2, 2, 2, 2, 2],
                [2, 2, 2, 3, 3, 2, 2],
                [2, 2, 2, 2, 2, 2, 2],
                [1, 1, 1, 1, 1, 1, 1],
                [1, 1, 1, 1, 1, 1, 1],
            ]
        });
        
        createTable($('.table_container:eq(1)', layout), {
            id: 't2',
            caption: '近一周异常统计表',
            endDate: queryParams.date,
            legend: {
                items: [
                    [1, 'normal', '正常'],
                    [2, 'sos', 'SOS报警'],
                    [3, 'location', '定位异常'],
                    [4, 'blood_sugar', '血糖异常'],
                    [5, 'blood_pressure', '血压异常'],
                    [6, 'heart_rate', '心率异常']
                ]
            },
            data: [
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 6, 1],
                   [1, 1, 1, 1, 1, 3, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 6, 1, 1],
                   [1, 1, 1, 4, 2, 1, 1],
                   [1, 1, 1, 1, 1, 1, 1],
                   [1, 1, 1, 1, 1, 5, 1]
               ]
        });
        
        function createTable(container, options) {
            var valueMap = {};
            options.legend.items = options.legend.items.map(function(item) {
                var v = item[0];
                var u = CONFIG.modulePath + 'telecare/img/' + item[1] + '.png';
                var t = item[2];
                var item = {value: v, imgUrl: u, text: t};
                valueMap[item.value] = item;
                return item;
            });
            
	        // 日期标题
	        var dateArray = [];
	        var thead = '';
	        thead += '<th>时间 / 日期</th>';
	        var mdate = moment(options.endDate).subtract(7, 'days');
	        for (var i = 0; i < 7; i++) {
	            mdate.add(1, 'days');
	            dateArray[i] = mdate;
	            thead += '<th>' + mdate.format('MM-DD') + '</th>'
	        }
	        
	        // 内容
	        var array = options.data;
	        
	        var tbody = '';
	        for (var h = 0; h < 12; h++) {
	            var tr = '';
	            // 时间标题
	            var begTime = (String.leftPad0(h * 2) + ':00');
	            var endTime = (String.leftPad0(h * 2 + 1) + ':59');
	            
	            tr += '<td>' + begTime + ' - ' + endTime + '</td>';
	            for (var i = 0; i < 7; i++) {
	                var item = valueMap[ array[h][i] ];
	                var cell = item ? imgHtml(item.imgUrl,
	                    dateArray[i].format('MM月DD日') + begTime + '~' + endTime + '： ' + item.text) : '';
	                tr += '<td data-value="' + item.value + '">' + cell + '</td>';
	            }
	            tbody += '<tr>' + tr + '</tr>';
	        }

	        // 表格html
            var table = '<table id=' + options.id + '>' +
	            '<caption>' + options.caption + '</caption>' + 
	            '<thead><tr>' + thead + '</tr></thead>' + 
	            '<tbody>' + tbody + '</tbody></table>';
            
            // 图例html
            var legendDiv = '<div class="legend">';
            options.legend.items.forEach(function(item) {
                legendDiv += ('<div data-value="' + item.value + '">'
                    + imgHtml(item.imgUrl)
                    + '<span style="vertical-align: middle;">'
                    + item.text + '</span></div>');
            });
            legendDiv += '</div>';

            container.hide().html(table + legendDiv).fadeIn();
            
            $('.legend>div', container).click(function() {
                var value = $(this).data('value');
                if (!this.selected) {
                    $(this).removeClass().addClass('unselected');
                    toggle(value, 'hide');
                } else {
                    $(this).removeClass();
                    toggle(value, 'show');
                }
                this.selected = !this.selected;
                return false;
                
                function toggle(value, f) {
                    var tds = $('td[data-value="' + value + '"]>img', container);
                    if (f == 'hide') {
                        tds.fadeOut(10);
                    } else {
                        tds.fadeIn(100);
                    }
                }
            });
            
            function imgHtml(src, title) {
                var html = '<img src="' + src + '" style="vertical-align: middle;"';
                if (title) {
                    html += ' title= "' + title + '"'
                }
                html += '/>';
                return html;
            }
        }
    }
});
</script>