package com.shixun.nepm.dto;

public class ProvinceExceedStat {
    private String provinceCode;
    private String provinceName;
    private Long exceedCount;

    public String getProvinceCode() { return provinceCode; }
    public void setProvinceCode(String provinceCode) { this.provinceCode = provinceCode; }
    public String getProvinceName() { return provinceName; }
    public void setProvinceName(String provinceName) { this.provinceName = provinceName; }
    public Long getExceedCount() { return exceedCount; }
    public void setExceedCount(Long exceedCount) { this.exceedCount = exceedCount; }
}
