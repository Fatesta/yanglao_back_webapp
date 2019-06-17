// 省市区选择器
function CitySelect(options) {
    var cmbProv = $(options.prov);
    var cmbCity = $(options.city);
    var cmbDist = $(options.dist);
    var provArray, cityArray, distArray;
    
    cmbProv.combobox({
        url: CONFIG.libPath+ 'json/prov.json',
        valueField: options.valueField,
        textField: options.textField,
        editable: false,
        onSelect: cmbProvOnSelect,
        onLoadSuccess: function(data) {
            provArray = provArray || data;
        }
    });
    cmbCity.combobox({
        url: CONFIG.libPath+ 'json/city.json',
        valueField: options.valueField,
        textField: options.textField,
        editable: false,
        disabled: !cmbCity.val(),
        onSelect: cmbCityOnSelect,
        onLoadSuccess: function(data) {
            cityArray = cityArray || data;
        }
    });
    cmbDist.combobox({
        url: CONFIG.libPath+ 'json/dist.json',
        valueField: options.valueField,
        textField: options.textField,
        editable: false,
        disabled: !cmbDist.val(),
        onLoadSuccess: function(data) {
            distArray = distArray || data;
        }
    });
    
    function cmbProvOnSelect(value) {
        cmbDist.combobox("disable").combobox("clear").combobox("loadData", []);
    
    var arr = cityArray.filter(function(c){ return c.provId === value.id; });
    cmbCity.combobox("enable").combobox("loadData", arr);
    cmbCity.combobox("setValue", arr[0][options.valueField]);
    cmbCityOnSelect({id: arr[0].id});
    
    if(value.type == "self")
    cmbCity.combobox("disable").combobox("clear").combobox("loadData", []);
    }
    
    function cmbCityOnSelect(value) {
        var arr = distArray.filter(function(d){
            return d.cityId === value.id;
        });
        if(arr.length > 0) {
            cmbDist.combobox("enable").combobox("loadData", arr);
            cmbDist.combobox("setValue", arr[0][options.valueField]);
        }
   }
}