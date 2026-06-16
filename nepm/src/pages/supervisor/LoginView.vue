<template>
  <div class="login-page">
    <div class="login-box">
      <h2>东软环保公众监督系统</h2>
      <p class="subtitle">公众监督员端</p>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="登录" name="login">
          <el-form :model="loginForm" :rules="loginRules" ref="loginRef" @submit.prevent="handleLogin">
            <el-form-item prop="supervisorCode">
              <el-input v-model="loginForm.supervisorCode" placeholder="监督员账号" prefix-icon="User" size="large" />
            </el-form-item>
            <el-form-item prop="password">
              <el-input v-model="loginForm.password" type="password" placeholder="登录密码" prefix-icon="Lock" size="large" show-password />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="large" style="width:100%" :loading="loading" @click="handleLogin">
                登 录
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="注册" name="register">
          <el-form :model="registerForm" :rules="registerRules" ref="registerRef" @submit.prevent="handleRegister">
            <el-form-item prop="supervisorCode">
              <el-input v-model="registerForm.supervisorCode" placeholder="账号" size="large" />
            </el-form-item>
            <el-form-item prop="supervisorName">
              <el-input v-model="registerForm.supervisorName" placeholder="姓名" size="large" />
            </el-form-item>
            <el-form-item prop="password">
              <el-input v-model="registerForm.password" type="password" placeholder="密码" size="large" show-password />
            </el-form-item>
            <el-form-item prop="phone">
              <el-input v-model="registerForm.phone" placeholder="手机号（可选）" size="large" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="large" style="width:100%" :loading="loading" @click="handleRegister">
                注 册
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useSupervisorAuthStore } from '../../stores/supervisorAuth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const supervisorAuthStore = useSupervisorAuthStore()
const activeTab = ref('login')
const loading = ref(false)
const loginRef = ref(null)
const registerRef = ref(null)

const loginForm = reactive({ supervisorCode: '', password: '' })
const registerForm = reactive({ supervisorCode: '', supervisorName: '', password: '', phone: '' })

const loginRules = {
  supervisorCode: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}
const registerRules = {
  supervisorCode: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  supervisorName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  await loginRef.value.validate()
  loading.value = true
  try {
    await supervisorAuthStore.login(loginForm.supervisorCode, loginForm.password)
    ElMessage.success('登录成功')
    router.push('/supervisor/feedback')
  } finally {
    loading.value = false
  }
}

async function handleRegister() {
  await registerRef.value.validate()
  loading.value = true
  try {
    await supervisorAuthStore.register(registerForm)
    ElMessage.success('注册成功，请登录')
    activeTab.value = 'login'
    loginForm.supervisorCode = registerForm.supervisorCode
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
  background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
}
.login-box {
  width: 420px;
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
}
.login-box h2 {
  text-align: center;
  font-size: 22px;
  color: #303133;
  margin-bottom: 8px;
}
.subtitle {
  text-align: center;
  color: #909399;
  font-size: 14px;
  margin-bottom: 24px;
}
</style>
