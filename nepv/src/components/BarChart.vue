<template>
  <div ref="chartRef" class="bar-chart"></div>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import * as echarts from 'echarts'

const props = defineProps({
  title: { type: String, default: '' },
  xData: { type: Array, default: () => [] },
  yData: { type: Array, default: () => [] },
  color: { type: String, default: '#409EFF' },
  yAxisName: { type: String, default: '超标次数' },
})

const chartRef = ref(null)
let chartInstance = null

function renderChart() {
  if (!chartInstance) return
  chartInstance.setOption({
    title: {
      text: props.title,
      left: 'center',
      textStyle: { color: '#fff', fontSize: 14 },
    },
    grid: { left: 40, right: 20, top: 40, bottom: 30 },
    tooltip: { trigger: 'axis' },
    legend: { show: false },
    xAxis: {
      type: 'category',
      data: props.xData,
      axisLabel: { color: '#9ecbff', fontSize: 11 },
      axisLine: { lineStyle: { color: '#3a6ea5' } },
    },
    yAxis: {
      type: 'value',
      name: props.yAxisName,
      nameTextStyle: { color: '#9ecbff' },
      axisLabel: { color: '#9ecbff' },
      splitLine: { lineStyle: { color: 'rgba(255,255,255,0.08)' } },
    },
    series: [{
      type: 'bar',
      data: props.yData,
      barWidth: '45%',
      itemStyle: {
        color: props.color,
        borderRadius: [4, 4, 0, 0],
      },
    }],
  })
}

function initChart() {
  if (!chartRef.value) return
  chartInstance = echarts.init(chartRef.value)
  renderChart()
  window.addEventListener('resize', handleResize)
}

function handleResize() {
  chartInstance?.resize()
}

watch(() => [props.xData, props.yData, props.title, props.color], renderChart, { deep: true })

onMounted(initChart)
onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
})
</script>

<style scoped>
.bar-chart {
  width: 100%;
  height: 100%;
  min-height: 180px;
}
</style>
