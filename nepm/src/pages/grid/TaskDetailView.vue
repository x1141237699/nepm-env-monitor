<template>
  <el-card v-loading="loading" shadow="never">
    <template #header>
      <div class="header">
        <span>任务详情 · 空气质量实测</span>
        <el-button @click="router.back()">返回</el-button>
      </div>
    </template>

    <el-descriptions v-if="task" :column="2" border class="info-block">
      <el-descriptions-item label="网格地址">{{ task.gridAddress }}</el-descriptions-item>
      <el-descriptions-item label="所属城市">{{ task.cityName }}</el-descriptions-item>
      <el-descriptions-item label="监督员">{{ task.supervisorName }}</el-descriptions-item>
      <el-descriptions-item label="预估等级">{{ task.levelName }}</el-descriptions-item>
      <el-descriptions-item label="反馈描述" :span="2">{{ task.feedbackDesc }}</el-descriptions-item>
    </el-descriptions>

    <el-form
      v-if="task && task.status === 1"
      :model="form"
      :rules="rules"
      ref="formRef"
      label-width="100px"
      class="measure-form"
    >
      <el-divider content-position="left">实测数据录入</el-divider>
      <el-form-item label="SO2" prop="so2">
        <el-input v-model="form.so2" type="number" placeholder="μg/m³" @input="recalc" />
      </el-form-item>
      <el-form-item label="CO" prop="co">
        <el-input v-model="form.co" type="number" placeholder="mg/m³" @input="recalc" />
      </el-form-item>
      <el-form-item label="PM2.5" prop="pm25">
        <el-input v-model="form.pm25" type="number" placeholder="μg/m³" @input="recalc" />
      </el-form-item>

      <el-descriptions v-if="result" :column="2" border title="自动计算结果">
        <el-descriptions-item label="SO2等级">{{ result.so2Level }}</el-descriptions-item>
        <el-descriptions-item label="CO等级">{{ result.coLevel }}</el-descriptions-item>
        <el-descriptions-item label="PM2.5等级">{{ result.pm25Level }}</el-descriptions-item>
        <el-descriptions-item label="综合AQI">{{ result.aqi }}</el-descriptions-item>
        <el-descriptions-item label="AQI等级">{{ result.levelName }}</el-descriptions-item>
      </el-descriptions>

      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">提交检测数据</el-button>
      </el-form-item>
    </el-form>

    <el-descriptions v-else-if="task && task.status === 2" :column="2" border title="已提交">
      <el-descriptions-item label="确认AQI">{{ task.confirmAqi }}</el-descriptions-item>
      <el-descriptions-item label="SO2">{{ task.so2Value ?? '-' }}</el-descriptions-item>
      <el-descriptions-item label="CO">{{ task.coValue ?? '-' }}</el-descriptions-item>
      <el-descriptions-item label="PM2.5">{{ task.pm25Value ?? '-' }}</el-descriptions-item>
    </el-descriptions>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getTaskDetail, submitTaskData } from '../../api/grid'
import { useGridAuthStore } from '../../stores/gridAuth'
import { calculateAqi } from '../../utils/aqi'

const route = useRoute()
const router = useRouter()
const gridAuthStore = useGridAuthStore()
const formRef = ref(null)
const task = ref(null)
const result = ref(null)
const loading = ref(false)
const submitting = ref(false)
const form = reactive({ so2: '', co: '', pm25: '' })

const rules = {
  so2: [{ required: true, message: '请输入SO2', trigger: 'blur' }],
  co: [{ required: true, message: '请输入CO', trigger: 'blur' }],
  pm25: [{ required: true, message: '请输入PM2.5', trigger: 'blur' }],
}

function recalc() {
  if (form.so2 && form.co && form.pm25) {
    result.value = calculateAqi(form)
  } else {
    result.value = null
  }
}

async function loadTask() {
  const info = gridAuthStore.gridInfo
  if (!info?.id) return
  loading.value = true
  try {
    task.value = await getTaskDetail(route.params.afId, info.id)
  } finally {
    loading.value = false
  }
}

async function handleSubmit() {
  await formRef.value.validate()
  recalc()
  if (!result.value) {
    ElMessage.warning('请填写完整检测数据')
    return
  }
  submitting.value = true
  try {
    await submitTaskData({
      feedbackId: Number(route.params.afId),
      gridMemberId: gridAuthStore.gridInfo.id,
      so2: Number(form.so2),
      co: Number(form.co),
      pm25: Number(form.pm25),
      confirmAqi: result.value.aqi,
      confirmLevel: result.value.levelId,
    })
    ElMessage.success('提交成功')
    router.push('/grid/tasks')
  } finally {
    submitting.value = false
  }
}

onMounted(loadTask)
watch(() => route.params.afId, loadTask)
</script>

<style scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.info-block {
  margin-bottom: 20px;
}
.measure-form {
  max-width: 560px;
}
</style>
