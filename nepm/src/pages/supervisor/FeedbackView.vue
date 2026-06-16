<template>
  <el-card shadow="never">
    <template #header>
      <span>提交 AQI 监督反馈</span>
    </template>
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px" class="feedback-form">
      <el-form-item label="选择省份" prop="provinceId">
        <el-select v-model="form.provinceId" placeholder="请选择省份" style="width:100%" @change="onProvinceChange">
          <el-option v-for="p in PROVINCES" :key="p.id" :label="p.name" :value="p.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="选择城市" prop="cityId">
        <el-select v-model="form.cityId" placeholder="请选择城市" style="width:100%">
          <el-option v-for="c in cityOptions" :key="c.id" :label="c.name" :value="c.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="网格地址" prop="gridAddress">
        <el-input v-model="form.gridAddress" placeholder="如：沈阳市和平区南京街网格" />
      </el-form-item>
      <el-form-item label="预估AQI级别" prop="estimatedLevel">
        <el-select v-model="form.estimatedLevel" placeholder="请选择" style="width:100%">
          <el-option v-for="l in AQI_LEVELS" :key="l.id" :label="l.name" :value="l.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="反馈描述" prop="feedbackDesc">
        <el-input v-model="form.feedbackDesc" type="textarea" :rows="4" placeholder="请描述当前空气质量情况" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">提交反馈</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { submitFeedback } from '../../api/supervisor'
import { useSupervisorAuthStore } from '../../stores/supervisorAuth'
import { AQI_LEVELS, PROVINCES, getCitiesByProvince } from '../../utils/regions'

const supervisorAuthStore = useSupervisorAuthStore()
const formRef = ref(null)
const submitting = ref(false)

const form = reactive({
  provinceId: null,
  cityId: null,
  gridAddress: '',
  estimatedLevel: null,
  feedbackDesc: '',
})

const rules = {
  provinceId: [{ required: true, message: '请选择省份', trigger: 'change' }],
  cityId: [{ required: true, message: '请选择城市', trigger: 'change' }],
  gridAddress: [{ required: true, message: '请输入网格地址', trigger: 'blur' }],
  estimatedLevel: [{ required: true, message: '请选择预估等级', trigger: 'change' }],
  feedbackDesc: [{ required: true, message: '请输入反馈描述', trigger: 'blur' }],
}

const cityOptions = computed(() => getCitiesByProvince(form.provinceId))

function onProvinceChange() {
  form.cityId = null
}

async function handleSubmit() {
  await formRef.value.validate()
  const supervisorId = supervisorAuthStore.supervisorInfo?.id
  if (!supervisorId) {
    ElMessage.warning('请先登录')
    return
  }
  submitting.value = true
  try {
    await submitFeedback({
      supervisorId,
      provinceId: form.provinceId,
      cityId: form.cityId,
      gridAddress: form.gridAddress,
      estimatedLevel: form.estimatedLevel,
      feedbackDesc: form.feedbackDesc,
    })
    ElMessage.success('反馈提交成功')
    form.gridAddress = ''
    form.feedbackDesc = ''
    form.estimatedLevel = null
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.feedback-form {
  max-width: 560px;
}
</style>
