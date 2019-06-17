require(['/lib/ueditor1_4_3_3-utf8-jsp/third-party/zeroclipboard/ZeroClipboard.js'], function(ZeroClipboard) {
	window['ZeroClipboard'] = ZeroClipboard;

	var editor = UE.getEditor('bbsPostEditor', {
		contentEditable : true,
		elementPathEnabled : false,
		wordCount : false,
		autoHeightEnabled : true,
		autoFloatEnabled : true,
		initialFrameWidth : '100%',
		initialFrameHeight : $(document).height() - 100,
		scaleEnabled : true,
		enableAutoSave : false
	});

	editor.addListener('ready', function() {
		var activityId = $('#bbsPostFormLayout [name=activityId').val();
		if (activityId) { // 是修改
			get('activity/getByReview.do', {
				activityId : activityId
			}, function(info) {
				editor.setContent(info.content);
			});
		}
	});

	$("#bbsPostFormLayout #save").click(function() {
		var content = editor.getContent();
		$("#bbsPostFormLayout [name=content]").val(content);
		formSubmit({
			url : 'activity/saveReview.do',
			success : function(ret) {
				showOpResultMessage(ret);				
			}
		});
	});
});
