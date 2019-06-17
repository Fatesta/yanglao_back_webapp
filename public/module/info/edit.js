require(['/lib/ueditor1_4_3_3-utf8-jsp/third-party/zeroclipboard/ZeroClipboard.js'], function (ZeroClipboard) {
   window['ZeroClipboard'] = ZeroClipboard;
   
   var uploadedFile = null;
   
   var editor = UE.getEditor('infoEditor', {
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
       var id = $('#infoFormLayout [name=id]').val();
       if (id) { //是修改
           get('info/getJSON.do', {id: id}, function(info){
               info.status = 0;
               $('#infoFormLayout #form').form('load', info);
               $('#infoFormLayout #thumbnailImg').attr('src', info.thumbnailUrl);
               editor.setContent(info.content);
               
               if (info.url) {
                   uploadedFile = info;
                   showUploadMsg();
               }
               
           });
       } else {
           initCategorySelect({required: true, context: '#infoFormLayout'});
       }
   });
   
   editor.addListener('focus', function(){
       $('#infoFormLayout').layout('collapse', 'west');
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
       $('#infoFormLayout #uploadMsg').html('已上传文件: ' + html);
   }
   
   $("#infoFormLayout #save").click(function(){
      if (!$('[name=id').val() && $("#category").combobox("getValue") == '0') {
          alertInfo('请选择分类');
          return;
      }
      
      var content = editor.getContent();
      
      var fileClass = 0;
      if (uploadedFile) {
          $('#infoFormLayout [name=duration]').val(uploadedFile.duration);
          $("#infoFormLayout [name=url]").val(uploadedFile.url);
          $("#infoFormLayout [name=filename]").val(uploadedFile.fileName);
          var filename = uploadedFile.fileName;
          var ext = filename.substring(filename.lastIndexOf('.') + 1);
          var videoExts = ['avi', 'mp4', 'rm', 'rmvb', '3gp', 'mpeg', 'mkv', 'mov'];
          var audioExts = ['cd','ogg','mp3','asf','wma','wav','mp3','aif','midi'];
          if (videoExts.indexOf(ext) > -1)
              fileClass = 1;
          else if (audioExts.indexOf(ext) > -1)
              fileClass = 2;
      }
      
      $("#infoFormLayout [name=fileType]").val(fileClass);
      
      $("#infoFormLayout [name=content]").val(content);
      formSubmit('#infoFormLayout #form', {
         url: 'info/save.do',
         success: function(ret) {
             uploadedFile = null;
             if (ret.success) {
                 if($('#infoFormLayout #syncBbsPost').prop('checked')) {
                     var post = $('#infoFormLayout #form').serializeObject();
                     delete post.category;
                     delete post.childCategory;
                     $.post('communitybbs/post/save.do', post, function() {
                     });
                 }
             }
             showOpResultMessage(ret);
         }
      });
      
   });

   $("#infoFormLayout #updateImg").click(function(){
       openUploadImageDialog({
           onSuccess: function(ret) {
               $("#infoFormLayout #thumbnailImg").attr("src", ret.url);
               $("#infoFormLayout [name=thumbnailUrl]").val(ret.url);
           }
       });
   });
});
