package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.GridMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GridMemberMapper {
    GridMember findByCode(@Param("memberCode") String memberCode);
    GridMember findById(@Param("id") Integer id);
    List<GridMember> findAll();
    List<GridMember> findByCityId(@Param("cityId") Integer cityId);
    List<GridMember> findOtherCity(@Param("cityId") Integer cityId);
    int countByCityId(@Param("cityId") Integer cityId);
}
