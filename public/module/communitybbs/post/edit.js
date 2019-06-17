require(['/lib/ueditor1_4_3_3-utf8-jsp/third-party/zeroclipboard/ZeroClipboard.js'], function (ZeroClipboard) {
   window['ZeroClipboard'] = ZeroClipboard;
   
   var uploadedFile = null;
   
   var editor = UE.getEditor('bbsPostEditor', {
       contentEditable: true,
       elementPathEnabled: false,
       wordCount: false,
       autoHeightEnabled:true,
       autoFloatEnabled: true,
       initialFrameWidth: '100%',
       initialFrameHeight: $(document).height() - 200,
       scaleEnabled:true,
       enableAutoSave: false
   });
   
   editor.addListener('ready', function(){
       var id = $('#bbsPostFormLayout [name=id').val();
       if (id) { //是修改
           get('communitybbs/post/get.do', {id: id}, function(info){
               info.status = 0;
               $('#bbsPostFormLayout #form').form('load', info);
               $('#bbsPostFormLayout #thumbnailImg').attr('src',
                   info.thumbnailUrl ? info.thumbnailUrl.split(',')[0] : '');
               editor.setContent(info.content);              
               if (info.url) {
                   uploadedFile = info;
                   showUploadMsg();
               }              
           });
       }
   });
   
   editor.addListener('focus', function(){
       $('#bbsPostFormLayout #layout').layout('collapse', 'west');
   });
   
   editor.addListener('insertfileBefore', function(cmd, fileList, ret) {
       ret.notInsertHtml = true;
   });
   
   editor.addListener('insertfileAfter', function(cmd, fileList){
       uploadedFile = fileList[0].data;
       uploadedFile.fileName = uploadedFile.original;
       alertInfo('上传成功!');
       showUploadMsg();
   });
   
   function showUploadMsg() {
       var html = '<a href="' + uploadedFile.url + '" target="_blank">' + uploadedFile.fileName + '</a>';
       $('#bbsPostFormLayout #uploadMsg').html('已上传文件: ' + html);
   }
   
   $("#bbsPostFormLayout #save").click(function(){
      var content = editor.getContent();
      
      var fileClass = 0;
      if (uploadedFile && uploadedFile.fileName) {
          $('#bbsPostFormLayout [name=duration]').val(uploadedFile.duration);
          $("#bbsPostFormLayout [name=url]").val(uploadedFile.url);
          $("#bbsPostFormLayout [name=filename]").val(uploadedFile.fileName);
          var filename = uploadedFile.fileName;
          var ext = filename.substring(filename.lastIndexOf('.') + 1);
          var videoExts = ['avi', 'mp4', 'rm', 'rmvb', '3gp', 'mpeg', 'mkv', 'mov'];
          var audioExts = ['cd','ogg','mp3','asf','wma','wav','mp3','aif','midi'];
          if (videoExts.indexOf(ext) > -1)
              fileClass = 1;
          else if (audioExts.indexOf(ext) > -1)
              fileClass = 2;
      }
      
      $("#bbsPostFormLayout [name=fileType]").val(fileClass);
      
      $("#bbsPostFormLayout [name=content]").val(content);
      formSubmit({
         url: 'communitybbs/post/save.do',
         success: function(ret) {
             uploadedFile = null;
             if (ret.success) {
             }
             showOpResultMessage(ret);
         }
      });
   });
   
   $("#bbsPostFormLayout #updateImg").click(function(){
       openUploadImageDialog({
           onSuccess: function(ret) {
               $("#bbsPostFormLayout #thumbnailImg").attr("src", ret.url);
               $("#bbsPostFormLayout [name=thumbnailUrl]").val(ret.url);
           }
       });
   });
});
