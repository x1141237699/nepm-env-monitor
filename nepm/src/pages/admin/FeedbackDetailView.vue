<template>
  <el-card v-loading="loading" shadow="never">
    <template #header>
      <div class="header">
        <span>反馈详情</span>
        <el-button @click="router.back()">返回</el-button>
      </div>
    </template>

    <el-descriptions v-if="detail" :column="1" border>
      <el-descriptions-item label="编号">{{ detail.id }}</el-descriptions-item>
      <el-descriptions-item label="反馈人">{{ detail.supervisorName || '-' }}</el-descriptions-item>
      <el-descriptions-item label="联系电话">{{ detail.supervisorPhone || '-' }}</el-descriptions-item>
      <el-descriptions-item label="所属省份">{{ detail.provinceName || '-' }}</el-descriptions-item>
      <el-descriptions-item label="所属城市">{{ detail.cityName || '-' }}</el-descriptions-item>
      <el-descriptions-item label="网格地址">{{ detail.gridAddress || '-' }}</el-descriptions-item>
      <el-descriptions-item label="预估等级">{{ detail.levelName || '-' }}</el-descriptions-item>
      <el-descriptions-item label="反馈描述">{{ detail.feedbackDesc || '-' }}</el-descriptions-item>
      <el-descriptions-item label="反馈日期">{{ formatDate(detail.createTime) }}</el-descriptions-item>
      <el-descriptions-item label="当前状态">{{ statusText(detail.status) }}</el-descriptions-item>
      <el-descriptions-item v-if="detail.memberName" label="指派网格员">{{ detail.memberName }}</el-descriptions-item>
    </el-descriptions>

    <div v-if="detail && detail.status === 0" class="assign-section">
      <el-divider content-position="left">指派网格员</el-divider>

      <el-alert
        v-if="!hasLocalMembers"
        title="本市暂无可用网格员，可启用外省调派"
        type="warning"
        show-icon
        :closable="false"
        class="tip"
      />
      <el-alert
        v-else
        title="已匹配本市在岗网格员，请优先本市指派"
        type="success"
        show-icon
        :closable="false"
        class="tip"
      />

      <div class="assign-actions">
        <el-button
          :type="assignType === 'local' ? 'primary' : 'default'"
          @click="switchToLocal"
        >
          本市指派
        </el-button>
        <el-button
          :type="assignType === 'other' ? 'primary' : 'default'"
          :disabled="hasLocalMembers"
          @click="switchToOther"
        >
          外省调派
        </el-button>
      </div>

      <el-form label-width="100px" class="assign-form">
        <el-form-item label="选择网格员">
          <el-select
            v-model="selectedMemberId"
            placeholder="请选择网格员"
            style="width: 100%"
            :loading="membersLoading"
          >
            <el-option
              v-for="item in memberList"
              :key="item.id"
              :label="`${item.memberName}（${item.provinceName}-${item.cityName}）`"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="submitting" @click="handleAssign">
            确认指派
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </el-card>
</template>

<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  assignGridMember,
  getFeedbackDetail,
  getLocalGridMembers,
  getOtherProvinceGridMembers,
} from '../../api/admin'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const membersLoading = ref(false)
const submitting = ref(false)
const detail = ref(null)
const memberList = ref([])
const selectedMemberId = ref(null)
const hasLocalMembers = ref(true)
const assignType = ref('local')

function formatDate(value) {
  if (!value) return '-'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`
}

function statusText(status) {
  const map = { 0: '待指派', 1: '已指派', 2: '已确认' }
  return map[status] ?? '-'
}

async function fetchDetail() {
  const afId = route.params.afId
  if (!afId) return
  loading.value = true
  try {
    detail.value = await getFeedbackDetail(afId)
    if (detail.value?.status === 0) {
      await loadLocalMembers()
    }
  } finally {
    loading.value = false
  }
}

async function loadLocalMembers() {
  const afId = route.params.afId
  membersLoading.value = true
  try {
    const data = await getLocalGridMembers(afId)
    hasLocalMembers.value = data.hasLocalMembers
    memberList.value = data.members || []
    assignType.value = 'local'
    selectedMemberId.value = memberList.value[0]?.id ?? null
  } finally {
    membersLoading.value = false
  }
}

async function switchToLocal() {
  assignType.value = 'local'
  await loadLocalMembers()
}

async function switchToOther() {
  if (hasLocalMembers.value) return
  assignType.value = 'other'
  membersLoading.value = true
  try {
    const data = await getOtherProvinceGridMembers(route.params.afId)
    memberList.value = data.members || []
    selectedMemberId.value = memberList.value[0]?.id ?? null
  } finally {
    membersLoading.value = false
  }
}

async function handleAssign() {
  if (!selectedMemberId.value) {
    ElMessage.warning('请选择网格员')
    return
  }
  submitting.value = true
  try {
    await assignGridMember(route.params.afId, {
      gridMemberId: selectedMemberId.value,
      assignType: assignType.value,
    })
    ElMessage.success('指派成功')
    await fetchDetail()
  } finally {
    submitting.value = false
  }
}

onMounted(fetchDetail)
watch(() => route.params.afId, fetchDetail)
</script>

<style scoped>
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.assign-section {
  margin-top: 24px;
}
.tip {
  margin-bottom: 16px;
}
.assign-actions {
  margin-bottom: 16px;
}
.assign-form {
  max-width: 520px;
}
</style>
