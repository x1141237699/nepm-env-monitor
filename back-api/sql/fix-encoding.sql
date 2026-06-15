-- 修复中文乱码（问号）数据
USE nepm_db;
SET NAMES utf8mb4;

UPDATE aqi_level SET
  level_name = '优', health_impact = '空气质量令人满意，基本无空气污染' WHERE id = 1;
UPDATE aqi_level SET
  level_name = '良', health_impact = '空气质量可接受，但某些污染物可能对极少数敏感人群有较弱影响' WHERE id = 2;
UPDATE aqi_level SET
  level_name = '轻度污染', health_impact = '易感人群症状有轻度加剧，健康人群出现刺激症状' WHERE id = 3;
UPDATE aqi_level SET
  level_name = '中度污染', health_impact = '进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响' WHERE id = 4;
UPDATE aqi_level SET
  level_name = '重度污染', health_impact = '心脏病和肺病患者症状显著加剧，运动耐受力降低' WHERE id = 5;
UPDATE aqi_level SET
  level_name = '严重污染', health_impact = '健康人群运动耐受力降低，有明显强烈症状' WHERE id = 6;

UPDATE grid_province SET province_name = '辽宁省', province_code = 'LN' WHERE id = 1;

UPDATE grid_city SET city_name = '沈阳市', city_code = 'SY' WHERE id = 1;
UPDATE grid_city SET city_name = '大连市', city_code = 'DL' WHERE id = 2;
UPDATE grid_city SET city_name = '鞍山市', city_code = 'AS' WHERE id = 3;

UPDATE sys_admin SET admin_name = '系统管理员' WHERE admin_code = 'admin';

UPDATE supervisor SET supervisor_name = '张三' WHERE supervisor_code = 'supervisor1';

UPDATE grid_member SET member_name = '李网格' WHERE member_code = 'grid001';
UPDATE grid_member SET member_name = '王网格' WHERE member_code = 'grid002';

UPDATE supervisor_feedback SET
  grid_address = '沈阳市和平区南京街网格',
  feedback_desc = '该区域近期空气质量较差，有明显雾霾，建议安排检测。'
WHERE id = 1;

UPDATE supervisor_feedback SET status = 0, grid_member_id = NULL, assign_time = NULL WHERE id = 1;

INSERT INTO supervisor_feedback (supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status)
SELECT 1, 1, 3, '鞍山市铁东区胜利路网格', 2, '鞍山市测试反馈，本市无网格员', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM supervisor_feedback WHERE city_id = 3 AND status = 0);
