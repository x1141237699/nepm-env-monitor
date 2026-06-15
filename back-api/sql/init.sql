-- 东软环保公众监督系统 - 数据库初始化脚本
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS nepm_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nepm_db;

-- 空气质量指数级别表
DROP TABLE IF EXISTS aqi_level;
CREATE TABLE aqi_level (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '级别ID',
    level_name VARCHAR(20) NOT NULL COMMENT '级别名称',
    min_value INT NOT NULL COMMENT 'AQI最小值',
    max_value INT NOT NULL COMMENT 'AQI最大值',
    color_code VARCHAR(20) COMMENT '显示颜色',
    health_impact VARCHAR(200) COMMENT '健康影响说明',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '空气质量指数级别表';

-- 系统网格覆盖省区域表
DROP TABLE IF EXISTS grid_province;
CREATE TABLE grid_province (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '省ID',
    province_name VARCHAR(50) NOT NULL COMMENT '省名称',
    province_code VARCHAR(10) COMMENT '省编码',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '系统网格覆盖省区域表';

-- 系统网格覆盖市区区域表
DROP TABLE IF EXISTS grid_city;
CREATE TABLE grid_city (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '市ID',
    province_id INT NOT NULL COMMENT '所属省ID',
    city_name VARCHAR(50) NOT NULL COMMENT '市/区名称',
    city_code VARCHAR(10) COMMENT '市编码',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (province_id) REFERENCES grid_province(id)
) COMMENT '系统网格覆盖市区区域表';

-- 系统管理员表
DROP TABLE IF EXISTS sys_admin;
CREATE TABLE sys_admin (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '管理员ID',
    admin_code VARCHAR(50) NOT NULL UNIQUE COMMENT '管理员账号',
    admin_name VARCHAR(50) NOT NULL COMMENT '管理员姓名',
    password VARCHAR(100) NOT NULL COMMENT '登录密码',
    phone VARCHAR(20) COMMENT '联系电话',
    status TINYINT DEFAULT 1 COMMENT '状态:1启用0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '系统管理员表';

-- 公众监督员表
DROP TABLE IF EXISTS supervisor;
CREATE TABLE supervisor (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '监督员ID',
    supervisor_code VARCHAR(50) NOT NULL UNIQUE COMMENT '监督员账号',
    supervisor_name VARCHAR(50) NOT NULL COMMENT '监督员姓名',
    password VARCHAR(100) NOT NULL COMMENT '登录密码',
    phone VARCHAR(20) COMMENT '联系电话',
    status TINYINT DEFAULT 1 COMMENT '状态:1启用0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT '公众监督员表';

-- 空气质量监测网格员表
DROP TABLE IF EXISTS grid_member;
CREATE TABLE grid_member (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '网格员ID',
    member_code VARCHAR(50) NOT NULL UNIQUE COMMENT '网格员账号',
    member_name VARCHAR(50) NOT NULL COMMENT '网格员姓名',
    password VARCHAR(100) NOT NULL COMMENT '登录密码',
    phone VARCHAR(20) COMMENT '联系电话',
    province_id INT COMMENT '负责省ID',
    city_id INT COMMENT '负责市ID',
    status TINYINT DEFAULT 1 COMMENT '状态:1启用0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (province_id) REFERENCES grid_province(id),
    FOREIGN KEY (city_id) REFERENCES grid_city(id)
) COMMENT '空气质量监测网格员表';

-- 空气质量公众监督反馈表
DROP TABLE IF EXISTS supervisor_feedback;
CREATE TABLE supervisor_feedback (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '反馈ID',
    supervisor_id INT NOT NULL COMMENT '监督员ID',
    province_id INT NOT NULL COMMENT '省ID',
    city_id INT NOT NULL COMMENT '市ID',
    grid_address VARCHAR(200) NOT NULL COMMENT '网格地址',
    estimated_level INT COMMENT '预估AQI级别ID',
    feedback_desc TEXT COMMENT '反馈描述',
    feedback_images VARCHAR(500) COMMENT '反馈图片URL,逗号分隔',
    status TINYINT DEFAULT 0 COMMENT '状态:0待指派1已指派2已确认',
    grid_member_id INT COMMENT '指派网格员ID',
    assign_time DATETIME COMMENT '指派时间',
    confirm_aqi INT COMMENT '确认AQI值',
    confirm_level INT COMMENT '确认AQI级别ID',
    so2_value DECIMAL(10,2) COMMENT 'SO2实测值',
    co_value DECIMAL(10,2) COMMENT 'CO实测值',
    pm25_value DECIMAL(10,2) COMMENT 'PM2.5实测值',
    confirm_time DATETIME COMMENT '确认时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (supervisor_id) REFERENCES supervisor(id),
    FOREIGN KEY (province_id) REFERENCES grid_province(id),
    FOREIGN KEY (city_id) REFERENCES grid_city(id),
    FOREIGN KEY (estimated_level) REFERENCES aqi_level(id),
    FOREIGN KEY (grid_member_id) REFERENCES grid_member(id)
) COMMENT '空气质量公众监督反馈表';

-- 空气质量监测数据统计表
DROP TABLE IF EXISTS aqi_statistics;
CREATE TABLE aqi_statistics (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '统计ID',
    province_id INT COMMENT '省ID',
    city_id INT COMMENT '市ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    avg_aqi DECIMAL(10,2) COMMENT '平均AQI',
    max_aqi INT COMMENT '最高AQI',
    min_aqi INT COMMENT '最低AQI',
    feedback_count INT DEFAULT 0 COMMENT '反馈数量',
    confirm_count INT DEFAULT 0 COMMENT '确认数量',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (province_id) REFERENCES grid_province(id),
    FOREIGN KEY (city_id) REFERENCES grid_city(id)
) COMMENT '空气质量监测数据统计表';

-- 初始数据：AQI级别
INSERT INTO aqi_level (level_name, min_value, max_value, color_code, health_impact) VALUES
('优', 0, 50, '#00E400', '空气质量令人满意，基本无空气污染'),
('良', 51, 100, '#FFFF00', '空气质量可接受，但某些污染物可能对极少数敏感人群有较弱影响'),
('轻度污染', 101, 150, '#FF7E00', '易感人群症状有轻度加剧，健康人群出现刺激症状'),
('中度污染', 151, 200, '#FF0000', '进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响'),
('重度污染', 201, 300, '#99004C', '心脏病和肺病患者症状显著加剧，运动耐受力降低'),
('严重污染', 301, 500, '#7E0023', '健康人群运动耐受力降低，有明显强烈症状');

-- 初始数据：省市区
INSERT INTO grid_province (province_name, province_code) VALUES ('辽宁省', 'LN');
INSERT INTO grid_city (province_id, city_name, city_code) VALUES
(1, '沈阳市', 'SY'),
(1, '大连市', 'DL'),
(1, '鞍山市', 'AS');

-- 初始数据：管理员 admin/123
INSERT INTO sys_admin (admin_code, admin_name, password, phone) VALUES
('admin', '系统管理员', '123', '13800000001');

-- 初始数据：公众监督员
INSERT INTO supervisor (supervisor_code, supervisor_name, password, phone) VALUES
('supervisor1', '张三', '123456', '13800000002');

-- 初始数据：网格员
INSERT INTO grid_member (member_code, member_name, password, phone, province_id, city_id) VALUES
('grid001', '李网格', '123456', '13800000003', 1, 1),
('grid002', '王网格', '123456', '13800000004', 1, 2);

-- 测试数据：鞍山市反馈（无本市网格员，用于外省调派测试）
INSERT INTO supervisor_feedback (supervisor_id, province_id, city_id, grid_address, estimated_level, feedback_desc, status) VALUES
(1, 1, 3, '鞍山市铁东区胜利路网格', 2, '鞍山市测试反馈，本市无网格员', 0);

SET FOREIGN_KEY_CHECKS = 1;
