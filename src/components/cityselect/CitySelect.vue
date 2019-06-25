<template>
  <el-cascader
    v-model="cascaderValue"
    :options="data"
    :props="{
      children: 'c',
      label: 'n',
      value: 'n'
    }"
    @change="onChange"
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
    value: 'Object'
  },
  data() {
    return {
      cascaderValue: null,
      data: data
    };
  },
  methods: {
    onChange(value) {
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
      this.onChange(this.cascaderValue);
    },
    clear() {
      this.cascaderValue = [];
      this.onChange(this.cascaderValue);
    }
  },
  mounted() {
    if (this.value != null) {
      this.setValue(this.value);
    }
  }
}
</script>