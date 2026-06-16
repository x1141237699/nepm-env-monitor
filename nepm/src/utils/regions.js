export const AQI_LEVELS = [
  { id: 1, name: '优' },
  { id: 2, name: '良' },
  { id: 3, name: '轻度污染' },
  { id: 4, name: '中度污染' },
  { id: 5, name: '重度污染' },
  { id: 6, name: '严重污染' },
]

export const PROVINCES = [
  { id: 1, name: '辽宁省', code: 'LN' },
  { id: 2, name: '吉林省', code: 'JL' },
  { id: 3, name: '黑龙江省', code: 'HLJ' },
  { id: 4, name: '河北省', code: 'HEB' },
]

export const CITIES = [
  { id: 1, provinceId: 1, name: '沈阳市', code: 'SY' },
  { id: 2, provinceId: 1, name: '大连市', code: 'DL' },
  { id: 3, provinceId: 1, name: '鞍山市', code: 'AS' },
  { id: 4, provinceId: 2, name: '长春市', code: 'CC' },
  { id: 5, provinceId: 3, name: '哈尔滨市', code: 'HEB' },
  { id: 6, provinceId: 4, name: '石家庄市', code: 'SJZ' },
]

export function getCitiesByProvince(provinceId) {
  return CITIES.filter((c) => c.provinceId === provinceId)
}
