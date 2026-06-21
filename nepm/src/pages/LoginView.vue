<template>
  <div class="login-page">
    <div class="login-box">
      <h2>东软环保公众监督系统</h2>
      <p class="subtitle">系统管理员端</p>
      <el-form :model="form" :rules="rules" ref="formRef" @submit.prevent="handleLogin">
        <el-form-item prop="adminCode">
          <el-input v-model="form.adminCode" placeholder="管理员账号" prefix-icon="User" size="large" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="登录密码" prefix-icon="Lock" size="large" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" style="width:100%" :loading="loading" @click="handleLogin">
            登 录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const formRef = ref(null)
const loading = ref(false)

const form = reactive({
  adminCode: '',
  password: '',
})

const rules = {
  adminCode: [{ required: true, message: '请输入管理员账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  await formRef.value.validate()
  loading.value = true
  try {
    await authStore.login(form.adminCode, form.password)
    ElMessage.success('登录成功')
    router.push('/feedback')
  } catch (e) {
    // error handled by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #43cea2 0%, #2d6a4f 100%);
}
.login-box {
  width: 420px;
  background: #fff;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 12px 40px rgba(45, 143, 111, 0.25);
  border: 1px solid rgba(197, 212, 168, 0.6);
}
.login-box h2 {
  text-align: center;
  font-size: 22px;
  color: #2d8f6f;
  margin-bottom: 8px;
}
.subtitle {
  text-align: center;
  color: #52b788;
  font-size: 14px;
  margin-bottom: 32px;
}
</style>
