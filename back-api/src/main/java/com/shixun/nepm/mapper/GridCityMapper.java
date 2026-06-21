package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.GridCity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GridCityMapper {
    List<GridCity> findByProvinceId(@Param("provinceId") Integer provinceId);
}
