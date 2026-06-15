package com.shixun.nepm.entity;

import java.util.Date;

public class Supervisor {
    private Integer id;
    private String supervisorCode;
    private String supervisorName;
    private String password;
    private String phone;
    private Integer status;
    private Date createTime;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getSupervisorCode() { return supervisorCode; }
    public void setSupervisorCode(String supervisorCode) { this.supervisorCode = supervisorCode; }
    public String getSupervisorName() { return supervisorName; }
    public void setSupervisorName(String supervisorName) { this.supervisorName = supervisorName; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
