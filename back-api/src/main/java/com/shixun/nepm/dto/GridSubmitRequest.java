package com.shixun.nepm.dto;

public class GridSubmitRequest {
    private Integer feedbackId;
    private Integer gridMemberId;
    private Double so2;
    private Double co;
    private Double pm25;
    private Integer confirmAqi;
    private Integer confirmLevel;

    public Integer getFeedbackId() { return feedbackId; }
    public void setFeedbackId(Integer feedbackId) { this.feedbackId = feedbackId; }
    public Integer getGridMemberId() { return gridMemberId; }
    public void setGridMemberId(Integer gridMemberId) { this.gridMemberId = gridMemberId; }
    public Double getSo2() { return so2; }
    public void setSo2(Double so2) { this.so2 = so2; }
    public Double getCo() { return co; }
    public void setCo(Double co) { this.co = co; }
    public Double getPm25() { return pm25; }
    public void setPm25(Double pm25) { this.pm25 = pm25; }
    public Integer getConfirmAqi() { return confirmAqi; }
    public void setConfirmAqi(Integer confirmAqi) { this.confirmAqi = confirmAqi; }
    public Integer getConfirmLevel() { return confirmLevel; }
    public void setConfirmLevel(Integer confirmLevel) { this.confirmLevel = confirmLevel; }
}
