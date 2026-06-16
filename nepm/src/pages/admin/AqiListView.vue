<template>
  <el-card shadow="never">
    <template #header>
      <span>AQI 实测数据列表</span>
    </template>
    <el-table v-loading="loading" :data="tableData" stripe border>
      <el-table-column prop="id" label="编号" width="80" />
      <el-table-column prop="gridAddress" label="网格地址" min-width="180" show-overflow-tooltip />
      <el-table-column prop="memberName" label="网格员" width="120" />
      <el-table-column prop="so2Value" label="SO2" width="90" />
      <el-table-column prop="coValue" label="CO" width="90" />
      <el-table-column prop="pm25Value" label="PM2.5" width="100" />
      <el-table-column prop="confirmAqi" label="综合AQI" width="100" />
      <el-table-column label="确认时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.confirmTime) }}
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
import { getFeedbackPage } from '../../api/admin'

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
    const records = (data.records || []).filter(
      (row) => row.status === 2 && row.confirmAqi != null
    )
    tableData.value = records
    total.value = records.length
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<style scoped>
.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}
</style>
