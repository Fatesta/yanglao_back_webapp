$(function() {
    var cameraTree = new CameraTree();
    var videoArrayPlayer = new VideoArrayPlayer({
        infoFormatter: function(node) {
            return '社区视频[' + node.text + ']';
        },
        onEnterFullScreen: function() {
            $('#layout').layout('collapse', 'west');
        },
        onExitFullScreen: function() {
            $('#layout').layout('expand', 'west');
        }
    });
    
    cameraTree.setVideoCtrl(videoArrayPlayer);
    videoArrayPlayer.height($('#panelVideo').height() - $('#panelVideo #userInfo').outerHeight());
    $('#panelVideo').panel({onResize: function() {
        videoArrayPlayer.resize();
    }});
    $('#panelVideo').append(videoArrayPlayer);
    videoArrayPlayer.resize();
    
    cameraTree.setVideoCtrl(videoArrayPlayer);
    cameraTree.init();
    cameraTree.signals.selected.add(function(node){
        videoArrayPlayer.play(node.attributes, node);
    });
});