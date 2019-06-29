var DictMan = (function() {
    var dicts = {};
    var itemMap = {};//项目map缓存
    var items = {};

    return {
        cleanCache: function(onDone) {
            var self = this;
            $.get('/api/dict/cleanCache', function() {
                self.fetch();
                onDone && onDone();
            });
        },
        fetch: function(onSuccess) {
            var self = this;
            $.get('/api/dict/list', function(ret) {
                data = ret.data ? ret.data : ret;
                self.setData(data);
                onSuccess && onSuccess(data);
            });
        },
        setData: function(arr) {
            dicts = {};
            itemMap = {};
            items = {};
            arr.forEach(function(dict) {
                dicts[dict.name] = dict.items;
                itemMap[dict.name] = {};
                items[dict.name] = [];
                dict.items.forEach(function(item) {
                    itemMap[dict.name][item.key] = item.value;
                    items[dict.name].push( {value: item.key, text: item.value} );
                });
            });
        },
        itemMap: function(dictName) {
            return itemMap[dictName] || {};
        },
        items: function(dictName) {
            return items[dictName] || [];
        },
        itemDetailMap: function(dictName) {
            if (typeof dicts[dictName] == 'undefined')
                return {};
            var map = {};
            dicts[dictName].forEach(function(item) {
                map[item.key] = item;
            });
            return map;
        }
    };
})();

/* 以下为旧接口,以后不要使用，逐渐过渡到新方式 */
function Dict(dictItems) {
    if (dictItems.length) {
        this.items = dictItems;
    } else {
        this.items = [];
        for (var p in dictItems) {
            this.items.push(new DictItem(p, dictItems[p]));
        }
    }
}

Dict.prototype.toMap = function() {
    return _.reduce(this.items, function(m, o){
        m[o.value] = o.text;
        return m;
    }, new Object());
}
Dict.prototype.clone = function() {
    return new Dict(this.items);
}
Dict.prototype.include = function(values) {
    var items = this.items.filter(function(item) {
        return values.indexOf(item.value) != -1;
    });
    return new Dict(items);
}
Dict.prototype.getText = function(value) {
    for (var i = 0; i < this.items.length; i++) {
        var item = this.items[i];
        if (item.value == value)
            return item.text;
    }
    return '';
}
/**
@class 字典项
@param value 值
@param text 值描述文本
 */
function DictItem(value, text) {
    this.value = value;
    this.text = text;
}