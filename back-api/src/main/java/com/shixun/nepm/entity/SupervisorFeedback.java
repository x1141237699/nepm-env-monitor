package com.shixun.nepm.entity;

import java.util.Date;

public class SupervisorFeedback {
    private Integer id;
    private Integer supervisorId;
    private Integer provinceId;
    private Integer cityId;
    private String gridAddress;
    private Integer estimatedLevel;
    private String feedbackDesc;
    private String feedbackImages;
    private Integer status;
    private Integer gridMemberId;
    private Date assignTime;
    private Integer confirmAqi;
    private Integer confirmLevel;
    private Date confirmTime;
    private Date createTime;

    private Double so2Value;
    private Double coValue;
    private Double pm25Value;

    private String supervisorName;
    private String supervisorPhone;
    private String provinceName;
    private String cityName;
    private String levelName;
    private String memberName;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getSupervisorId() { return supervisorId; }
    public void setSupervisorId(Integer supervisorId) { this.supervisorId = supervisorId; }
    public Integer getProvinceId() { return provinceId; }
    public void setProvinceId(Integer provinceId) { this.provinceId = provinceId; }
    public Integer getCityId() { return cityId; }
    public void setCityId(Integer cityId) { this.cityId = cityId; }
    public String getGridAddress() { return gridAddress; }
    public void setGridAddress(String gridAddress) { this.gridAddress = gridAddress; }
    public Integer getEstimatedLevel() { return estimatedLevel; }
    public void setEstimatedLevel(Integer estimatedLevel) { this.estimatedLevel = estimatedLevel; }
    public String getFeedbackDesc() { return feedbackDesc; }
    public void setFeedbackDesc(String feedbackDesc) { this.feedbackDesc = feedbackDesc; }
    public String getFeedbackImages() { return feedbackImages; }
    public void setFeedbackImages(String feedbackImages) { this.feedbackImages = feedbackImages; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Integer getGridMemberId() { return gridMemberId; }
    public void setGridMemberId(Integer gridMemberId) { this.gridMemberId = gridMemberId; }
    public Date getAssignTime() { return assignTime; }
    public void setAssignTime(Date assignTime) { this.assignTime = assignTime; }
    public Integer getConfirmAqi() { return confirmAqi; }
    public void setConfirmAqi(Integer confirmAqi) { this.confirmAqi = confirmAqi; }
    public Integer getConfirmLevel() { return confirmLevel; }
    public void setConfirmLevel(Integer confirmLevel) { this.confirmLevel = confirmLevel; }
    public Date getConfirmTime() { return confirmTime; }
    public void setConfirmTime(Date confirmTime) { this.confirmTime = confirmTime; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public Double getSo2Value() { return so2Value; }
    public void setSo2Value(Double so2Value) { this.so2Value = so2Value; }
    public Double getCoValue() { return coValue; }
    public void setCoValue(Double coValue) { this.coValue = coValue; }
    public Double getPm25Value() { return pm25Value; }
    public void setPm25Value(Double pm25Value) { this.pm25Value = pm25Value; }
    public String getSupervisorName() { return supervisorName; }
    public void setSupervisorName(String supervisorName) { this.supervisorName = supervisorName; }
    public String getSupervisorPhone() { return supervisorPhone; }
    public void setSupervisorPhone(String supervisorPhone) { this.supervisorPhone = supervisorPhone; }
    public String getProvinceName() { return provinceName; }
    public void setProvinceName(String provinceName) { this.provinceName = provinceName; }
    public String getCityName() { return cityName; }
    public void setCityName(String cityName) { this.cityName = cityName; }
    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
}
