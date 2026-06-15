package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.dto.DashboardDTO;
import com.shixun.nepm.service.StatisticsService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/statistics")
public class StatisticsController {
    private final StatisticsService statisticsService;

    public StatisticsController(StatisticsService statisticsService) {
        this.statisticsService = statisticsService;
    }

    @GetMapping("/dashboard")
    public Result<DashboardDTO> dashboard() {
        return Result.success(statisticsService.getDashboard());
    }
}
