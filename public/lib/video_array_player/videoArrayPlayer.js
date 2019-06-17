/*
@author hulang
@since 2018-09-04 
*/

function VideoArrayPlayer(options) {
    var installed = testActiveX();

    var container = $(
        '<div class="video-array-player">\
             <div class="controls">\
                 <div class="window-split-type-container" '
                        + (options.windowSplitDisabled ? 'style="display:none"' : '')  + '>\
                     <select data-options="editable: false" panelHeight="250"></select>\
                 </div>\
                 <div class="video-info"></div>\
                 <div class="buttons">\
                     <input type="button" class="btn-up" data-value="up" title="上" />\
                     <input type="button" class="btn-down" data-value="down" title="下" />\
                     <input type="button" class="btn-left" data-value="left" title="左" />\
                     <input type="button" class="btn-right" data-value="right" title="右" />\
                     <input type="button" class="btn-off btn-talk" title="对讲已关闭" />\
                     <input type="button" class="icon-on-off" title="停止预览" />\
                     <input type="button" class="btn-full-screen" title="全屏" />\
                 </div>\
             </div>\
         </div>');

    var videoArray = new VideoArray(container);
    
    var signals = {
        played: new Signal(),
        stoped: new Signal(),
        failed: new Signal()
    };

    container.prepend(videoArray);
    videoArray.init();
    
    var select = $('.window-split-type-container > select', container).get(0);
    for (var i = 1; i <= 8; i++) {
        var opt = new Option();
        opt.value = i;
        opt.text = i + ' x ' + i;
        select.options.add(opt);
    }
    $(select).change(function(){
        videoArray.setWindowSplitType(+ this.value);
    });
    
    // 云台移动
    $('.btn-up, .btn-down, .btn-left, .btn-right', container).each(function(){
        var dir = $(this).data('value');
        var dirCmd = {'up': 0, 'down': 1, 'left': 2, 'right': 3}[dir];
        var speed = 3;
        $(this).mousedown(function(){
            $(this).addClass('btn-' + dir + '-press');
            var cell = videoArray.getSelectedCell();
            if (!(cell && cell.playing)) {
                return;
            }
            cell.obj.PTZCtrl(dirCmd, 0, speed);
        });
        $(this).mouseup(function(){
            $(this).removeClass('btn-' + dir + '-press');
            var cell = videoArray.getSelectedCell();
            if (!(cell && cell.playing)) {
                return;
            }
            cell.obj.PTZCtrl(dirCmd, 1, speed);
        });
    });
    
    // 切换对讲
    $('.btn-talk', container).click(function(){
        var cell = videoArray.getSelectedCell();
        if (!(cell && cell.playing)) {
            return;
        }
        var obj = cell.obj;
        
        if (obj.talking) {
            if (obj.StopTalk() === 0) {
                $(this).removeClass().addClass('btn-off').attr('title', '对讲已关闭');
                obj.talking = false;
            }
        } else {
            // 关闭其它所有视频的对讲
            var otherCells = videoArray.getCells().filter(function(c){ return c.id != cell.id });
            otherCells.forEach(function(cell){
                if (cell.obj.talking)
                    cell.obj.StopTalk();
            });
            
            if (obj.StartTalk() === 0) {
                $(this).removeClass().addClass('btn-on').attr('title', '对讲已开启');
                obj.talking = true;
            }
        }
        
    });
    
    // 停止播放
    $('.icon-on-off', container).click(function(){
        var cell = videoArray.getSelectedCell();
        if (cell && cell.playing) {
            cell.obj.StopPlay();
            cell.playing = false;
            cell.cameraInfo = null;
            signals.stoped.dispatch(cell.data);
            cell.data = null;
            videoArray.selectCell(videoArray.getSelectedCell());
        }
    });

    $('.btn-full-screen', container).click(function(){
        var cell = videoArray.getSelectedCell();
        if (cell) {
            videoArray.switchFullScreen(cell);
        }
    });
    
    container.options = options;
    return $.extend(container, {
        play: function(cameraInfo, data) {
            if (!installed)
                return;
            var cell = videoArray.getCells().filter(function(cell){
                return cell.cameraInfo && (cell.cameraInfo.deviceSerial == cameraInfo.deviceSerial);
            })[0];
            if (cell) {
                videoArray.selectCell(cell);
                return;
            }

            AuthManager.get(function(authInfo) {
                videoArray.getEmptyCell(function(cell){
                    if (!cell.obj.inited) {
                        cell.obj.InitWithAppKey(authInfo.appKey);
                        cell.obj.SetAccessToken(authInfo.accessToken.string);
                        cell.obj.inited = true;
                    }
                    var ret = cell.obj.StartPlay(
                        'ezopen://' + cameraInfo.validateCode + '@open.ys7.com/' + cameraInfo.deviceSerial + '/1.hd.live');
                    if (ret == 0) {
                        signals.played.dispatch(data);
                        cell.playing = true;
                        cell.data = data;
                        cell.cameraInfo = cameraInfo;
                        videoArray.selectCell(cell);
                    } else {
                        signals.failed.dispatch(data);
                    }
                });
            });
        },
        exit: function() {
            
        },
        signals: signals,
        resize: function() {
            videoArray.height(container.height() - container.find('.controls').outerHeight());
            videoArray.resize(); 
        }
    });
}

