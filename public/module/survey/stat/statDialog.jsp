<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <div id="canvasDiv"></div>
    
    <script src="${libPath}ichart.1.2.1.min.js"></script>
    <script>
    var QUESTION = {
        id:'${id}',
        orderno: '${orderno}',
        type: '${type}'
    };
    $.get(CONFIG.baseUrl + 'survey/stat/choiceQuestion.do?questionId=' + QUESTION.id, function(ret){
        if (ret.total == 0) {
            $('#canvasDiv').html('<div style="width: 200px;margin: 0 auto;font-size:18px;text-align: center;">暂时没有数据</div>');
            return;
        }
        $('#canvasDiv').empty();
        draw(ret.total, calc(ret));
    });
    
    function calc(data) {
        var colors = [
            "#4572a7", "#aa4643", "#89a54e", "#80699b", "#92a8cd", "#db843d", "#a47d7c",
            "#9d4a4a", "#5d7f97", "#97b3bc", "#a5aaaa", "#778088", "#6f83a5",
            "#feabc9", "#ffdb6d", "#96e2f2", "#f86a66", "#86c399"];
        for (var i = 0; i < 52; i++) {
            colors.push('#' + (11159107 + ((i + 1) * 100)).toString(16));
        }

        return data.options.map(function(o, i) {
            return {
                name: o.content,
                content: o.content,
                total: o.total,
                value: o.total / data.total * 100,
                color: colors[i]
            };
        });
    }
    
    function draw(total, data) {
        var title = (QUESTION.type == 1 ? '单' : '多') + '选题[' + QUESTION.orderno
            + ']各选项选择人数占百分比 (总人数: ' + total + ')';
        var chart = new iChart.Pie2D({
            render: 'canvasDiv',
            showpercent: true,
            decimalsnum: 2,
            width: 900,
            height: 500,
            radius: 150,
            z_index: 999,
            data: data,
            title: {
                text: title,
            },
            sub_option: {
                label: {
                    sign: false
                },
                listeners: {
                    parseText: function(d, t) {
                        return t.substring(t.lastIndexOf(' ') + 1);
                    }
                }
            },
            legend: {
                enable : true,
                z_index: 10,
                align: 'left',
                valign: 'bottom',
                offsetx: -20,
                offesty: 20,
                sign: 'square'
            },
            tip:{
                enable : true,
                listeners:{
                    parseText:function(tip,name,value,text,i){
                        return data[i].content + ' 有' + data[i].total + '人选择';
                    }
                }
            }
        }).draw();
    }
    </script>
</body>
</html>