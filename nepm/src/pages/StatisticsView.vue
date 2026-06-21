<template>
  <el-card shadow="never" class="page-card">
    <template #header>
      <span class="card-title">统计看板</span>
    </template>
    <el-empty description="统计看板功能待后续开发" class="empty-box" />
  </el-card>
</template>

<script setup>
</script>

<style scoped>
.page-card {
  border: 1px solid var(--color-card-border, #c5d4a8);
  border-radius: 8px;
}
.page-card :deep(.el-card__header) {
  border-left: 4px solid var(--color-primary, #2d8f6f);
  background: rgba(225, 232, 207, 0.35);
}
.card-title {
  color: var(--color-primary, #2d8f6f);
  font-weight: 600;
}
.empty-box {
  padding: 48px 0;
}
.empty-box :deep(.el-empty__description) {
  color: #52b788;
}
</style>
