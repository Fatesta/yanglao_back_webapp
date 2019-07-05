<template>
  <drawer
    :visible.sync="visible"
    placement="right"
    width="720px"
  >
    <div slot="header" style="padding-left:8px">
      {{title || '选择地址'}}
    </div>
    <div slot="body" style="padding:8px">
      <el-input
        v-model="searchText" 
        placeholder="请输入具体的地址，街道/小区/写字楼 等"
        style="margin-bottom: 8px"
        @change="onSearchTextChange"
        @keyup.enter.native="onSearch(searchText)"
      >
        <el-select slot="prepend"
          v-model="selectedCity"
          size="mini"
          placeholder="请选择城市"
          style="width: 100px"
        >
          <el-option value="武汉市" :label="武汉市"></el-option>
          <el-option value="北京市" :label="北京市"></el-option>
        </el-select>
        <el-button slot="append" icon="el-icon-search" @click="onSearch(searchText)"></el-button>
      </el-input>
      <map-view
        :style="{ width: '100%', height: '400px' }"
        @onInit="onMapInit"
      />

      <ul class="list" v-loading="resultsLoading" style="min-height: 100px;">
        <li
          v-for="item in results.data"
          :key="item.address"
          class="list-item result-item"
          @click="onResultItemClick(item)"
        >
          <div class="list-item__avater" :style="getSelectedStyle(item)">
            <i class="el-icon-location-outline"></i>
          </div>
          <div class="list-item__content">
            <h4 :style="getSelectedStyle(item)">{{item.title}}</h4>
            <div>{{item.address}}</div>
          </div>
        </li>
        <li
          v-if="searchText && resultsLoading === false && !(results.data && results.data.length > 0)"
          style="color: #606266">未查询到 {{searchText}}</li>
      </ul>
    </div>
  </drawer>
</template>

<script>
import Drawer from './Drawer';
import MapView from './MapView';

export default {
  components: {
    Drawer,
    MapView
  },
  props: {
    title: String
  },
  data() {
    return {
      selectedCity: '1',
      results: {},
      resultsLoading: null,
      selected: null,
      visible: false,
      searchText: '',
      cityName: '定位中.',
    };
  },
  methods: {
    show(options) {
      this.visible = true;
      this.options = options;

      const { searchText } = this.options;
      if (searchText) {
        this.searchText = searchText;
        if (this.map) {
          this.search(this.searchText);
        }
      }
    },
    onSearchTextChange(value) {
      clearTimeout(this.timer);
      if (!value) return;
      this.timer = setTimeout(() => {
        this.onSearch(value);
      }, 1000);
    },
    onSearch(value) {
      clearTimeout(this.timer);
      if (!this.map) return;
      this.map.centerAndZoom(this.cityName, 12);
      this.search(value);
    },
    onResultItemClick(item) {
      if (!this.map) return;
      this.selected = item;
      this.options.onSelect(item);

      setTimeout(() => {
        this.addOneMarker(item.point);
      }, 10);
    },
    search(value, onComplete) {
      this.resultsLoading = true;
      new BMap.LocalSearch(this.map, {
        onSearchComplete: bResults => {
          if (!bResults) return;
          let results = [];
          for (let i = 0; i < bResults.getCurrentNumPois(); i++) {
            results.push(bResults.getPoi(i));
          }
          this.resultsLoading = false;
          this.results = { data: results, current: 1 };
          onComplete && onComplete(bResults);
        },
      }).search(value);
    },
    onMapInit({ map }) {
      this.map = map;
      //先根据ip快速定位到当前城市
      new BMap.LocalCity().get(result => {
        var point = new BMap.Point(result.center.lng, result.center.lat);
        map.centerAndZoom(point, result.level);
        this.cityName = result.name;

        this.searchText && this.search(this.searchText);
      });
      const me = this;
      new BMap.Geolocation().getCurrentPosition(function(result) {
        if (this.getStatus() == BMAP_STATUS_SUCCESS) {
          if (result.address.city != me.cityName) {
            map.centerAndZoom(result.address.city);
            this.cityName = result.address.city;

            this.searchText && this.search(this.searchText);
          }
        }
      });
    },
    addOneMarker(point) {
      let map = this.map;
      map.clearOverlays();
      map.addOverlay(new BMap.Marker(point));
      map.panTo(point);
    },
    getSelectedStyle(item) {
      return {
        color: this.selected && this.selected.address == item.address ? '#ed2d2e' : '#606266'
      };
    }
  }
}
</script>

<style scoped>
.list {
  list-style: none;
  padding: 0px;
}

.list > .list-item {
  display: flex;
}
.list > .list-item .list-item__avater {
  margin-right: 16px;
  line-height: 45px;
  color: #606266;
  font-size: 16px;
}
.list > .list-item .list-item__content > h4 {
  margin-block-start: 0px;
  margin-block-end: 0px;
  color: #606266;
  font-size: 14px;
  line-height: 22px;
}
.list > .list-item .list-item__content > div {
  color: #909399;
  line-height: 24px;
}
.result-item {
  padding: 8px;
  cursor: pointer;
}
.result-item:hover {
  cursor: pointer;
  background-color: #eee;
}
</style>


