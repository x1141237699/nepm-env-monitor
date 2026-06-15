-- NEPV 大屏统计 SQL 与演示数据

USE nepm_db;
SET NAMES utf8mb4;

-- ========== 1. 按省统计 PM2.5 超标累计次数（24小时均值标准 75 μg/m³） ==========
SELECT p.province_code AS provinceCode,
       p.province_name AS provinceName,
       COUNT(*)        AS exceedCount
FROM supervisor_feedback f
         JOIN grid_province p ON f.province_id = p.id
WHERE f.status = 2
  AND f.pm25_value IS NOT NULL
  AND f.pm25_value > 75
GROUP BY p.id, p.province_code, p.province_name
ORDER BY exceedCount DESC;

-- ========== 2. 按省统计 SO2 超标累计次数（24小时均值标准 150 μg/m³） ==========
SELECT p.province_code AS provinceCode,
       p.province_name AS provinceName,
       COUNT(*)        AS exceedCount
FROM supervisor_feedback f
         JOIN grid_province p ON f.province_id = p.id
WHERE f.status = 2
  AND f.so2_value IS NOT NULL
  AND f.so2_value > 150
GROUP BY p.id, p.province_code, p.province_name
ORDER BY exceedCount DESC;

-- ========== 3. 按省统计 CO 超标累计次数（24小时均值标准 4 mg/m³） ==========
SELECT p.province_code AS provinceCode,
       p.province_name AS provinceName,
       COUNT(*)        AS exceedCount
FROM supervisor_feedback f
         JOIN grid_province p ON f.province_id = p.id
WHERE f.status = 2
  AND f.co_value IS NOT NULL
  AND f.co_value > 4
GROUP BY p.id, p.province_code, p.province_name
ORDER BY exceedCount DESC;

-- ========== 演示数据：补充省份与已确认监测记录（可重复执行） ==========
INSERT INTO grid_province (province_name, province_code)
SELECT '吉林省', 'JL' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM grid_province WHERE province_code = 'JL');
INSERT INTO grid_province (province_name, province_code)
SELECT '黑龙江省', 'HLJ' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM grid_province WHERE province_code = 'HLJ');
INSERT INTO grid_province (province_name, province_code)
SELECT '河北省', 'HEB' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM grid_province WHERE province_code = 'HEB');

INSERT INTO grid_city (province_id, city_name, city_code)
SELECT id, '长春市', 'CC' FROM grid_province WHERE province_code = 'JL' LIMIT 1;
INSERT INTO grid_city (province_id, city_name, city_code)
SELECT id, '哈尔滨市', 'HEB' FROM grid_province WHERE province_code = 'HLJ' LIMIT 1;
INSERT INTO grid_city (province_id, city_name, city_code)
SELECT id, '石家庄市', 'SJZ' FROM grid_province WHERE province_code = 'HEB' LIMIT 1;

-- 已确认反馈样例（含三种污染物实测值）
INSERT INTO supervisor_feedback
(supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status,
 grid_member_id, assign_time, confirm_aqi, confirm_level, confirm_time, so2_value, co_value, pm25_value)
SELECT 1, p.id, c.id, CONCAT(p.province_name, '演示网格A'), 3, '大屏统计演示数据', 2,
       1, NOW(), 135, 3, NOW(), 180.5, 3.2, 88.0
FROM grid_province p JOIN grid_city c ON c.province_id = p.id
WHERE p.province_code = 'LN'
  AND NOT EXISTS (SELECT 1 FROM supervisor_feedback WHERE grid_address = CONCAT(p.province_name, '演示网格A'))
LIMIT 1;

INSERT INTO supervisor_feedback
(supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status,
 grid_member_id, assign_time, confirm_aqi, confirm_level, confirm_time, so2_value, co_value, pm25_value)
SELECT 1, p.id, c.id, CONCAT(p.province_name, '演示网格B'), 4, '大屏统计演示数据', 2,
       1, NOW(), 165, 4, NOW(), 220.0, 5.5, 120.0
FROM grid_province p
         JOIN grid_city c ON c.province_id = p.id
WHERE p.province_code = 'JL'
LIMIT 1;

INSERT INTO supervisor_feedback
(supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status,
 grid_member_id, assign_time, confirm_aqi, confirm_level, confirm_time, so2_value, co_value, pm25_value)
SELECT 1, p.id, c.id, CONCAT(p.province_name, '演示网格C'), 2, '大屏统计演示数据', 2,
       1, NOW(), 85, 2, NOW(), 90.0, 2.1, 45.0
FROM grid_province p
         JOIN grid_city c ON c.province_id = p.id
WHERE p.province_code = 'HLJ'
LIMIT 1;

INSERT INTO supervisor_feedback
(supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status,
 grid_member_id, assign_time, confirm_aqi, confirm_level, confirm_time, so2_value, co_value, pm25_value)
SELECT 1, p.id, c.id, CONCAT(p.province_name, '演示网格D'), 3, '大屏统计演示数据', 2,
       1, NOW(), 140, 3, NOW(), 160.0, 4.8, 95.0
FROM grid_province p
         JOIN grid_city c ON c.province_id = p.id
WHERE p.province_code = 'HEB'
LIMIT 1;
