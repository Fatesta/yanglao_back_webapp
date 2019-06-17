var MapUtils = {};
(function(){
    /*地图标记关联信息Window*/
    function WindowOverlay(options) {
        this._center = options.center;
        this._width = options.width;
        this._height = options.height;
        this._title = options.title;
        this._titleIcon = options.icon;
        this._content = options.content;
    }
    // 继承API的BMap.Overlay    
    WindowOverlay.prototype = new BMap.Overlay();
    // 实现初始化方法  
    WindowOverlay.prototype.initialize = function(map) {
        // 保存map对象实例   
        this._map = map;
        var $box = $(
            "<div style=\"position:absolute;\">" +
            "<div class='tip_content' style=\"width:" + this._width + "px;height:" + this._height + "px;\">" +
            "<div class='tip_title'><div class='tip_title_text' style='font-size:1.2em;font-weight:bold'>" + this._title + "</div>" +
            "<a href='#' style='top: unset;line-height: 50px;'>关闭</a></div>" +
            "<div>" + this._content + "</div>" +
            //"<div class='tip_triangle' style=\"margin-left:" + (this._width/2 - 16) + "px;\"></div>" + 
            "</div>" +
            "</div>"
        );
        var overlay = this;
        $box.find("a").on("click", function () {
            map.removeOverlay(overlay);
        });
        var box = $box.get(0);
        // 将div添加到覆盖物容器中   
        map.getPanes().floatPane.appendChild(box);
        // 保存div实例   
        this._div = $box.get(0);
        // 需要将div元素作为方法的返回值，当调用该覆盖物的show、   
        // hide方法，或者对覆盖物进行移除时，API都将操作此元素。   
        return box;
    };

    WindowOverlay.prototype.draw = function() {
        // 根据地理坐标转换为像素坐标，并设置给容器    
        var position = this._map.pointToOverlayPixel(this._center);
        this._div.style.left = position.x - this._width / 2 + 20 + "px";
        this._div.style.top = position.y - this._height - 26 - 20 + "px";
    };

    WindowOverlay.prototype.show = function() {
        if (this._div) {
            this._div.style.display = "";
        }
    };

    WindowOverlay.prototype.hide = function() {
        if (this._div) {
            this._div.style.display = "none";
        }
    };

    WindowOverlay.prototype.toggle = function() {
        if (this._div) {
            if (this._div.style.display == "") {
                this.hide();
            } else {
                this.show();
            }
        }
    };

    function MapMarkerInfoWindowManager(map, options) {
        var _map = map;
        var timer = null;
        options = options || {};
        var markers = [];

        this.showInfoWindow = function(marker, windowOverlay) {
            if (marker._infoWindowOverlay) {
                _map.removeOverlay(marker._infoWindowOverlay);
            }
            markers.push(marker);

            clearTimeout(timer);
            _map.addOverlay(windowOverlay);
            marker._infoWindowOverlay = windowOverlay;
        };

        this.setDefaultEventHandlers = function(marker) {
            var self = this;
            marker.addEventListener('mouseout', function() {
                clearTimeout(timer);
                if (options.delay === 0) {
                    rm();
                } else {
                    timer = setTimeout(function () {
                        rm();
                    }, options.delay || 2000);
                }

                function rm() {
                    _map.removeOverlay(marker._infoWindowOverlay);
                    marker._infoWindowOverlay = null;
                    markers.forEach(function(marker){
                        if (marker._infoWindowOverlay) {
                            _map.removeOverlay(marker._infoWindowOverlay);
                        }
                    });
                    markers.length = 0;
                }
            });

            marker.addEventListener('click', function() {
                self.toBounceMarker(marker);
            });
        };

        this.toBounceMarker = (function(){
            //当前跳动的marker
            var bounceMarker = null;

            //让marker跳动3秒
            function toBounceMarker(marker) {
                stopBounce();
                marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
                bounceMarker = marker;
                setTimeout(stopBounce, 3000);
            }

            // 停止当前跳动的marker
            function stopBounce() {
                if (bounceMarker) {
                    bounceMarker.setAnimation(null);
                    bounceMarker = null;
                }
            }

            return toBounceMarker;
        })();
    }


    MapUtils.MapMarkerInfoWindowManager = MapMarkerInfoWindowManager;
    MapUtils.WindowOverlay = WindowOverlay;
})();