package com.shixun.nepm.service;

import com.shixun.nepm.dto.AssignCandidatesDTO;
import com.shixun.nepm.entity.GridMember;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.mapper.GridMemberMapper;
import com.shixun.nepm.mapper.SupervisorFeedbackMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AssignService {
    private final SupervisorFeedbackMapper feedbackMapper;
    private final GridMemberMapper gridMemberMapper;

    public AssignService(SupervisorFeedbackMapper feedbackMapper, GridMemberMapper gridMemberMapper) {
        this.feedbackMapper = feedbackMapper;
        this.gridMemberMapper = gridMemberMapper;
    }

    public AssignCandidatesDTO getLocalCandidates(Integer afId) {
        SupervisorFeedback feedback = requirePendingFeedback(afId);
        List<GridMember> members = gridMemberMapper.findByCityId(feedback.getCityId());
        return new AssignCandidatesDTO(!members.isEmpty(), members);
    }

    public AssignCandidatesDTO getOtherProvinceCandidates(Integer afId) {
        SupervisorFeedback feedback = requirePendingFeedback(afId);
        int localCount = gridMemberMapper.countByCityId(feedback.getCityId());
        if (localCount > 0) {
            throw new IllegalStateException("本市仍有可用网格员，不能进行外省调派");
        }
        List<GridMember> members = gridMemberMapper.findOtherCity(feedback.getCityId());
        return new AssignCandidatesDTO(false, members);
    }

    public void assignLocal(Integer afId, Integer gridMemberId) {
        SupervisorFeedback feedback = requirePendingFeedback(afId);
        GridMember member = requireMember(gridMemberId);
        if (!feedback.getCityId().equals(member.getCityId())) {
            throw new IllegalStateException("网格员与反馈城市不匹配，无法完成本市指派");
        }
        if (feedbackMapper.assign(afId, gridMemberId) <= 0) {
            throw new IllegalStateException("指派失败");
        }
    }

    public void assignOtherProvince(Integer afId, Integer gridMemberId) {
        SupervisorFeedback feedback = requirePendingFeedback(afId);
        int localCount = gridMemberMapper.countByCityId(feedback.getCityId());
        if (localCount > 0) {
            throw new IllegalStateException("本市仍有可用网格员，不能进行外省调派");
        }
        GridMember member = requireMember(gridMemberId);
        if (feedback.getCityId().equals(member.getCityId())) {
            throw new IllegalStateException("所选网格员属于本市，请使用本市指派");
        }
        if (feedbackMapper.assign(afId, gridMemberId) <= 0) {
            throw new IllegalStateException("指派失败");
        }
    }

    private SupervisorFeedback requirePendingFeedback(Integer afId) {
        SupervisorFeedback feedback = feedbackMapper.findById(afId);
        if (feedback == null) {
            throw new IllegalArgumentException("反馈不存在");
        }
        if (feedback.getStatus() != null && feedback.getStatus() != 0) {
            throw new IllegalStateException("该反馈已指派，不能重复操作");
        }
        return feedback;
    }

    private GridMember requireMember(Integer gridMemberId) {
        GridMember member = gridMemberMapper.findById(gridMemberId);
        if (member == null) {
            throw new IllegalArgumentException("网格员不存在");
        }
        return member;
    }
}
