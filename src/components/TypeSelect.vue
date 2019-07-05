<template>
  <el-select
    v-bind="attrs"
    v-model="value"
    @change="$emit('change', $event)"
  >
    <el-option
      v-for="item in items"
      :key="item.value"
      :label="item.text"
      :value="item.value"
    />
  </el-select>
</template>


<script>
export default {
  name: 'type-select',
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: [Object, String],
    items: {
      type: Array //[{text, value}...]
    },
  },
  beforeCreate() {
    const defaults = {
      clearable: true
    };
    this.attrs = Object.assign({}, defaults, this.$attrs);
  }
}
</script>