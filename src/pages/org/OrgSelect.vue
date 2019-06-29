<template>
  <el-select
    ref="select"
    v-model="selectedOrgName"
    v-bind="attrs"
    clearable
    @clear="onClear"
    style="width:100%"
    >
    <template slot="empty">
      <el-input
        placeholder="输入名称以搜索"
        v-model="filterText"></el-input>
      <el-tree
        ref="tree"
        v-loading="loading"
        :data="orgs"
        :default-checked-keys="[1]"
        :default-expanded-keys="[1]"
        :props="{
          children: 'children',
          label: 'name'
        }"
        node-key="id"
        :filter-node-method="filterOrg"
        @node-click="onOrgClick"
        style="max-height: 200px;overflow: auto;"
      />
    </template>
  </el-select>
</template>


<script>
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
    onOrgClick(org) {
      if (org.isCommunity) {
        this.selectedOrgName = org.name;
        this.$refs.select.blur();
        this.$emit('change', org.id);
      }
    },
    filterOrg(value, orgs) {
      if (!value) return true;
      return orgs.name.indexOf(value) !== -1;
    },
    setValue(value) {
      this.value = value;
      // 根据value参数查询名称并设置
      this.selectedOrgName = queryName(this.orgs, this.value);
      function queryName(orgs, id) {
        for (let org of orgs) {
          if (org.id == id) {
            return org.name;
          }
          let ret = queryName(org.children, id);
          if (ret) {
            return ret;
          }
        }
        return null;
      }
    },
    onClear() {
      this.clear();
      this.$emit('change', null);
    },
    clear() {
      this.value = null;
      this.selectedOrgName = '';
    }
  },
  beforeCreate() {
    const defaults = {
      placeholder: "请选择"
    };
    this.attrs = Object.assign({}, defaults, this.$attrs);
  },
  async mounted() {
    const orgs = await this.axios.get('/api/org/listOrg');
    this.orgs = orgs;
    this.loading = false;

    if (this.value) {
      this.setValue(this.value);
    }
  }
}
</script>