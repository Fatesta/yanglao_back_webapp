require(['/lib/ueditor1_4_3_3-utf8-jsp/third-party/zeroclipboard/ZeroClipboard.js'], function (ZeroClipboard) {
   window['ZeroClipboard'] = ZeroClipboard;
   
   var editor = UE.getEditor('editor', {
       contentEditable: true,
       elementPathEnabled: false,
       wordCount: false,
       autoHeightEnabled:true,
       autoFloatEnabled: true,
       initialFrameWidth: '100%',
       initialFrameHeight: $(document).height(),
       scaleEnabled:true,
       enableAutoSave: false
   });
   
   editor.addListener('ready', function(){
       scanEditorSignals.readyed.dispatch(editor);
   });
   
   editor.addListener('focus', function(){
       $('#layout').layout('collapse', 'west');
   });
});
