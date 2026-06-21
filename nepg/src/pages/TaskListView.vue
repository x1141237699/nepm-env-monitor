<template>
  <div class="page">
    <van-nav-bar title="待检测任务" fixed placeholder class="nav-bar">
      <template #right>
        <span class="logout" @click="logout">退出</span>
      </template>
    </van-nav-bar>

    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-empty v-if="!loading && tasks.length === 0" description="暂无待检测任务" />
      <van-cell
        v-for="item in tasks"
        :key="item.id"
        is-link
        class="task-cell"
        :title="item.gridAddress"
        :label="`${item.cityName || ''} | 预估：${item.levelName || '-'}`"
        @click="goDetail(item.id)"
      >
        <template #value>
          <van-tag color="#2d8f6f" text-color="#fff">待检测</van-tag>
        </template>
      </van-cell>
    </van-pull-refresh>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getTaskList } from '../api/grid'
import { clearGridSession, getGridInfo } from '../utils/auth'

const router = useRouter()
const tasks = ref([])
const loading = ref(false)
const refreshing = ref(false)

async function loadTasks() {
  const info = getGridInfo()
  if (!info?.id) return
  loading.value = true
  try {
    tasks.value = await getTaskList(info.id)
  } finally {
    loading.value = false
    refreshing.value = false
  }
}

async function onRefresh() {
  await loadTasks()
}

function goDetail(afId) {
  router.push(`/tasks/${afId}`)
}

function logout() {
  clearGridSession()
  router.push('/login')
}

onMounted(loadTasks)
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--color-page-bg, #f4f9f6);
}
.logout {
  color: #fff;
  font-size: 14px;
  opacity: 0.95;
}
.task-cell {
  margin-bottom: 2px;
}
.task-cell :deep(.van-cell__title) {
  color: #2c3e2c;
}
</style>
