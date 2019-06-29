<template>
  <div>
    <el-input
      placeholder="输入名称以搜索"
     
      v-model="filterText"></el-input>
    <el-tree
      ref="tree"
      v-loading="loading"
      :data="orgs"
      show-checkbox
      :props="{
        children: 'children',
        label: 'name'
      }"
      node-key="id"
      :filter-node-method="filterOrg"
      @check="onCheck"
      :v-bind="$attrs"
      style="max-height: 200px;overflow: auto;"
    />
  </div>
</template>


<script>
export default {
  inheritAttrs: false,
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: Object
  },
  data() {
    return {
      filterText: '',
      loading: true,
      orgs: [],
      selectedOrgName: null
    };
  },
  watch: {
    filterText(val) {
      this.$refs.tree.filter(val);
    },
    value(val) {
      this.setValue(val);
    }
  },
  methods: {
    onCheck(node, checkeds) {
      this.$emit('change', checkeds.checkedKeys);
    },
    filterOrg(value, orgs) {
      if (!value) return true;
      return orgs.name.indexOf(value) !== -1;
    },
    setValue(orgIds) {
      if (typeof orgIds == 'string')
        orgIds = orgIds.split(',');
      this.$refs.tree.setCheckedKeys(orgIds);
    },
    clear() {
      this.$refs.tree.setCheckedKeys([]);
      this.$emit('change', []);
    }
  },
  async mounted() {
    const orgs = await this.axios.get('/api/org/listOrg');
    this.orgs = orgs;
    this.loading = false;
  }
}
</script>