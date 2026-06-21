package com.shixun.nepm.mapper;

import com.shixun.nepm.entity.SupervisorFeedback;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SupervisorFeedbackMapper {
    int insert(SupervisorFeedback feedback);
    List<SupervisorFeedback> findAll();
    List<SupervisorFeedback> findPage(@Param("offset") int offset, @Param("pageSize") int pageSize);
    long countAll();
    SupervisorFeedback findById(@Param("id") Integer id);
    List<SupervisorFeedback> findByGridMemberId(@Param("gridMemberId") Integer gridMemberId);
    List<SupervisorFeedback> findPendingByGridMemberId(@Param("gridMemberId") Integer gridMemberId);
    List<SupervisorFeedback> findBySupervisorId(@Param("supervisorId") Integer supervisorId);
    int assign(@Param("id") Integer id, @Param("gridMemberId") Integer gridMemberId);
    int confirmWithMeasure(@Param("id") Integer id, @Param("confirmAqi") Integer confirmAqi,
                           @Param("confirmLevel") Integer confirmLevel,
                           @Param("so2") Double so2, @Param("co") Double co, @Param("pm25") Double pm25);
    int confirm(@Param("id") Integer id, @Param("confirmAqi") Integer confirmAqi, @Param("confirmLevel") Integer confirmLevel);
}