function VideoArray(player) {
    var container = $('<div class="video-array" style="display:none"></div>');

    var selectedCellIndex = -1;
    var incIndex = 0;
    var windowSplitType = 1;
    var cells = [];
    var arrayWidth, arrayHeight;
    var marginLeft = 1, marginTop = 0;
    var fullScreenEntered = false;

    return $.extend(container, {
        init: function() {
            //方向键选择视频格
            $(document, container).keydown(function(event){
                var key = event.keyCode;
                var rows = windowSplitType, cols = windowSplitType;
                switch (key) {
                case 37: // left
                    if (selectedCellIndex - 1 >= 0)
                        selectedCellIndex--;
                    break;
                case 38: // up
                    if (Math.floor(selectedCellIndex / cols) - 1 >= 0)
                        selectedCellIndex -= cols;
                    break;
                case 39: // right
                    if (selectedCellIndex + 1 < rows * cols)
                        selectedCellIndex++;
                    break;
                case 40: // down
                    if (Math.floor(selectedCellIndex / cols) + 1 < rows)
                        selectedCellIndex += cols;
                    break;
                default:
                    return;
                }
                
                //cells[selectedCellIndex].onclick();
                cellOnSelect(cells[selectedCellIndex]);
            });
            /*
            //解决避免捕获点击事件，因为ie等浏览器无法获取object事件且点击时会自动给object加边框
            var clickOverlayIframe = $('<iframe class="click-overlay"></iframe>');
            container.append(clickOverlayIframe);
            //单击选择视频格
            clickOverlayIframe.get(0).onload = function() {
                $(this.contentWindow.document.body)
                .click(function(event) {
                    var x = event.clientX;
                    var y = event.clientY;
                    var cols = Math.ceil(x/($(this).width()/windowSplitType))-1;
                    var rows = Math.ceil(y/($(this).height()/windowSplitType))-1;
                    cellOnSelect(cells[rows * windowSplitType + cols]);
                });
            }
            container.mousemove(function(){
                $(clickOverlayIframe).show();
            }).mouseover(function(){
                $(clickOverlayIframe).show();
            }).mouseout(function(){
                $(clickOverlayIframe).hide();
            })*/
            resize();
            resetCells();
            cellOnSelect(cells[0]);
            container.fadeIn(200);
        },
        getCells: function() { return cells; },
        getEmptyCell: getEmptyCell,
        getSelectedCell: function() {
            return cells[selectedCellIndex];
        },
        selectCell: function(cell) {
            cellOnSelect(cell);
        },
        setWindowSplitType: function(n) {
            windowSplitType = n;
            
            if (cells.length == 0) {
                return;
            }

            resetCells();
            
            // 重新设置索引
            incIndex = cells.length;
            if (selectedCellIndex > cells.length - 1) {
                selectedCellIndex = cells.length - 1;
                //cells[selectedCellIndex].onclick();
                cellOnSelect(cells[selectedCellIndex]);
            }
        },
        switchFullScreen: function(cell) {
            if (cell.fullScreen) {
                player.options.onExitFullScreen();
                setTimeout(function(){
                    setCellSize(cell);
                    cells.forEach(function(celli) {
                        if (cell != celli) {
                            $(celli).show();
                        }
                    });
                }, 350);
            } else {
                cells.forEach(function(celli) {
                    $(celli).hide();
                });
                player.options.onEnterFullScreen();
                $(cell).show();
                setCellMaxSize(cell);
            }
            cell.fullScreen = !cell.fullScreen;
            fullScreenEntered = cell.fullScreen;
        },
        resize: resize
    });
    
    
    function setCellMaxSize(cell) {
        var maxW = arrayWidth;
        var maxH = arrayHeight;
        $(cell).width(maxW);
        $(cell).height(maxH);
        cell.obj.width = maxW;
        cell.obj.height = maxH;
    }
    
    function resetCells() {
        var count = windowSplitType * windowSplitType;
        if (count >= cells.length) {
            count -= cells.length;
            while (count-- > 0) {
                addCell();
            }
        } else {
            // 删除后面格子
            for (var i = cells.length - 1,
                     j = windowSplitType * windowSplitType - 1;
                 i > j; i--) {
                var cell = cells[i];
                cell.obj.playing && cell.obj.StopPlay();
                $(cell).remove();
                cells.splice(i, i + 1);
            }
        }
        resizeAllCells();
    }

    function resize() {
        arrayWidth = container.width();
        arrayHeight = container.height();

        resizeAllCells();
        if (fullScreenEntered) {
            var cell = cells[selectedCellIndex];
            setCellMaxSize(cell);
        }
    }

    function setCellSize(cell) {
        var cellW = Math.abs(arrayWidth - 2) / windowSplitType;
        var cellH = Math.abs(arrayHeight - 2) / windowSplitType;
        var obj = cell.obj;
        obj.width = cellW - marginLeft;
        obj.height = cellH - marginTop;
        $(cell).width(obj.width);
        $(cell).height(obj.height);
    }
    
    function resizeAllCells() {
        // 重新调整已有格子尺寸
        cells.forEach(function(v){
            setCellSize(v);
        });
    }
    
    function addCell() {
        var cell = document.createElement('div');
        cell.id = 'cell-' + incIndex;
        cell.index = incIndex;
        cell.empty = true;
        cell.onclick = cellOnSelect;
        $(cell).addClass('cell');
        $(cell).css({
            position: 'relative',
            display: 'inline-block',
            //background: 'rgba(0,0,0,0.9)',
            marginLeft: marginLeft + 'px',
            marginTop: marginTop + 'px'
        });
        var obj = document.createElement('object');
        obj.setAttribute('classid', "clsid:54FC7795-1014-4BF6-8BA3-500C61EC1A05");
        obj.name = 'EZUIKit';
        $(obj).css({'pointer-events': 'none'});
        obj.onclick = cellOnSelect;
        cell.obj = obj;
        cell.appendChild(obj);
        
        setCellSize(cell);
        cells.push(cell);
        $(container).append(cell);

        incIndex++;
        
        cell.isEmpty = function() {
            return !cell.playing;
        };
        
        return cell;
    }
    
    function getEmptyCell(callback) {
        var cell = null;
        for (var i = 0; i < cells.length; i++) {
            if (cells[i].isEmpty()) {
                cell = cells[i];
                break;
            }
        }
        
        
        if (cell) {
            callback(cell);
        } else {
            if (incIndex + 1 > windowSplitType * windowSplitType) {
                windowSplitType++;
                $('.window-split-type-container > select', player).val(windowSplitType);
            }
            var emptyIndex = cells.length;
            resetCells();
            cell = cells[emptyIndex];
            setTimeout(function(){
                callback(cell);
            }, 100);
        }
        
        selectedCellIndex = cell.index;
        //cells[selectedCellIndex].onclick();
        cellOnSelect(cells[selectedCellIndex]);
    }
    
    function cellOnSelect(cell) {
        cell = cell || this;
        selectedCellIndex = cell.index;
        $('.cell', container).css({
            'outline': ''
        });
        $(cell).css({
            'outline': '1px solid yellow'
        });
        
        var info = '已选中';
        if (cell.cameraInfo) {
            info += player.options.infoFormatter(cell.data);
        } else {
            var num = typeof cell.index != 'undefined' ? (function(n){ return n < 10 ? '0' + n : n; })(cell.index + 1) : '01';
            info += num + '号视频.';
        }
        $('.video-info', player).text(info);
    }
}