<template>
  <el-card shadow="never">
    <template #header>
      <span>空气质量实测</span>
    </template>
    <el-alert
      title="请从「反馈任务列表」中选择任务，点击「进入实测」开始录入检测数据"
      type="info"
      show-icon
      :closable="false"
    />
    <div v-if="pendingTasks.length" class="task-list">
      <p class="hint">当前待检测任务：</p>
      <el-button
        v-for="item in pendingTasks"
        :key="item.id"
        type="primary"
        plain
        @click="goDetail(item.id)"
      >
        {{ item.gridAddress }}
      </el-button>
    </div>
  </el-card>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getTaskList } from '../../api/grid'
import { useGridAuthStore } from '../../stores/gridAuth'

const router = useRouter()
const gridAuthStore = useGridAuthStore()
const pendingTasks = ref([])

async function loadTasks() {
  const id = gridAuthStore.gridInfo?.id
  if (!id) return
  pendingTasks.value = await getTaskList(id)
}

function goDetail(afId) {
  router.push(`/grid/tasks/${afId}`)
}

onMounted(loadTasks)
</script>

<style scoped>
.task-list {
  margin-top: 20px;
}
.hint {
  margin-bottom: 12px;
  color: #606266;
}
.task-list .el-button {
  margin: 0 8px 8px 0;
}
</style>
