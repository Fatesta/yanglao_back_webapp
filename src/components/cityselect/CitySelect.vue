<template>
  <el-cascader
    v-model="cascaderValue"
    :options="data"
    :props="{
      children: 'c',
      label: 'n',
      value: 'n'
    }"
    @change="onCascaderValueChange"
    filterable>
  </el-cascader>
</template>


<script>
import data from './data.json';

export default {
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: Object
  },
  data() {
    return {
      cascaderValue: null,
      data: data
    };
  },
  watch: {
    value(val) {
      this.cascaderValue = Object.values(val).filter(Boolean);
    }
  },
  methods: {
    onCascaderValueChange(value) {
      var ret = {
        prov: value[0]
      };
      if (value.length == 2) {
        ret.city = null;
        ret.dist = value[1];
      } else if (value.length == 3) {
        ret.city = value[1];
        ret.dist = value[2];
      } else {
        ret = null;
      }

      this.$emit('change', ret);
    },
    setValue(value) {
      this.cascaderValue = Object.values(value).filter(Boolean);
      this.onCascaderValueChange(this.cascaderValue);
    },
    clear() {
      this.cascaderValue = [];
      this.onCascaderValueChange(this.cascaderValue);
    }
  },
  mounted() {
    this.value && this.setValue(this.value);
  }
}
</script>