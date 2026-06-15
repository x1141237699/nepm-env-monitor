import { createRouter, createWebHistory } from 'vue-router'
import { isGridLogin } from '../utils/auth'

const routes = [
  { path: '/login', component: () => import('../pages/LoginView.vue') },
  { path: '/tasks', component: () => import('../pages/TaskListView.vue') },
  { path: '/tasks/:afId', component: () => import('../pages/TaskDetailView.vue') },
  { path: '/', redirect: '/tasks' },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  if (to.path !== '/login' && !isGridLogin()) {
    next('/login')
  } else if (to.path === '/login' && isGridLogin()) {
    next('/tasks')
  } else {
    next()
  }
})

export default router
