<template>
  <div class="login-page">
    <div class="login-box">
      <h2>东软环保公众监督系统</h2>
      <p class="subtitle">网格员端</p>
      <el-form :model="form" :rules="rules" ref="formRef" @submit.prevent="handleLogin">
        <el-form-item prop="memberCode">
          <el-input v-model="form.memberCode" placeholder="网格员账号" prefix-icon="User" size="large" />
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
import { useGridAuthStore } from '../../stores/gridAuth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const gridAuthStore = useGridAuthStore()
const formRef = ref(null)
const loading = ref(false)

const form = reactive({
  memberCode: 'grid001',
  password: '123456',
})

const rules = {
  memberCode: [{ required: true, message: '请输入网格员账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  await formRef.value.validate()
  loading.value = true
  try {
    await gridAuthStore.login(form.memberCode, form.password)
    ElMessage.success('登录成功')
    router.push('/grid/tasks')
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
  background: linear-gradient(135deg, #1989fa 0%, #64b5f6 100%);
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
  margin-bottom: 32px;
}
</style>
