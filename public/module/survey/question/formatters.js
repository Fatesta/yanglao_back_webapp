var formatters = {
    type: function(val) {
        return {0: '<span style="color:DarkBlue">问答</span>', 1: '<span style="color:Chocolate">单选</span>', 2: '<span style="color:Brown">多选</span>'}[val];
    }
}