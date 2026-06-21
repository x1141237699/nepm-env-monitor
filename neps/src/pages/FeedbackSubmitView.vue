<template>
  <div class="page">
    <van-nav-bar title="提交AQI监督反馈" left-arrow fixed placeholder @click-left="router.back()" />

    <van-cell-group inset class="info-group">
      <van-cell title="网格地址" :value="gridAddress" />
      <van-cell title="所属区域" :value="`${provinceName} ${cityName}`" />
    </van-cell-group>

    <van-form @submit="onSubmit">
      <van-cell-group inset class="form-group">
        <van-cell title="预估AQI级别" />
        <van-radio-group v-model="estimatedLevel" class="level-group">
          <van-radio
            v-for="level in aqiLevels"
            :key="level.id"
            :name="level.id"
            class="level-radio"
          >
            {{ level.levelName }}
          </van-radio>
        </van-radio-group>
        <van-field
          v-model="feedbackDesc"
          rows="4"
          autosize
          type="textarea"
          label="反馈描述"
          placeholder="请描述当前空气质量情况"
          :rules="[{ required: true, message: '请填写反馈描述' }]"
        />
      </van-cell-group>
      <div class="submit-btn">
        <van-button round block type="primary" native-type="submit" :loading="loading">
          提交反馈
        </van-button>
      </div>
    </van-form>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getAqiLevels } from '../api/common'
import { submitFeedback } from '../api/feedback'
import { getSupervisorInfo } from '../utils/auth'

const route = useRoute()
const router = useRouter()

const aqiLevels = ref([])
const estimatedLevel = ref(null)
const feedbackDesc = ref('')
const loading = ref(false)

const provinceId = computed(() => Number(route.query.provinceId))
const cityId = computed(() => Number(route.query.cityId))
const provinceName = computed(() => route.query.provinceName || '')
const cityName = computed(() => route.query.cityName || '')
const gridAddress = computed(() => route.query.gridAddress || '')

async function loadLevels() {
  aqiLevels.value = await getAqiLevels()
  if (aqiLevels.value.length > 0) {
    estimatedLevel.value = aqiLevels.value[2]?.id ?? aqiLevels.value[0].id
  }
}

async function onSubmit() {
  if (!provinceId.value || !cityId.value || !gridAddress.value) {
    showToast('请先选择网格地址')
    router.replace('/feedback/new')
    return
  }
  if (!estimatedLevel.value) {
    showToast('请选择预估AQI级别')
    return
  }
  const info = getSupervisorInfo()
  if (!info?.id) {
    showToast('请先登录')
    router.push('/login')
    return
  }
  loading.value = true
  try {
    await submitFeedback({
      supervisorId: info.id,
      provinceId: provinceId.value,
      cityId: cityId.value,
      gridAddress: gridAddress.value,
      estimatedLevel: estimatedLevel.value,
      feedbackDesc: feedbackDesc.value,
    })
    showToast('提交成功')
    router.replace('/feedback')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  if (!gridAddress.value) {
    showToast('请先选择网格')
    router.replace('/feedback/new')
    return
  }
  loadLevels()
})
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--color-page-bg, #f4f9f6);
}
.info-group,
.form-group {
  margin-top: 12px;
  border: 1px solid var(--color-card-border, #c5d4a8);
  overflow: hidden;
}
.level-group {
  padding: 8px 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.level-radio {
  font-size: 14px;
  color: #2c3e2c;
}
.submit-btn {
  margin: 24px 16px;
}
</style>
