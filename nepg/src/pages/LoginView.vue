<template>
  <div class="login-page">
    <div class="login-header">
      <h2>NEPG 网格员端</h2>
      <p>东软环保公众监督系统</p>
    </div>
    <van-form @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="form.memberCode"
          name="memberCode"
          label="账号"
          placeholder="请输入网格员账号"
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
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { gridLogin } from '../api/grid'
import { saveGridSession } from '../utils/auth'

const router = useRouter()
const loading = ref(false)
const form = reactive({ memberCode: 'grid001', password: '123456' })

async function onSubmit() {
  loading.value = true
  try {
    const data = await gridLogin(form)
    saveGridSession(data)
    showToast('登录成功')
    router.push('/tasks')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page { min-height: 100vh; padding: 48px 16px; background: linear-gradient(180deg, #1989fa 0%, #f7f8fa 40%); }
.login-header { text-align: center; color: #fff; margin-bottom: 32px; }
.login-header h2 { font-size: 24px; margin-bottom: 8px; }
.login-header p { font-size: 14px; opacity: 0.9; }
.login-btn { margin: 24px 16px; }
</style>
