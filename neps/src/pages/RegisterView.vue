<template>
  <div class="register-page">
    <van-nav-bar title="公众监督员注册" left-arrow @click-left="router.back()" />
    <van-form @submit="onSubmit">
      <van-cell-group inset class="form-group">
        <van-field
          v-model="form.supervisorCode"
          name="supervisorCode"
          label="账号"
          placeholder="请输入账号"
          :rules="[{ required: true, message: '请输入账号' }]"
        />
        <van-field
          v-model="form.supervisorName"
          name="supervisorName"
          label="姓名"
          placeholder="请输入姓名"
        />
        <van-field
          v-model="form.phone"
          name="phone"
          label="手机号"
          placeholder="请输入手机号"
        />
        <van-field
          v-model="form.password"
          type="password"
          name="password"
          label="密码"
          placeholder="请输入密码"
          :rules="[{ required: true, message: '请输入密码' }]"
        />
        <van-field
          v-model="confirmPassword"
          type="password"
          name="confirmPassword"
          label="确认密码"
          placeholder="请再次输入密码"
          :rules="[{ validator: validateConfirm, message: '两次密码不一致' }]"
        />
      </van-cell-group>
      <div class="submit-btn">
        <van-button round block type="primary" native-type="submit" :loading="loading">
          注册
        </van-button>
      </div>
    </van-form>
    <p class="login-link">
      已有账号？
      <router-link to="/login">去登录</router-link>
    </p>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { supervisorRegister } from '../api/auth'

const router = useRouter()
const loading = ref(false)
const confirmPassword = ref('')
const form = reactive({
  supervisorCode: '',
  supervisorName: '',
  phone: '',
  password: '',
})

function validateConfirm(val) {
  return val === form.password
}

async function onSubmit() {
  loading.value = true
  try {
    await supervisorRegister(form)
    showToast('注册成功，请登录')
    router.push('/login')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.register-page {
  min-height: 100vh;
  background: var(--color-page-bg, #f4f9f6);
}
.form-group {
  margin-top: 16px;
  border: 1px solid var(--color-card-border, #c5d4a8);
  overflow: hidden;
}
.submit-btn { margin: 24px 16px; }
.login-link {
  text-align: center;
  margin-top: 16px;
  font-size: 14px;
  color: #5a6b5a;
}
.login-link a {
  color: var(--color-primary, #2d8f6f);
  text-decoration: none;
  font-weight: 500;
}
</style>
