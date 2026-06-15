package com.shixun.nepm.dto;

public class AqiDistributionStat {
    private String levelName;
    private Long count;

    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
    public Long getCount() { return count; }
    public void setCount(Long count) { this.count = count; }
}
