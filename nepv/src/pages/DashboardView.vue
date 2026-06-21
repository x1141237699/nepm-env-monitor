<template>
  <div class="dashboard">
    <header class="title">东软空气质量环保公众监督平台</header>

    <div class="content">
      <section class="left-panel">
        <div class="panel-box gauges">
          <div class="gauge-item">
            <div ref="gauge1Ref" class="mini-chart"></div>
            <p>平均AQI</p>
          </div>
          <div class="gauge-item">
            <div ref="gauge2Ref" class="mini-chart"></div>
            <p>待处理</p>
          </div>
        </div>
        <div class="panel-box">
          <div ref="pieRef" class="chart-block"></div>
        </div>
        <div class="panel-box">
          <div ref="lineRef" class="chart-block"></div>
        </div>
      </section>

      <section class="center-panel">
        <div class="map-placeholder">
          <h3>全国网格监测分布</h3>
          <div ref="mapChartRef" class="map-chart"></div>
        </div>
        <div class="summary-bar">
          <span>反馈总数 {{ summary.totalFeedback ?? 0 }}</span>
          <span>待指派 {{ summary.pendingCount ?? 0 }}</span>
          <span>已确认 {{ summary.confirmedCount ?? 0 }}</span>
          <span class="refresh-tip">每 5 秒自动刷新</span>
        </div>
      </section>

      <section class="right-panel">
        <div class="panel-box chart-wrap">
          <BarChart
            title="PM2.5 累计超标次数"
            :x-data="pm25X"
            :y-data="pm25Y"
            color="#52b788"
          />
        </div>
        <div class="panel-box chart-wrap">
          <BarChart
            title="SO2 累计超标次数"
            :x-data="so2X"
            :y-data="so2Y"
            color="#7ec8a0"
          />
        </div>
        <div class="panel-box chart-wrap">
          <BarChart
            title="CO 累计超标次数"
            :x-data="coX"
            :y-data="coY"
            color="#2d8f6f"
          />
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import BarChart from '../components/BarChart.vue'
import { getDashboardData } from '../api/statistics'

const POLL_INTERVAL = 5000

const summary = ref({})
const pm25List = ref([])
const so2List = ref([])
const coList = ref([])
const aqiDistribution = ref([])
const monthlyTrend = ref([])

const pm25X = computed(() => pm25List.value.map((i) => i.provinceCode))
const pm25Y = computed(() => pm25List.value.map((i) => i.exceedCount))
const so2X = computed(() => so2List.value.map((i) => i.provinceCode))
const so2Y = computed(() => so2List.value.map((i) => i.exceedCount))
const coX = computed(() => coList.value.map((i) => i.provinceCode))
const coY = computed(() => coList.value.map((i) => i.exceedCount))

const gauge1Ref = ref(null)
const gauge2Ref = ref(null)
const pieRef = ref(null)
const lineRef = ref(null)
const mapChartRef = ref(null)
let gauge1Chart, gauge2Chart, pieChart, lineChart, mapChart
let timer = null

function mapExceed(list) {
  return (list || []).map((item) => ({
    provinceCode: item.provinceCode,
    provinceName: item.provinceName,
    exceedCount: Number(item.exceedCount || 0),
  }))
}

async function loadData() {
  const data = await getDashboardData()
  summary.value = data.summary || {}
  pm25List.value = mapExceed(data.pm25ExceedByProvince)
  so2List.value = mapExceed(data.so2ExceedByProvince)
  coList.value = mapExceed(data.coExceedByProvince)
  aqiDistribution.value = data.aqiDistribution || []
  monthlyTrend.value = data.monthlyTrend || []
  renderSideCharts()
  renderMapChart()
}

function renderMapChart() {
  const list = [...pm25List.value].sort((a, b) => b.exceedCount - a.exceedCount)
  mapChart?.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: (params) => {
        const p = params[0]
        return `${p.name}<br/>PM2.5 超标 ${p.value} 次`
      },
    },
    grid: { left: 80, right: 40, top: 16, bottom: 24 },
    xAxis: {
      type: 'value',
      name: '超标次数',
      nameTextStyle: { color: '#a8dbbe' },
      axisLabel: { color: '#a8dbbe' },
      splitLine: { lineStyle: { color: 'rgba(82, 183, 136, 0.12)' } },
    },
    yAxis: {
      type: 'category',
      data: list.map((i) => i.provinceName),
      axisLabel: { color: '#c0e6d0', fontSize: 13 },
      axisLine: { lineStyle: { color: '#2d8f6f' } },
    },
    series: [{
      type: 'bar',
      data: list.map((i) => i.exceedCount),
      barWidth: '55%',
      itemStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 1, y2: 0,
          colorStops: [
            { offset: 0, color: '#1a5c40' },
            { offset: 1, color: '#52b788' },
          ],
        },
        borderRadius: [0, 4, 4, 0],
      },
      label: {
        show: true,
        position: 'right',
        color: '#7ec8a0',
        formatter: '{c} 次',
      },
    }],
  })
}

