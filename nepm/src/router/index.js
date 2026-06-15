import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../pages/LoginView.vue'),
  },
  {
    path: '/',
    component: () => import('../layouts/AdminLayout.vue'),
    redirect: '/feedback',
    children: [
      {
        path: 'feedback',
        name: 'FeedbackList',
        component: () => import('../pages/FeedbackListView.vue'),
      },
      {
        path: 'feedback/:afId',
        name: 'FeedbackDetail',
        component: () => import('../pages/FeedbackDetailView.vue'),
      },
      {
        path: 'statistics',
        name: 'Statistics',
        component: () => import('../pages/StatisticsView.vue'),
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  if (to.path !== '/login' && !authStore.isLogin) {
    next('/login')
  } else if (to.path === '/login' && authStore.isLogin) {
    next('/feedback')
  } else {
    next()
  }
})

export default router
