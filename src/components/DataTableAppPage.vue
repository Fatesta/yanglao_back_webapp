<template>
  <card-page style="min-height: unset;">
    <data-table-app-view>
      <slot></slot>
    </data-table-app-view>
  </card-page>
</template>

<script>
export default {
  name: 'data-table-app-page'
}
</script>
