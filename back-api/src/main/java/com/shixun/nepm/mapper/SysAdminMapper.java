package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.SysAdmin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SysAdminMapper {
    SysAdmin findByCode(@Param("adminCode") String adminCode);
}
