<template>
  <div class="page">
    <van-nav-bar title="我的反馈" fixed placeholder class="nav-bar">
      <template #right>
        <span class="nav-action" @click="goNew">提交反馈</span>
      </template>
    </van-nav-bar>

    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-empty v-if="!loading && list.length === 0" description="暂无反馈记录">
        <van-button round type="primary" size="small" @click="goNew">提交第一条反馈</van-button>
      </van-empty>
      <van-cell
        v-for="item in list"
        :key="item.id"
        class="feedback-cell"
        :title="item.gridAddress"
        :label="formatLabel(item)"
      >
        <template #value>
          <van-tag :color="statusColor(item.status)" text-color="#fff">
            {{ statusText(item.status) }}
          </van-tag>
        </template>
      </van-cell>
    </van-pull-refresh>

    <div class="footer-bar">
      <van-button round block type="primary" @click="goNew">提交反馈</van-button>
      <van-button round block plain type="primary" class="logout-btn" @click="logout">退出登录</van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getFeedbackList } from '../api/feedback'
import { clearSupervisorSession, getSupervisorInfo } from '../utils/auth'

const router = useRouter()
const list = ref([])
const loading = ref(false)
const refreshing = ref(false)

const statusMap = {
  0: { text: '待指派', color: '#e6a23c' },
  1: { text: '已指派', color: '#2d8f6f' },
  2: { text: '已确认', color: '#67c23a' },
}

function statusText(status) {
  return statusMap[status]?.text || '未知'
}

function statusColor(status) {
  return statusMap[status]?.color || '#909399'
}

function formatLabel(item) {
  const parts = [item.cityName, item.levelName ? `预估：${item.levelName}` : null]
  if (item.createTime) {
    parts.push(String(item.createTime).slice(0, 16))
  }
  return parts.filter(Boolean).join(' | ')
}

async function loadList() {
  const info = getSupervisorInfo()
  if (!info?.id) return
  loading.value = true
  try {
    list.value = await getFeedbackList(info.id)
  } finally {
    loading.value = false
    refreshing.value = false
  }
}

async function onRefresh() {
  await loadList()
}

function goNew() {
  router.push('/feedback/new')
}

function logout() {
  clearSupervisorSession()
  router.push('/login')
}

onMounted(loadList)
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--color-page-bg, #f4f9f6);
  padding-bottom: 120px;
}
.nav-action {
  color: #fff;
  font-size: 14px;
}
.feedback-cell {
  margin-bottom: 2px;
}
.feedback-cell :deep(.van-cell__title) {
  color: #2c3e2c;
}
.footer-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 16px;
  background: #fff;
  border-top: 1px solid var(--color-card-border, #c5d4a8);
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.logout-btn {
  margin-top: 0;
}
</style>
