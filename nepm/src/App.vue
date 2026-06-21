<template>
  <router-view />
</template>

<script setup>
</script>

<style>
:root {
  --color-primary: #2d8f6f;
  --color-primary-light: #52b788;
  --color-sidebar-bg: #e1e8cf;
  --color-sidebar-text: #2c3e2c;
  --color-page-bg: #f4f9f6;
  --color-card-border: #c5d4a8;

  --el-color-primary: #2d8f6f;
  --el-color-primary-light-3: #52b788;
  --el-color-primary-light-5: #7ec8a0;
  --el-color-primary-light-7: #a8dbbe;
  --el-color-primary-light-8: #c0e6d0;
  --el-color-primary-light-9: #d8f0e4;
  --el-color-primary-dark-2: #247358;
}

* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
  background: var(--color-page-bg);
  color: #2c3e2c;
}
</style>
