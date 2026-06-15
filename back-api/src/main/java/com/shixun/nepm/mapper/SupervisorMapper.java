package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.Supervisor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SupervisorMapper {
    Supervisor findByCode(@Param("supervisorCode") String supervisorCode);
    int insert(Supervisor supervisor);
}
