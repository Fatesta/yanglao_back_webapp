<template>
  <div ref="mapContainer"></div>
</template>

<script>
export default {
  mounted() {
    const initMap = () => {
      var map = new BMap.Map(this.$refs.mapContainer);
      this.map = map;
      map.enableScrollWheelZoom(true);
      this.$emit('onInit', this);
    }

    // 加载百度地图api js
    let s = document.createElement('script');
    //s.src = 'https://api.map.baidu.com/api?v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc';
    s.src =
      'https://api.map.baidu.com/getscript?s=1&v=2.0&ak=eG3uGEnyuW1igyG7C9PemZ4LPV6pNCBc&services=&t=' +
      new Date().getTime();
    s.onload = () => {
      initMap();
    };
    this.$refs.mapContainer.appendChild(s);
  }
}
</script>

