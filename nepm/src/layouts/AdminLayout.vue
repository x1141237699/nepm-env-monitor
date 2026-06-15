<template>
  <el-container class="admin-layout">
    <el-aside width="220px" class="aside">
      <div class="logo">NEPM 管理端</div>
      <el-menu :default-active="activeMenu" router background-color="#304156" text-color="#bfcbd9" active-text-color="#409EFF">
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
        <span>东软环保公众监督系统</span>
        <div class="header-right">
          <span>{{ authStore.adminInfo?.adminName || '管理员' }}</span>
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
.aside { background: #304156; }
.logo {
  height: 56px;
  line-height: 56px;
  text-align: center;
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  background: #263445;
}
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-bottom: 1px solid #ebeef5;
  font-size: 16px;
}
.header-right { display: flex; align-items: center; gap: 12px; }
.main { background: #f0f2f5; padding: 20px; }
</style>
