-- 外省调派测试数据（已有数据库可单独执行）
USE nepm_db;

-- 重置沈阳反馈为待指派（用于本市指派测试）
UPDATE supervisor_feedback SET status = 0, grid_member_id = NULL, assign_time = NULL WHERE id = 1;

-- 添加鞍山市反馈（本市无网格员，用于外省调派测试）
INSERT INTO supervisor_feedback (supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status)
SELECT 1, 1, 3, '鞍山市铁东区胜利路网格', 2, '鞍山市测试反馈，本市无网格员', 0
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM supervisor_feedback WHERE grid_address = '鞍山市铁东区胜利路网格'
);
