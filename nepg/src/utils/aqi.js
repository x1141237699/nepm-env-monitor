/**
 * 根据 SO2(μg/m³)、CO(mg/m³)、PM2.5(μg/m³) 计算 IAQI，取最大值作为 AQI
 */
function calcIaqi(cp, breakpoints) {
  for (let i = 0; i < breakpoints.length - 1; i++) {
    const [cLow, cHigh, iLow, iHigh] = breakpoints[i]
    const [nextLow] = breakpoints[i + 1]
    if (cp >= cLow && cp <= cHigh) {
      return Math.round(((iHigh - iLow) / (cHigh - cLow)) * (cp - cLow) + iLow)
    }
    if (cp < nextLow && cp > cHigh) continue
  }
  const last = breakpoints[breakpoints.length - 1]
  if (cp > last[1]) return 500
  return 0
}

const PM25_BP = [
  [0, 35, 0, 50],
  [35, 75, 51, 100],
  [75, 115, 101, 150],
  [115, 150, 151, 200],
  [150, 250, 201, 300],
  [250, 350, 301, 400],
  [350, 500, 401, 500],
]

const SO2_BP = [
  [0, 50, 0, 50],
  [50, 150, 51, 100],
  [150, 475, 101, 200],
  [475, 800, 201, 300],
  [800, 1600, 301, 400],
  [1600, 2100, 401, 500],
]

const CO_BP = [
  [0, 2, 0, 50],
  [2, 4, 51, 100],
  [4, 14, 101, 200],
  [14, 24, 201, 300],
  [24, 36, 301, 400],
  [36, 48, 401, 500],
  [48, 60, 501, 600],
]

const LEVELS = [
  { id: 1, name: '优', min: 0, max: 50 },
  { id: 2, name: '良', min: 51, max: 100 },
  { id: 3, name: '轻度污染', min: 101, max: 150 },
  { id: 4, name: '中度污染', min: 151, max: 200 },
  { id: 5, name: '重度污染', min: 201, max: 300 },
  { id: 6, name: '严重污染', min: 301, max: 500 },
]

export function pollutantLevel(iaqi) {
  return LEVELS.find((l) => iaqi >= l.min && iaqi <= l.max) || LEVELS[LEVELS.length - 1]
}

export function calculateAqi({ so2, co, pm25 }) {
  const so2Val = Number(so2)
  const coVal = Number(co)
  const pm25Val = Number(pm25)
  const iaqiSo2 = calcIaqi(so2Val, SO2_BP)
  const iaqiCo = calcIaqi(coVal, CO_BP)
  const iaqiPm25 = calcIaqi(pm25Val, PM25_BP)
  const aqi = Math.max(iaqiSo2, iaqiCo, iaqiPm25)
  const level = pollutantLevel(aqi)
  return {
    aqi,
    levelId: level.id,
    levelName: level.name,
    iaqiSo2,
    iaqiCo,
    iaqiPm25,
    so2Level: pollutantLevel(iaqiSo2).name,
    coLevel: pollutantLevel(iaqiCo).name,
    pm25Level: pollutantLevel(iaqiPm25).name,
  }
}
