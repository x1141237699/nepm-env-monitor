<template>
  <el-container class="admin-layout">
    <el-aside width="220px" class="aside">
      <div class="logo">NEPM 管理端</div>
      <el-menu
        :default-active="activeMenu"
        router
        class="side-menu"
        background-color="#e1e8cf"
        text-color="#2c3e2c"
        active-text-color="#2d8f6f"
      >
        <el-menu-item index="/feedback">
          <span>反馈列表</span>
        </el-menu-item>
        <el-menu-item index="/statistics">
          <span>统计看板</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <span class="header-title">东软环保公众监督系统</span>
        <div class="header-right">
          <span class="user-name">{{ authStore.adminInfo?.adminName || '管理员' }}</span>
          <el-button type="danger" link @click="handleLogout">退出</el-button>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const activeMenu = computed(() => {
  if (route.path.startsWith('/feedback')) return '/feedback'
  return route.path
})

function handleLogout() {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.admin-layout { min-height: 100vh; }
.aside {
  background: var(--color-sidebar-bg, #e1e8cf);
  border-right: 1px solid var(--color-card-border, #c5d4a8);
}
.logo {
  height: 56px;
  line-height: 56px;
  text-align: center;
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  background: linear-gradient(135deg, #2d8f6f 0%, #52b788 100%);
  letter-spacing: 1px;
}
.side-menu {
  border-right: none;
  padding: 8px 0;
}
.side-menu :deep(.el-menu-item) {
  margin: 4px 8px;
  border-radius: 6px;
}
.side-menu :deep(.el-menu-item.is-active) {
  background-color: rgba(45, 143, 111, 0.15) !important;
  font-weight: 600;
}
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-bottom: 2px solid var(--color-primary-light, #52b788);
  font-size: 16px;
  box-shadow: 0 1px 4px rgba(45, 143, 111, 0.08);
}
.header-title {
  color: var(--color-primary, #2d8f6f);
  font-weight: 600;
}
.header-right { display: flex; align-items: center; gap: 12px; }
.user-name { color: #606266; font-size: 14px; }
.main {
  background: var(--color-page-bg, #f4f9f6);
  padding: 20px;
}
</style>
