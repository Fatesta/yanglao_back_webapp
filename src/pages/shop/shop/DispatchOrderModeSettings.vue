<template>
  <el-dialog
      title="派单模式设置"
      :visible.sync="visible"
      width="400px"
    >
    <div style="margin-bottom: 16px;">{{shop.name}}</div>
    <span>派单</span>
    <el-switch
      v-model="value"
      @change="onChange"
    />
  </el-dialog>
</template>

<script>
import { setTimeout } from 'timers';
export default {
  data() {
    return {
      visible: false,
      shop: {},
      value: null
    };
  },
  methods: {
    show(shop) {
      this.shop = shop;
      this.value = shop.businessMode;
      this.visible = true;
    },
    async onChange(value) {
      const ret = await this.axios.post('/api/shop/pro/businessMode',
        {id: this.shop.id, businessMode: value});
      if (ret.success) {
        this.$message.success(`${value ? '开启' : '关闭'}派单模式成功`);
        setTimeout(() => {
          this.shop.businessMode = value;
          this.visible = false;
        }, 100);
      }
    }
  }
}
</script>

