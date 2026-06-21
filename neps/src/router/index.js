import { createRouter, createWebHistory } from 'vue-router'
import { isSupervisorLogin } from '../utils/auth'

const routes = [
  { path: '/login', component: () => import('../pages/LoginView.vue') },
  { path: '/register', component: () => import('../pages/RegisterView.vue') },
  { path: '/feedback', component: () => import('../pages/FeedbackListView.vue') },
  { path: '/feedback/new', component: () => import('../pages/SelectGridView.vue') },
  { path: '/feedback/submit', component: () => import('../pages/FeedbackSubmitView.vue') },
  { path: '/', redirect: '/feedback' },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

const publicPaths = ['/login', '/register']

router.beforeEach((to, from, next) => {
  if (publicPaths.includes(to.path)) {
    if (to.path === '/login' && isSupervisorLogin()) {
      next('/feedback')
    } else {
      next()
    }
    return
  }
  if (!isSupervisorLogin()) {
    next('/login')
  } else {
    next()
  }
})

export default router
