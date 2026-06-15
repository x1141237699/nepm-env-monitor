package com.shixun.nepm.mapper;

import com.shixun.nepm.dto.AqiDistributionStat;
import com.shixun.nepm.dto.MonthlyTrendStat;
import com.shixun.nepm.dto.ProvinceExceedStat;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface StatisticsMapper {
    List<ProvinceExceedStat> pm25ExceedByProvince();
    List<ProvinceExceedStat> so2ExceedByProvince();
    List<ProvinceExceedStat> coExceedByProvince();
    List<AqiDistributionStat> aqiDistribution();
    List<MonthlyTrendStat> monthlyTrend();
    Map<String, Object> feedbackSummary();
}
