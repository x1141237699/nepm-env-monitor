<template>
  <div class="page">
    <van-nav-bar title="任务详情" left-arrow fixed placeholder @click-left="router.back()" />

    <van-cell-group v-if="task" inset title="任务信息" class="info-group">
      <van-cell title="网格地址" :value="task.gridAddress" />
      <van-cell title="所属城市" :value="task.cityName" />
      <van-cell title="监督员" :value="task.supervisorName" />
      <van-cell title="预估等级" :value="task.levelName" />
      <van-cell title="反馈描述" :label="task.feedbackDesc" />
    </van-cell-group>

    <van-form v-if="task && task.status === 1" @submit="onSubmit">
      <van-cell-group inset title="实测数据录入" class="form-group">
        <van-field
          v-model="form.so2"
          type="number"
          label="SO2"
          placeholder="μg/m³"
          :rules="[{ required: true, message: '请输入SO2' }]"
          @update:model-value="recalc"
        />
        <van-field
          v-model="form.co"
          type="number"
          label="CO"
          placeholder="mg/m³"
          :rules="[{ required: true, message: '请输入CO' }]"
          @update:model-value="recalc"
        />
        <van-field
          v-model="form.pm25"
          type="number"
          label="PM2.5"
          placeholder="μg/m³"
          :rules="[{ required: true, message: '请输入PM2.5' }]"
          @update:model-value="recalc"
        />
      </van-cell-group>

      <van-cell-group v-if="result" inset title="自动计算结果" class="result-group">
        <van-cell title="SO2等级" :value="result.so2Level" />
        <van-cell title="CO等级" :value="result.coLevel" />
        <van-cell title="PM2.5等级" :value="result.pm25Level" />
        <van-cell title="综合AQI" :value="String(result.aqi)" />
        <van-cell title="AQI等级">
          <template #value>
            <van-tag color="#2d8f6f" text-color="#fff">{{ result.levelName }}</van-tag>
          </template>
        </van-cell>
      </van-cell-group>

      <div class="submit-btn">
        <van-button round block type="primary" native-type="submit" :loading="submitting">
          提交检测数据
        </van-button>
      </div>
    </van-form>

    <van-cell-group v-else-if="task && task.status === 2" inset title="已提交" class="info-group">
      <van-cell title="确认AQI" :value="String(task.confirmAqi)" />
      <van-cell title="SO2" :value="String(task.so2Value ?? '-')" />
      <van-cell title="CO" :value="String(task.coValue ?? '-')" />
      <van-cell title="PM2.5" :value="String(task.pm25Value ?? '-')" />
    </van-cell-group>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getTaskDetail, submitTaskData } from '../api/grid'
import { getGridInfo } from '../utils/auth'
import { calculateAqi } from '../utils/aqi'

const route = useRoute()
const router = useRouter()
const task = ref(null)
const result = ref(null)
const submitting = ref(false)
const form = reactive({ so2: '', co: '', pm25: '' })

function recalc() {
  if (form.so2 && form.co && form.pm25) {
    result.value = calculateAqi(form)
  } else {
    result.value = null
  }
}

async function loadTask() {
  const info = getGridInfo()
  if (!info?.id) return
  task.value = await getTaskDetail(route.params.afId, info.id)
}

async function onSubmit() {
  recalc()
  if (!result.value) {
    showToast('请填写完整检测数据')
    return
  }
  const info = getGridInfo()
  submitting.value = true
  try {
    await submitTaskData({
      feedbackId: Number(route.params.afId),
      gridMemberId: info.id,
      so2: Number(form.so2),
      co: Number(form.co),
      pm25: Number(form.pm25),
      confirmAqi: result.value.aqi,
      confirmLevel: result.value.levelId,
    })
    showToast('提交成功')
    router.push('/tasks')
  } finally {
    submitting.value = false
  }
}

onMounted(loadTask)
watch(() => route.params.afId, loadTask)
</script>

<style scoped>
.page {
  min-height: 100vh;
  padding-bottom: 24px;
  background: var(--color-page-bg, #f4f9f6);
}
.info-group,
.form-group,
.result-group {
  border: 1px solid var(--color-card-border, #c5d4a8);
  margin-top: 12px;
}
.submit-btn { margin: 24px 16px; }
</style>
