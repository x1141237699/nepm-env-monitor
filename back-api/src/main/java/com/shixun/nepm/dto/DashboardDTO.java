package com.shixun.nepm.dto;

import java.util.List;
import java.util.Map;

public class DashboardDTO {
    private List<ProvinceExceedStat> pm25ExceedByProvince;
    private List<ProvinceExceedStat> so2ExceedByProvince;
    private List<ProvinceExceedStat> coExceedByProvince;
    private List<AqiDistributionStat> aqiDistribution;
    private List<MonthlyTrendStat> monthlyTrend;
    private Map<String, Object> summary;

    public List<ProvinceExceedStat> getPm25ExceedByProvince() { return pm25ExceedByProvince; }
    public void setPm25ExceedByProvince(List<ProvinceExceedStat> pm25ExceedByProvince) { this.pm25ExceedByProvince = pm25ExceedByProvince; }
    public List<ProvinceExceedStat> getSo2ExceedByProvince() { return so2ExceedByProvince; }
    public void setSo2ExceedByProvince(List<ProvinceExceedStat> so2ExceedByProvince) { this.so2ExceedByProvince = so2ExceedByProvince; }
    public List<ProvinceExceedStat> getCoExceedByProvince() { return coExceedByProvince; }
    public void setCoExceedByProvince(List<ProvinceExceedStat> coExceedByProvince) { this.coExceedByProvince = coExceedByProvince; }
    public List<AqiDistributionStat> getAqiDistribution() { return aqiDistribution; }
    public void setAqiDistribution(List<AqiDistributionStat> aqiDistribution) { this.aqiDistribution = aqiDistribution; }
    public List<MonthlyTrendStat> getMonthlyTrend() { return monthlyTrend; }
    public void setMonthlyTrend(List<MonthlyTrendStat> monthlyTrend) { this.monthlyTrend = monthlyTrend; }
    public Map<String, Object> getSummary() { return summary; }
    public void setSummary(Map<String, Object> summary) { this.summary = summary; }
}
