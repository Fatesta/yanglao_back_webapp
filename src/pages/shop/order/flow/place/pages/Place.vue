<template>
  <el-container direction="vertical">
    <el-container style="height: 90%">
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
        <data-table
          ref="table"
          url="/api/shop/product/productPage"
          lazy
          :pagination="{pageSize: 50}"
          :height="540"
          :show-header="false"
          style="width:99%;overflow-x: hidden;overflow-y:auto"
        >
          <el-table-column prop="imageFile" width="100">
            <template slot-scope="scope">
              <img :src="scope.row.imageFile" style="height: 50px;width: 80px;border-radius: 4px;" />
            </template>
          </el-table-column>
          <el-table-column prop="name" width="260" show-overflow-tooltip></el-table-column>
          <el-table-column prop="simpleDescription" width="300"
            :formatter="(row) => row.simpleDescription || row.description" show-overflow-tooltip></el-table-column>
          <el-table-column prop="price" width="100" :formatter="formatters.price"></el-table-column>
          <el-table-column align="right" style="right: 16px;">
            <template slot-scope="scope">
              <el-button
                v-show="selections[scope.row.productId]"
                icon="el-icon-remove-outline"
                type="text"
                circle
                style="font-size: 24px;"
                @click="onNumSubtractClick(scope.row)"
              />
              <span
                v-show="selections[scope.row.productId]"
                style="font-size:16px;top:-3px;position:relative;font-weight: bold;">
                {{selections[scope.row.productId] && selections[scope.row.productId].num}}
              </span>
              <el-button
                icon="el-icon-circle-plus"
                type="text"
                circle
                style="font-size: 24px;"
                @click="onNumAddClick(scope.row)"
              />
            </template>
          </el-table-column>
        </data-table>
    </el-container>
    <el-container>
      <el-row type="flex" justify="end"
        style="
          width:100%;
          background-color: #EBEEF5;
        ">
        <el-col :span="6" style="line-height: 60px;">
          <div style="float:right">
            <span>已选择 <span style="font-weight: bold;">{{Object.keys(selections).length}}</span> 种商品</span>
            <el-button
              type="primary"
             
              @click="onNextClick"
              style="margin-left: 8px;margin-right:22px;"
              :disabled="Object.keys(selections).length == 0"
            >下一步</el-button>
          </div>
        </el-col>
      </el-row>
    </el-container>
  </el-container>
</template>


<script>
/* 下单主页 */
export default {
  name: 'place',
  data() {
    return {
      categories: [],
      selections: {},
      searchForm: {
        providerId: this.$params.shop.providerId,
        industryId: this.$params.shop.industryId
      },
      formatters: {
        price: (row, col, val) => '¥ ' + val.toFixed(2)
      }
    };
  },
  methods: {
    onCategoryNodeClick(category) {
      let categoryId = category.categoryId == -1 ? '' : category.categoryId;
      this.$refs.table.query({...this.searchForm, categoryId});
    },
    onNumAddClick(product) {
      const selected = this.selections[product.productId];
      if (selected) {
        selected.num++;
      } else {
        this.$set(this.selections, product.productId, { num: 1, product });
      }
    },
    onNumSubtractClick(product) {
      const selected = this.selections[product.productId];
      if (selected.num > 1) {
        selected.num--;
      } else {
        this.$delete(this.selections, product.productId);
      }
    },
    onNextClick() {
      // 家政订单数量检查
      if (this.$params.shop.industryId == 'housekeeping') {
        let total = 0;
        for (let p in this.selections) {
          total += this.selections[p].num;
          if (total > 1) break;
        }
        if (total > 1) {
          this.$alert('一个家政订单只能包含一个家政服务，请分多次下单');
          return;
        }
      }

      this.placeFollow.next({
        params: {
          selections: Object.values(this.selections)
        }
      });
    }
  },
  async mounted() {
    const ret = await this.axios.get(
      '/api/shop/product/categoryList',
      {
        params: {
          providerId: this.$params.shop.providerId,
          industryId: this.$params.shop.industryId
        }
      });
    this.categories = [{
      categoryId: -1,
      name: '全部',
      children: ret
    }];

    this.$refs.table.query(this.searchForm);
  }
}
</script>
