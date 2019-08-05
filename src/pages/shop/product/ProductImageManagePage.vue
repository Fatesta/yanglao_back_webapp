<template>
  <card-page
    style="width: 400px; margin-left: auto; margin-right: auto"
  >
    <data-table-app-view>
      <div>
    <el-tabs v-model="activeTypeTab" @tab-click="onTypeTabClick">
      <el-tab-pane label="详情图" name="details"></el-tab-pane>
      <el-tab-pane label="轮播图" name="carousel"></el-tab-pane>
    </el-tabs>
    <div style="padding: 8px 0px;">
      <el-upload
        action="/api/util/upload"
        accept="image/*"
        :show-file-list="false"
        :on-success="onUploadSuccess">
        <el-button type="primary" plain>从本地上传</el-button>
      </el-upload>
    </div>
      </div>
    <data-table
      ref="table"
      url="/api/uploadfile/uploadfilePage"
      lazy
      :stripe="false"
    >
      <el-table-column label="序号" width="60">
        <span slot-scope="scope">{{scope.$index + 1}}</span>
      </el-table-column>
      <el-table-column prop="imgPath" label="图片">
        <el-image slot-scope="{row, $index}"
          :src="row.imgPath"
          :preview-src-list="previewSrcs($index)"
          style="width: 100px; height: 80px; border-radius: 4px;"
        />
      </el-table-column>
      <el-table-column label="操作" align="right">
        <template slot-scope="{row}">
          <el-button icon="el-icon-view" type="text" @click="onPreviewClick($event)" />
          <el-button icon="el-icon-arrow-up" type="text" />
          <el-button icon="el-icon-arrow-down" type="text" />
          <el-button icon="el-icon-delete-solid" type="text" @click="onDeleteClick(row)" />
        </template>
      </el-table-column>
    </data-table>
    </data-table-app-view>
  </card-page>
</template>

<script>
export default {
  pageProps: {
    title: '图片管理'
  },
  data() {
    return {
      activeTypeTab: 'details'
    };
  },
  mounted() {
    this.onTypeTabClick();
  },
  methods: {
    query() {
      this.$refs.table.query({
        resourceId: this.$params.product.productId,
        type: {details: 11, carousel: 4}[this.activeTypeTab]
      });
    },
    previewSrcs(index) {
      const srcs = this.$refs.table.tableData.map(row => row.imgPath);
      return srcs.slice(index).concat(srcs.slice(0, index));
    },
    onTypeTabClick(){
      this.query();
    },
    onPreviewClick(e) {
      e.currentTarget.parentElement.parentElement.parentElement.querySelector('img').click()
    },
    async onDeleteClick(row) {
      const ret = await this.$http.post('/api/uploadfile/deleteByFileIds?fileIds=' + row.fileId);
      if (ret.success) {
        this.$message.success('删除成功');
        this.query();
      }
    },
    async onUploadSuccess(response) {
      const file = {
        type: {details: 11, carousel: 4}[this.activeTypeTab],
        resourceId: this.$params.product.productId,
        fileName: response.data.originalFilename,
        imgPath: response.data.url
      };
      const ret = await this.$http.post('/api/uploadfile/insert', file);
      if (ret.success) {
        this.$message.success('增加成功');
        this.query();
      }
    }
  }
}
</script>

<style scoped>
>>> .cell .el-button {
  font-size: 16px;
}
</style>
