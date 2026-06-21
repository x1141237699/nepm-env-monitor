package com.shixun.nepm.entity;

import java.util.Date;

public class AqiLevel {
    private Integer id;
    private String levelName;
    private Integer minValue;
    private Integer maxValue;
    private String colorCode;
    private String healthImpact;
    private Date createTime;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
    public Integer getMinValue() { return minValue; }
    public void setMinValue(Integer minValue) { this.minValue = minValue; }
    public Integer getMaxValue() { return maxValue; }
    public void setMaxValue(Integer maxValue) { this.maxValue = maxValue; }
    public String getColorCode() { return colorCode; }
    public void setColorCode(String colorCode) { this.colorCode = colorCode; }
    public String getHealthImpact() { return healthImpact; }
    public void setHealthImpact(String healthImpact) { this.healthImpact = healthImpact; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
