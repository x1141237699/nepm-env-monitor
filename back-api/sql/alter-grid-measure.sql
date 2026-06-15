USE nepm_db;
ALTER TABLE supervisor_feedback
  ADD COLUMN so2_value DECIMAL(10,2) COMMENT 'SO2实测值',
  ADD COLUMN co_value DECIMAL(10,2) COMMENT 'CO实测值',
  ADD COLUMN pm25_value DECIMAL(10,2) COMMENT 'PM2.5实测值';
