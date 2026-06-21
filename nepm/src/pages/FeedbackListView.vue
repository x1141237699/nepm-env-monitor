<template>
  <el-card shadow="never" class="page-card">
    <template #header>
      <span class="card-title">公众监督反馈列表</span>
    </template>
    <el-table v-loading="loading" :data="tableData" stripe border>
      <el-table-column prop="id" label="编号" width="80" />
      <el-table-column prop="supervisorName" label="监督员" width="120" />
      <el-table-column prop="cityName" label="城市" width="120" />
      <el-table-column prop="gridAddress" label="地址" min-width="200" show-overflow-tooltip />
      <el-table-column prop="levelName" label="预估等级" width="120" />
      <el-table-column label="反馈日期" width="180">
        <template #default="{ row }">
          {{ formatDate(row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="goDetail(row.id)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pagination">
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[5, 10, 20]"
        layout="total, sizes, prev, pager, next"
        background
        @size-change="fetchData"
        @current-change="fetchData"
      />
    </div>
  </el-card>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getFeedbackPage } from '../api/admin'

const router = useRouter()
const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

function formatDate(value) {
  if (!value) return '-'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  const pad = (n) => String(n).padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`
}

async function fetchData() {
  loading.value = true
  try {
    const data = await getFeedbackPage({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
    })
    tableData.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}

function goDetail(afId) {
  router.push(`/feedback/${afId}`)
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.page-card {
  border: 1px solid var(--color-card-border, #c5d4a8);
  border-radius: 8px;
}
.page-card :deep(.el-card__header) {
  border-left: 4px solid var(--color-primary, #2d8f6f);
  background: rgba(225, 232, 207, 0.35);
}
.card-title {
  color: var(--color-primary, #2d8f6f);
  font-weight: 600;
}
.page-card :deep(.el-table th) {
  background: rgba(225, 232, 207, 0.5) !important;
  color: #2c3e2c;
}
.page-card :deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background: rgba(244, 249, 246, 0.8);
}
.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}
</style>
