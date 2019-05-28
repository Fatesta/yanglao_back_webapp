<template>
  <el-button type="primary" @click="onSearchClick">查询</el-button>
</template>

<script>
export default {
  props: {
    queryParams: Object,
    dataTable: {
      required: true,
      validator(value) {
        console.log(value)
        return true;
      }
    }
  },
  methods: {
    onSearchClick() {
      this.dataTable.query(this.queryParams);
    }
  }
}
</script>