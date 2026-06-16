import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useGridAuthStore } from '../stores/gridAuth'
import { useSupervisorAuthStore } from '../stores/supervisorAuth'

const routes = [
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('../pages/admin/LoginView.vue'),
    meta: { guestRole: 'admin' },
  },
  {
    path: '/grid/login',
    name: 'GridLogin',
    component: () => import('../pages/grid/LoginView.vue'),
    meta: { guestRole: 'grid' },
  },
  {
    path: '/supervisor/login',
    name: 'SupervisorLogin',
    component: () => import('../pages/supervisor/LoginView.vue'),
    meta: { guestRole: 'supervisor' },
  },
  {
    path: '/',
    component: () => import('../layouts/AppLayout.vue'),
    redirect: '/admin/feedback',
    children: [
      {
        path: 'supervisor/feedback',
        name: 'SupervisorFeedback',
        component: () => import('../pages/supervisor/FeedbackView.vue'),
        meta: { authRole: 'supervisor' },
      },
      {
        path: 'grid/tasks',
        name: 'GridTaskList',
        component: () => import('../pages/grid/TaskListView.vue'),
        meta: { authRole: 'grid' },
      },
      {
        path: 'grid/measure',
        name: 'GridMeasure',
        component: () => import('../pages/grid/MeasureView.vue'),
        meta: { authRole: 'grid' },
      },
      {
        path: 'grid/tasks/:afId',
        name: 'GridTaskDetail',
        component: () => import('../pages/grid/TaskDetailView.vue'),
        meta: { authRole: 'grid' },
      },
      {
        path: 'admin/feedback',
        name: 'AdminFeedbackList',
        component: () => import('../pages/admin/FeedbackListView.vue'),
        meta: { authRole: 'admin' },
      },
      {
        path: 'admin/feedback/:afId',
        name: 'AdminFeedbackDetail',
        component: () => import('../pages/admin/FeedbackDetailView.vue'),
        meta: { authRole: 'admin' },
      },
      {
        path: 'admin/aqi',
        name: 'AdminAqiList',
        component: () => import('../pages/admin/AqiListView.vue'),
        meta: { authRole: 'admin' },
      },
      {
        path: 'admin/dashboard',
        name: 'AdminDashboard',
        component: () => import('../pages/admin/DashboardView.vue'),
        meta: { authRole: 'admin' },
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

const loginMap = {
  admin: '/admin/login',
  grid: '/grid/login',
  supervisor: '/supervisor/login',
}

const homeMap = {
  admin: '/admin/feedback',
  grid: '/grid/tasks',
  supervisor: '/supervisor/feedback',
}

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  const gridAuthStore = useGridAuthStore()
  const supervisorAuthStore = useSupervisorAuthStore()

  const guestRole = to.meta.guestRole
  if (guestRole) {
    const loggedIn = {
      admin: authStore.isLogin,
      grid: gridAuthStore.isLogin,
      supervisor: supervisorAuthStore.isLogin,
    }[guestRole]
    if (loggedIn) return next(homeMap[guestRole])
    return next()
  }

  const role = to.meta.authRole
  if (!role) return next()

  const isAuthed = {
    admin: authStore.isLogin,
    grid: gridAuthStore.isLogin,
    supervisor: supervisorAuthStore.isLogin,
  }[role]

  if (!isAuthed) return next(loginMap[role])
  next()
})

export default router
