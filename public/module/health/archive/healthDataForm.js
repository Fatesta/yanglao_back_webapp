$('#submit').click(function() {
    formSubmit($('#healthDataForm'), {
        url:"healthDataLoad/save.do",
        success: function(ret){
            showOpResultMessage(ret);
        }
    });
});

$('#back').click(function() {
    closeCurrentModule();
});