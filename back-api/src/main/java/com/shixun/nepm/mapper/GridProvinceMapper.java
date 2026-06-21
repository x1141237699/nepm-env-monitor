package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.GridProvince;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GridProvinceMapper {
    List<GridProvince> findAll();
}
