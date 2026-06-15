package com.shixun.nepm.service;

import com.shixun.nepm.dto.DashboardDTO;
import com.shixun.nepm.mapper.StatisticsMapper;
import org.springframework.stereotype.Service;

@Service
public class StatisticsService {
    private final StatisticsMapper statisticsMapper;

    public StatisticsService(StatisticsMapper statisticsMapper) {
        this.statisticsMapper = statisticsMapper;
    }

    public DashboardDTO getDashboard() {
        DashboardDTO dto = new DashboardDTO();
        dto.setPm25ExceedByProvince(statisticsMapper.pm25ExceedByProvince());
        dto.setSo2ExceedByProvince(statisticsMapper.so2ExceedByProvince());
        dto.setCoExceedByProvince(statisticsMapper.coExceedByProvince());
        dto.setAqiDistribution(statisticsMapper.aqiDistribution());
        dto.setMonthlyTrend(statisticsMapper.monthlyTrend());
        dto.setSummary(statisticsMapper.feedbackSummary());
        return dto;
    }
}
