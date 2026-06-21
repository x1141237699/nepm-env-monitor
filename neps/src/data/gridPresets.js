/** 各城市预设网格地址（cityId -> 网格列表） */
export const gridPresets = {
  1: [
    { label: '和平区', address: '沈阳市和平区南京街网格' },
    { label: '沈河区', address: '沈阳市沈河区中街网格' },
    { label: '铁西区', address: '沈阳市铁西区兴华街网格' },
  ],
  2: [
    { label: '中山区', address: '大连市中山区人民路网格' },
    { label: '西岗区', address: '大连市西岗区黄河街网格' },
    { label: '沙河口区', address: '大连市沙河口区西安路网格' },
  ],
  3: [
    { label: '铁东区', address: '鞍山市铁东区胜利路网格' },
    { label: '铁西区', address: '鞍山市铁西区人民路网格' },
    { label: '立山区', address: '鞍山市立山区深沟寺网格' },
  ],
}

export function getGridsByCityId(cityId) {
  return gridPresets[cityId] || []
}
