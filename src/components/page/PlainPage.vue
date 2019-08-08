<template>
  <div
    style="
      margin: 4px 6px 3px 4px;
      padding: 20px,
      min-height: calc(100vh - 112px);
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
