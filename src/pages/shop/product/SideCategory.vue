<template>
  <el-aside width="200px" style="border-right: 1px solid #EBEEF5">
    <el-tree
      :data="categories"
      node-key="categoryId"
      :default-checked-keys="[-1]"
      :default-expanded-keys="[-1]"
      :props="{
        children: 'children',
        label: 'name'
      }"
      @node-click="onCategoryNodeClick"
    />
  </el-aside>
</template>

<script>
export default {
  props: ['shop'],
  data() {
    return {
      categories: []
    }
  },
  mounted() {
    const ret = await this.axios.get(
      '/api/shop/product/categoryList',
      {
        params: {
          providerId: this.shop.providerId,
          industryId: this.shop.industryId
        }
      });
    this.categories = [{
      categoryId: -1,
      name: '全部',
      children: ret
    }];
  },
  methods: {
    onCategoryNodeClick(node) {
      let categoryId = category.categoryId == -1 ? '' : category.categoryId;
      this.$emit('category-select', categoryId);
    }
  }
}
</script>
