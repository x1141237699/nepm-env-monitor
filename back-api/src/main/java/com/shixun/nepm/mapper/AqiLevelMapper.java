package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.AqiLevel;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AqiLevelMapper {
    List<AqiLevel> findAll();
}
