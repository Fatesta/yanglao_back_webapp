var CommunityInfo = (function () { 
   var editor = UE.getEditor('infoEditor', {
       contentEditable: true,
       elementPathEnabled: false,
       wordCount: false,
       autoHeightEnabled:true,
       autoFloatEnabled: true,
       initialFrameWidth: '100%',
       initialFrameHeight: 200,
       scaleEnabled:true,
       enableAutoSave: false
   });

   var addressSetting = new AddressSetting();
   var orgIdRequired = false;

   $("#save").click(function(){
      if (orgIdRequired && !$('#form [name=id]').val()) {
          return;
      }
      if(!addressSetting.validate()) {
          return;
      }

      $("[name=serviceContent]").val(editor.getContent());
	   
      formSubmit('#form', {
         url: 'community/save.do',
         success: function(ret) {
             if (ret.success) {
                 showOpResultMessage(ret);
             }
         }
      });
   });
   

   function AddressSetting() {
       var selected = false;//是否选择了一个搜索结果地址
       $('[textboxname=address]').textbox({
           onChange: function(oldValue, newValue) {
               selected = false;
           }
       });
       
       // 创建Map
       var map = new BMap.Map("map");
       map.centerAndZoom(new BMap.Point(116.404, 39.915), 16);
       map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));        
       map.addControl(new BMap.NavigationControl()); 
       map.enableScrollWheelZoom(true);
       var beginnerTimes = 0;
       var local = new BMap.LocalSearch(map, {
           renderOptions: {map: map, panel: "r-result"},
           onMarkersSet: function(results) {
               if(beginnerTimes) return;
               setTimeout(function() {
                   alertInfo('请在搜素结果中选择一个地址');
               }, 300);
               beginnerTimes = 1;
           },
           onInfoHtmlSet: function(poi) {
               setAddressValues(poi);
               selected = true;
           }
       });
       local.disableFirstResultSelection();

       map.addEventListener('click', function(e) {
           if(!(e.overlay instanceof BMap.Marker)) {
               alertInfo('请先搜索一个地址，在搜素结果中选择一个地址');
           }
       });

       $('#searchLocal').click(function() {
           var address = $('[textboxname=address]').textbox('getValue');
           local.search(address);
       });
       
       this.loadAddress = function(poi) {
           if (poi && poi.point.lng && poi.point.lat) {
               map.centerAndZoom(new BMap.Point(poi.point.lng, poi.point.lat), 16);
               setAddressValues(poi);
           } else {
               //定位到当前城市
               new BMap.LocalCity().get(function myFun(result){
                   var point = new BMap.Point(result.center.lng, result.center.lat);
                   map.centerAndZoom(point, result.level);
               });
           }
           selected = true;
       }
       
       this.validate = function() {
           if (!selected) {
               alertInfo('请从地图中选择一个地址');
               return false;
           } else {
               return true;
           }
       }
       
       function setAddressValues(poi) {
           $('[name=latitude]').val(poi ? poi.point.lat : '');
           $('[name=longitude]').val(poi ? poi.point.lng : '');
           if (poi) {
               $('[textboxname=address]').textbox('setValue', poi.address);
           }
       }
   }
   
   var m = {
       loadByOrgId: function(id) {
           if (!editor.isReady) {
               editor.addListener('ready', function(){
                   loadContent(id);
               });
           } else {
               loadContent(id);
           }
           
           function loadContent(id) {
               if (id) {
                   $('#form [name=id]').val(id);
                   get('community/get.do', {id: id}, function(info) {
                       if (info) {
                           $('#form').form('load', info);
                           editor.setContent(info.serviceContent);
                           addressSetting.loadAddress({
                               address: info.address,
                               point: {lat: info.latitude, lng: info.longitude}
                           });
                       } else {
                           m.clear();
                           $('#form [name=id]').val(id);
                       }
                   });
               } else {
                   addressSetting.loadAddress(null);
               }
           }
       },
       clear: function() {
           $('#form').form('clear');
           editor.setContent('');
           addressSetting.loadAddress(null);
       },
       setOrgIdRequiredMode: function(){
           orgIdRequired = true;
       },
       init: function() {
           this.loadByOrgId($('[name=id]').val());
       }
   };
   return m;
})();	