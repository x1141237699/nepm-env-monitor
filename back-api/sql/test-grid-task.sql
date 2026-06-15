USE nepm_db;
SET NAMES utf8mb4;

-- 重置反馈#1为待指派，便于管理员重新指派测试
UPDATE supervisor_feedback SET status = 0, grid_member_id = NULL, assign_time = NULL,
  confirm_aqi = NULL, confirm_level = NULL, confirm_time = NULL,
  so2_value = NULL, co_value = NULL, pm25_value = NULL
WHERE id = 1;

-- 或直接设为已指派给 grid001 待检测（跳过管理员指派步骤）
-- UPDATE supervisor_feedback SET status = 1, grid_member_id = 1, assign_time = NOW() WHERE id = 1;
