<template>
  <div
    style="
      margin: 4px 6px 4px 4px;
      padding: 20px,
      min-height: calc(100vh - 114px);
    "
  >
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'plain-page'
}
</script>
