var formatters = {
    imageFile: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    imgPath: function(value,rowData,rowIndex) {
        return value == null ? "" :'<img src="' + value + '" width="100%" height="40px" />';
    },
    price: function(value,rowData,rowIndex) {
        return value == null ? "" : value.toString().indexOf(".") == -1 ? value + ".00" : value;
    },
    discountedPrice: function(val, row) {
      return parseFloat(val) == parseFloat(row.price) ? '未打折' : formatters.price(val);  
    },
    description: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgProduct", field: "description"
    }),
    isvalid: function(value,rowData,rowIndex) {
        return {0:"<span style='color:red'>否</span>", 1:"<span style='color:green'>是</span>"}[value];
    }
};