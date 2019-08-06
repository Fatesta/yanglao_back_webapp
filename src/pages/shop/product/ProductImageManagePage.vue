<template>
  <card-page
    style="width: 450px; margin-left: auto; margin-right: auto"
  >
    <data-table-app-view>
      <div>
        <el-tabs v-model="activeTypeTab" @tab-click="onTypeTabClick">
          <el-tab-pane label="详情图" name="details"></el-tab-pane>
          <el-tab-pane label="轮播图" name="carousel"></el-tab-pane>
          <el-tab-pane label="视频" name="video"></el-tab-pane>
        </el-tabs>
        <div style="padding: 16px 0px 8px 0px;">
          <el-upload
            action="/api/util/upload"
            :accept="{details: 'image/*', carousel: 'image/*', video: 'video/*'}[activeTypeTab]"
            :show-file-list="false"
            :on-progress="function() { uploading = true; }"
            :on-success="onUploadSuccess">
            <el-button type="primary" plain icon="el-icon-plus" :loading="uploading">{{uploading ? '上传中' : '上传'}}</el-button>
          </el-upload>
        </div>
      </div>
      <data-table
        ref="table"
        url="/api/uploadfile/uploadfilePage"
        lazy
        :pagination="{pageSize: 50}"
        :show-header="false"
        :stripe="false"
      >
        <el-table-column width="40">
          <span slot-scope="scope" style="color:#909399">{{scope.$index + 1}}</span>
        </el-table-column>
        <el-table-column prop="imgPath" align="center">
          <template slot-scope="{row, $index}">
            <el-image
              v-if="row.type == 12"
              style="
                width: 100px;
                height: 80px;
                border-radius: 4px;
                line-height: 80px;
                font-size: 32px;
                text-align: center;
                cursor: pointer"
              @click.native="onPreviewClick(null, row)"
            >
              <div slot="error">
                <i class="el-icon-video-play"></i>
              </div>
            </el-image>
            <el-image
              v-else
              :src="row.imgPath"
              :preview-src-list="previewSrcs($index)"
              style="
                width: 100px;
                height: 80px;
                border-radius: 4px;"
            />
          </template>
        </el-table-column>
        <el-table-column align="right">
          <template slot-scope="{row, $index}">
            <el-button icon="el-icon-view" type="text" @click="onPreviewClick($event, row)" />
            <el-button icon="el-icon-arrow-up" type="text" @click="onOrderClick(-1, $index)" />
            <el-button icon="el-icon-arrow-down" type="text" @click="onOrderClick(+1, $index)" />
            <el-button icon="el-icon-delete-solid" type="text" @click="onDeleteClick(row)" />
          </template>
        </el-table-column>
      </data-table>
    </data-table-app-view>

    <video-dialog ref="videoDialog" />
  </card-page>
</template>

<script>
import { enter } from '@/utils/fullscreen.js';

export default {
  pageProps: {
    title: '图片管理'
  },
  components: {
    VideoDialog: () => import('@/components/VideoDialog')
  },
  data() {
    return {
      activeTypeTab: 'details',
      uploading: false
    };
  },
  mounted() {
    this.onTypeTabClick();
  },
  methods: {
    query() {
      this.$refs.table.query({
        resourceId: this.$params.product.productId,
        type: {details: 11, carousel: 4, video: 12}[this.activeTypeTab]
      });
    },
    previewSrcs(index) {
      const srcs = this.$refs.table.tableData.map(row => row.imgPath);
      return srcs.slice(index).concat(srcs.slice(0, index));
    },
    onTypeTabClick(){
      this.query();
    },
    onPreviewClick(event, row) {
      if (this.activeTypeTab == 'video') {
        this.$refs.videoDialog.show({src: row.imgPath});
      } else {
        const rowEl = event.currentTarget.parentElement.parentElement.parentElement;
        rowEl.querySelector('img').click();
      }
    },
    async onOrderClick(dir, index) {
      let rows = this.$refs.table.tableData;
      if ((dir == -1 && index - 1 < 0) || (dir == +1 && index + 1 > rows.length - 1)) {
        this.$message.warning('无法移动');
        return;
      }
      this.$refs.table.loading = true;
      const ret = await this.$http.post('/api/uploadfile/swapOrder', {objId: rows[index].fileId, otherId: rows[index + dir].fileId, dir});
      if (ret.success) {
        rows = [...rows];
        let t = rows[index];
        rows[index] = rows[index + dir];
        rows[index + dir] = t;
        this.$refs.table.tableData = rows;
      }
      this.$refs.table.loading = false;
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
        type: {details: 11, carousel: 4, video: 12}[this.activeTypeTab],
        resourceId: this.$params.product.productId,
        fileName: response.data.originalFilename,
        imgPath: response.data.url
      };

      const ret = await this.$http.post('/api/uploadfile/insert', file);
      if (ret.success) {
        this.$message.success('增加成功');
        this.query();
      }
      this.uploading = false;
    }
  }
}
</script>

<style scoped>
>>> .cell .el-button {
  font-size: 16px;
}
</style>
