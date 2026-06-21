<template>
  <div class="login-page">
    <div class="login-header">
      <h2>NEPS 公众监督员端</h2>
      <p>东软环保公众监督系统</p>
    </div>
    <van-form @submit="onSubmit">
      <van-cell-group inset class="form-group">
        <van-field
          v-model="form.supervisorCode"
          name="supervisorCode"
          label="账号"
          placeholder="请输入监督员账号"
          :rules="[{ required: true, message: '请输入账号' }]"
        />
        <van-field
          v-model="form.password"
          type="password"
          name="password"
          label="密码"
          placeholder="请输入密码"
          :rules="[{ required: true, message: '请输入密码' }]"
        />
      </van-cell-group>
      <div class="login-btn">
        <van-button round block type="primary" native-type="submit" :loading="loading">
          登录
        </van-button>
      </div>
    </van-form>
    <p class="register-link">
      没有账号？
      <router-link to="/register">去注册</router-link>
    </p>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { supervisorLogin } from '../api/auth'
import { saveSupervisorSession } from '../utils/auth'

const router = useRouter()
const loading = ref(false)
const form = reactive({ supervisorCode: 'supervisor1', password: '123456' })

async function onSubmit() {
  loading.value = true
  try {
    const data = await supervisorLogin(form)
    saveSupervisorSession(data)
    showToast('登录成功')
    router.push('/feedback')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  padding: 48px 16px;
  background: linear-gradient(180deg, #43cea2 0%, #2d6a4f 35%, #f4f9f6 55%);
}
.login-header {
  text-align: center;
  color: #fff;
  margin-bottom: 32px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}
.login-header h2 { font-size: 24px; margin-bottom: 8px; }
.login-header p { font-size: 14px; opacity: 0.95; }
.form-group {
  border: 1px solid var(--color-card-border, #c5d4a8);
  overflow: hidden;
}
.login-btn { margin: 24px 16px; }
.register-link {
  text-align: center;
  margin-top: 16px;
  font-size: 14px;
  color: #5a6b5a;
}
.register-link a {
  color: var(--color-primary, #2d8f6f);
  text-decoration: none;
  font-weight: 500;
}
</style>
