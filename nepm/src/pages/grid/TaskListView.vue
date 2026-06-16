<template>
  <el-card shadow="never">
    <template #header>
      <div class="header">
        <span>待检测任务列表</span>
        <el-button type="primary" link @click="loadTasks">刷新</el-button>
      </div>
    </template>
    <el-table v-loading="loading" :data="tasks" stripe border>
      <el-table-column prop="gridAddress" label="网格地址" min-width="200" show-overflow-tooltip />
      <el-table-column prop="cityName" label="城市" width="120" />
      <el-table-column prop="levelName" label="预估等级" width="120" />
      <el-table-column label="状态" width="100">
        <template #default>
          <el-tag type="warning">待检测</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="goDetail(row.id)">进入实测</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-empty v-if="!loading && tasks.length === 0" description="暂无待检测任务" />
  </el-card>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getTaskList } from '../../api/grid'
import { useGridAuthStore } from '../../stores/gridAuth'

const router = useRouter()
const gridAuthStore = useGridAuthStore()
const tasks = ref([])
const loading = ref(false)

async function loadTasks() {
  const id = gridAuthStore.gridInfo?.id
  if (!id) return
  loading.value = true
  try {
    tasks.value = await getTaskList(id)
  } finally {
    loading.value = false
  }
}

function goDetail(afId) {
  router.push(`/grid/tasks/${afId}`)
}

onMounted(loadTasks)
</script>

<style scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
