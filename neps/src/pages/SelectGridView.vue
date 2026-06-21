<template>
  <div class="page">
    <van-nav-bar title="选择网格地址" left-arrow fixed placeholder @click-left="router.back()" />

    <van-cell-group inset class="form-group">
      <van-cell
        title="选择省份"
        :value="selectedProvince?.provinceName || '请选择'"
        is-link
        @click="showProvincePicker = true"
      />
      <van-cell
        title="选择城市"
        :value="selectedCity?.cityName || '请选择'"
        is-link
        @click="openCityPicker"
      />
    </van-cell-group>

    <div v-if="selectedCity" class="grid-section">
      <p class="section-title">选择网格</p>
      <div class="grid-list">
        <div
          v-for="grid in grids"
          :key="grid.address"
          class="grid-item"
          :class="{ selected: selectedGrid?.address === grid.address }"
          @click="selectedGrid = grid"
        >
          <strong>{{ grid.label }}</strong>
          <span>{{ grid.address }}</span>
        </div>
      </div>
      <van-field
        v-if="grids.length === 0"
        v-model="customAddress"
        label="网格地址"
        placeholder="请输入网格地址"
      />
    </div>

    <div class="submit-btn">
      <van-button round block type="primary" :disabled="!canNext" @click="goSubmit">
        下一步：提交反馈
      </van-button>
    </div>

    <van-popup v-model:show="showProvincePicker" position="bottom" round>
      <van-picker
        :columns="provinceColumns"
        @confirm="onProvinceConfirm"
        @cancel="showProvincePicker = false"
      />
    </van-popup>

    <van-popup v-model:show="showCityPicker" position="bottom" round>
      <van-picker
        :columns="cityColumns"
        @confirm="onCityConfirm"
        @cancel="showCityPicker = false"
      />
    </van-popup>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { getProvinces, getCities } from '../api/common'
import { getGridsByCityId } from '../data/gridPresets'

const router = useRouter()

const provinces = ref([])
const cities = ref([])
const selectedProvince = ref(null)
const selectedCity = ref(null)
const selectedGrid = ref(null)
const customAddress = ref('')

const showProvincePicker = ref(false)
const showCityPicker = ref(false)

const provinceColumns = computed(() =>
  provinces.value.map((p) => ({ text: p.provinceName, value: p.id }))
)

const cityColumns = computed(() =>
  cities.value.map((c) => ({ text: c.cityName, value: c.id }))
)

const grids = computed(() =>
  selectedCity.value ? getGridsByCityId(selectedCity.value.id) : []
)

const canNext = computed(() => {
  if (!selectedProvince.value || !selectedCity.value) return false
  if (grids.value.length > 0) return !!selectedGrid.value
  return !!customAddress.value.trim()
})

async function loadProvinces() {
  provinces.value = await getProvinces()
}

async function loadCities(provinceId) {
  cities.value = await getCities(provinceId)
}

function onProvinceConfirm({ selectedOptions }) {
  const opt = selectedOptions[0]
  selectedProvince.value = provinces.value.find((p) => p.id === opt.value)
  selectedCity.value = null
  selectedGrid.value = null
  customAddress.value = ''
  showProvincePicker.value = false
  if (selectedProvince.value) {
    loadCities(selectedProvince.value.id)
  }
}

function openCityPicker() {
  if (!selectedProvince.value) {
    showToast('请先选择省份')
    return
  }
  if (cities.value.length === 0) {
    showToast('该省份暂无城市数据')
    return
  }
  showCityPicker.value = true
}

function onCityConfirm({ selectedOptions }) {
  const opt = selectedOptions[0]
  selectedCity.value = cities.value.find((c) => c.id === opt.value)
  selectedGrid.value = null
  customAddress.value = ''
  showCityPicker.value = false
}

function goSubmit() {
  const gridAddress = selectedGrid.value?.address || customAddress.value.trim()
  router.push({
    path: '/feedback/submit',
    query: {
      provinceId: selectedProvince.value.id,
      cityId: selectedCity.value.id,
      provinceName: selectedProvince.value.provinceName,
      cityName: selectedCity.value.cityName,
      gridAddress,
    },
  })
}

onMounted(loadProvinces)
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: var(--color-page-bg, #f4f9f6);
  padding-bottom: 24px;
}
.form-group {
  margin-top: 12px;
  border: 1px solid var(--color-card-border, #c5d4a8);
  overflow: hidden;
}
.grid-section {
  padding: 16px;
}
.section-title {
  font-size: 15px;
  font-weight: 600;
  color: #2c3e2c;
  margin-bottom: 12px;
}
.grid-list {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.grid-item {
  padding: 12px;
  background: #fff;
  border: 2px solid var(--color-card-border, #c5d4a8);
  border-radius: 8px;
  cursor: pointer;
  transition: border-color 0.2s;
}
.grid-item strong {
  display: block;
  font-size: 14px;
  color: #2c3e2c;
  margin-bottom: 4px;
}
.grid-item span {
  font-size: 12px;
  color: #5a6b5a;
  line-height: 1.4;
}
.grid-item.selected {
  border-color: var(--color-primary, #2d8f6f);
  background: #eef7f2;
}
.submit-btn {
  margin: 24px 16px;
}
</style>
