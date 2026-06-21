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
  color: { type: String, default: '#52b788' },
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
      textStyle: { color: '#c0e6d0', fontSize: 14 },
    },
    grid: { left: 40, right: 20, top: 40, bottom: 30 },
    tooltip: { trigger: 'axis' },
    legend: { show: false },
    xAxis: {
      type: 'category',
      data: props.xData,
      axisLabel: { color: '#a8dbbe', fontSize: 11 },
      axisLine: { lineStyle: { color: '#2d8f6f' } },
    },
    yAxis: {
      type: 'value',
      name: props.yAxisName,
      nameTextStyle: { color: '#a8dbbe' },
      axisLabel: { color: '#a8dbbe' },
      splitLine: { lineStyle: { color: 'rgba(82, 183, 136, 0.12)' } },
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
