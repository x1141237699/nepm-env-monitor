package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.entity.AqiLevel;
import com.shixun.nepm.entity.GridCity;
import com.shixun.nepm.entity.GridProvince;
import com.shixun.nepm.mapper.AqiLevelMapper;
import com.shixun.nepm.mapper.GridCityMapper;
import com.shixun.nepm.mapper.GridProvinceMapper;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/common")
public class CommonController {
    private final GridProvinceMapper provinceMapper;
    private final GridCityMapper cityMapper;
    private final AqiLevelMapper aqiLevelMapper;

    public CommonController(GridProvinceMapper provinceMapper, GridCityMapper cityMapper,
                            AqiLevelMapper aqiLevelMapper) {
        this.provinceMapper = provinceMapper;
        this.cityMapper = cityMapper;
        this.aqiLevelMapper = aqiLevelMapper;
    }

    @GetMapping("/provinces")
    public Result<List<GridProvince>> provinces() {
        return Result.success(provinceMapper.findAll());
    }

    @GetMapping("/cities")
    public Result<List<GridCity>> cities(@RequestParam Integer provinceId) {
        return Result.success(cityMapper.findByProvinceId(provinceId));
    }

    @GetMapping("/aqi-levels")
    public Result<List<AqiLevel>> aqiLevels() {
        return Result.success(aqiLevelMapper.findAll());
    }
}
