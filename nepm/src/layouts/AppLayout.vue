<template>
  <el-container class="app-layout">
    <el-aside width="240px" class="aside">
      <div class="logo">东软环保公众监督系统</div>
      <el-menu
        :default-active="activeMenu"
        router
        class="side-menu"
        background-color="#e1e8cf"
        text-color="#303133"
        active-text-color="#1a6fb5"
      >
        <el-menu-item-group title="公众监督员端">
          <el-menu-item index="/supervisor/login">
            <el-icon><User /></el-icon>
            <span>登录 / 注册</span>
          </el-menu-item>
          <el-menu-item index="/supervisor/feedback">
            <el-icon><EditPen /></el-icon>
            <span>空气质量反馈</span>
          </el-menu-item>
        </el-menu-item-group>

        <el-menu-item-group title="网格员端">
          <el-menu-item index="/grid/login">
            <el-icon><Avatar /></el-icon>
            <span>登录</span>
          </el-menu-item>
          <el-menu-item index="/grid/tasks">
            <el-icon><List /></el-icon>
            <span>反馈任务列表</span>
          </el-menu-item>
          <el-menu-item index="/grid/measure">
            <el-icon><DataAnalysis /></el-icon>
            <span>空气质量实测</span>
          </el-menu-item>
        </el-menu-item-group>

        <el-menu-item-group title="管理员端">
          <el-menu-item index="/admin/login">
            <el-icon><UserFilled /></el-icon>
            <span>登录</span>
          </el-menu-item>
          <el-menu-item index="/admin/feedback">
            <el-icon><Document /></el-icon>
            <span>公众监督数据列表</span>
          </el-menu-item>
          <el-menu-item index="/admin/aqi">
            <el-icon><Grid /></el-icon>
            <span>AQI实测数据列表</span>
          </el-menu-item>
          <el-menu-item index="/admin/dashboard">
            <el-icon><Monitor /></el-icon>
            <span>监测大屏</span>
          </el-menu-item>
        </el-menu-item-group>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="header">
        <span>{{ pageTitle }}</span>
        <div v-if="currentUser" class="header-right">
          <span>{{ currentUser }}</span>
          <el-button type="danger" link @click="handleLogout">退出</el-button>
        </div>
      </el-header>
      <el-main :class="['main', { 'main-dashboard': isDashboard }]">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  User, EditPen, Avatar, List, DataAnalysis,
  UserFilled, Document, Grid, Monitor,
} from '@element-plus/icons-vue'
import { useAuthStore } from '../stores/auth'
import { useGridAuthStore } from '../stores/gridAuth'
import { useSupervisorAuthStore } from '../stores/supervisorAuth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const gridAuthStore = useGridAuthStore()
const supervisorAuthStore = useSupervisorAuthStore()

const activeMenu = computed(() => {
  const path = route.path
  if (path.startsWith('/grid/tasks/') && path !== '/grid/tasks') return '/grid/measure'
  if (path.startsWith('/admin/feedback')) return '/admin/feedback'
  return path
})

const isDashboard = computed(() => route.path === '/admin/dashboard')

const pageTitle = computed(() => {
  const map = {
    '/supervisor/feedback': '公众监督员 · 空气质量反馈',
    '/grid/tasks': '网格员 · 反馈任务列表',
    '/grid/measure': '网格员 · 空气质量实测',
    '/admin/feedback': '管理员 · 公众监督数据列表',
    '/admin/aqi': '管理员 · AQI实测数据列表',
    '/admin/dashboard': '管理员 · 监测大屏',
  }
  if (route.path.startsWith('/grid/tasks/')) return '网格员 · 空气质量实测'
  if (route.path.startsWith('/admin/feedback/')) return '管理员 · 反馈详情'
  return map[route.path] || '东软环保公众监督系统'
})

const currentRole = computed(() => route.meta.authRole)

const currentUser = computed(() => {
  if (currentRole.value === 'admin' && authStore.isLogin) {
    return authStore.adminInfo?.adminName || '管理员'
  }
  if (currentRole.value === 'grid' && gridAuthStore.isLogin) {
    return gridAuthStore.gridInfo?.memberName || '网格员'
  }
  if (currentRole.value === 'supervisor' && supervisorAuthStore.isLogin) {
    return supervisorAuthStore.supervisorInfo?.supervisorName || '监督员'
  }
  return ''
})

function handleLogout() {
  if (currentRole.value === 'admin') {
    authStore.logout()
    router.push('/admin/login')
  } else if (currentRole.value === 'grid') {
    gridAuthStore.logout()
    router.push('/grid/login')
  } else if (currentRole.value === 'supervisor') {
    supervisorAuthStore.logout()
    router.push('/supervisor/login')
  }
}
</script>

<style scoped>
.app-layout { min-height: 100vh; }
.aside {
  background: #e1e8cf;
  border-right: 1px solid #c5d4a8;
}
.logo {
  height: 56px;
  line-height: 56px;
  text-align: center;
  color: #303133;
  font-size: 14px;
  font-weight: 600;
  background: #d4dfc0;
  padding: 0 8px;
}
.side-menu {
  border-right: none;
}
.side-menu :deep(.el-menu-item-group__title) {
  color: #606266;
  font-weight: 600;
  font-size: 13px;
  padding-top: 12px;
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
.main {
  background: #f0f2f5;
  padding: 20px;
}
.main-dashboard {
  padding: 0;
  background: #030b16;
}
</style>