function renderSideCharts() {
  const avgAqi = Number(summary.value.avgAqi || 0)
  const pending = Number(summary.value.pendingCount || 0)

  gauge1Chart?.setOption({
    series: [{
      type: 'gauge', min: 0, max: 300,
      axisLine: { lineStyle: { width: 8, color: [[0.3, '#52b788'], [0.7, '#2d8f6f'], [1, '#e6a23c']] } },
      detail: { formatter: '{value}', color: '#fff' },
      data: [{ value: avgAqi, name: 'AQI' }],
    }],
  })

  gauge2Chart?.setOption({
    series: [{
      type: 'gauge', min: 0, max: Math.max(pending * 2, 10),
      axisLine: { lineStyle: { width: 8, color: [[1, '#52b788']] } },
      detail: { formatter: '{value}', color: '#fff' },
      data: [{ value: pending, name: '待处理' }],
    }],
  })

  pieChart?.setOption({
    title: { text: 'AQI 等级分布', left: 'center', textStyle: { color: '#c0e6d0', fontSize: 14 } },
    tooltip: { trigger: 'item' },
    series: [{
      type: 'pie', radius: ['35%', '60%'],
      data: aqiDistribution.value.map((i) => ({ name: i.levelName, value: i.count })),
      label: { color: '#c0e6d0' },
    }],
  })

  lineChart?.setOption({
    title: { text: '近12月空气质量趋势', left: 'center', textStyle: { color: '#c0e6d0', fontSize: 14 } },
    tooltip: { trigger: 'axis' },
    grid: { left: 40, right: 20, top: 40, bottom: 30 },
    xAxis: { type: 'category', data: monthlyTrend.value.map((i) => i.month), axisLabel: { color: '#a8dbbe' } },
    yAxis: { type: 'value', axisLabel: { color: '#a8dbbe' }, splitLine: { lineStyle: { color: 'rgba(82, 183, 136, 0.12)' } } },
    series: [{ type: 'line', smooth: true, data: monthlyTrend.value.map((i) => i.avgAqi), areaStyle: { opacity: 0.15, color: '#52b788' }, itemStyle: { color: '#52b788' } }],
  })
}

function initSideCharts() {
  gauge1Chart = echarts.init(gauge1Ref.value)
  gauge2Chart = echarts.init(gauge2Ref.value)
  pieChart = echarts.init(pieRef.value)
  lineChart = echarts.init(lineRef.value)
  mapChart = echarts.init(mapChartRef.value)
  window.addEventListener('resize', handleResize)
}

function handleResize() {
  gauge1Chart?.resize()
  gauge2Chart?.resize()
  pieChart?.resize()
  lineChart?.resize()
  mapChart?.resize()
}

onMounted(async () => {
  initSideCharts()
  await loadData()
  timer = setInterval(loadData, POLL_INTERVAL)
})

onBeforeUnmount(() => {
  clearInterval(timer)
  window.removeEventListener('resize', handleResize)
  gauge1Chart?.dispose()
  gauge2Chart?.dispose()
  pieChart?.dispose()
  lineChart?.dispose()
  mapChart?.dispose()
})
</script>

<style scoped>
.dashboard {
  min-height: 100vh;
  background: radial-gradient(circle at top, #0a2e1f 0%, #061a12 55%, #030f0a 100%);
  color: #fff;
  padding: 16px;
}
.title {
  text-align: center;
  font-size: 28px;
  letter-spacing: 4px;
  margin-bottom: 16px;
  color: #7ec8a0;
  text-shadow: 0 0 12px rgba(82, 183, 136, 0.6);
}
.content {
  display: grid;
  grid-template-columns: 1fr 1.2fr 1fr;
  gap: 12px;
  min-height: calc(100vh - 80px);
}
.left-panel, .right-panel, .center-panel {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.panel-box {
  background: rgba(10, 46, 31, 0.75);
  border: 1px solid rgba(82, 183, 136, 0.3);
  border-radius: 8px;
  padding: 8px;
  flex: 1;
}
.gauges {
  display: flex;
  gap: 8px;
}
.gauge-item {
  flex: 1;
  text-align: center;
}
.gauge-item p {
  margin-top: -8px;
  font-size: 12px;
  color: #a8dbbe;
}
.mini-chart, .chart-block {
  width: 100%;
  height: 160px;
}
.chart-wrap {
  min-height: 200px;
}
.map-placeholder {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: rgba(10, 46, 31, 0.75);
  border: 1px solid rgba(82, 183, 136, 0.3);
  border-radius: 8px;
  padding: 16px;
}
.map-placeholder h3 {
  text-align: center;
  margin-bottom: 8px;
  flex-shrink: 0;
  color: #7ec8a0;
}
.map-chart {
  flex: 1;
  width: 100%;
  min-height: 280px;
}
.summary-bar {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 12px;
  background: rgba(10, 46, 31, 0.75);
  border: 1px solid rgba(82, 183, 136, 0.3);
  border-radius: 8px;
  font-size: 14px;
}
.refresh-tip {
  color: #52b788;
  font-size: 12px;
}
</style>
