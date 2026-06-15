package com.shixun.nepm.service;

import com.shixun.nepm.dto.GridSubmitRequest;
import com.shixun.nepm.common.PageResult;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.mapper.SupervisorFeedbackMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FeedbackService {
    private final SupervisorFeedbackMapper feedbackMapper;

    public FeedbackService(SupervisorFeedbackMapper feedbackMapper) {
        this.feedbackMapper = feedbackMapper;
    }

    public int submitFeedback(SupervisorFeedback feedback) {
        return feedbackMapper.insert(feedback);
    }

    public List<SupervisorFeedback> listAll() {
        return feedbackMapper.findAll();
    }

    public PageResult<SupervisorFeedback> page(int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<SupervisorFeedback> records = feedbackMapper.findPage(offset, pageSize);
        long total = feedbackMapper.countAll();
        return new PageResult<>(records, total);
    }

    public SupervisorFeedback getById(Integer id) {
        return feedbackMapper.findById(id);
    }

    public List<SupervisorFeedback> listByGridMember(Integer gridMemberId) {
        return feedbackMapper.findByGridMemberId(gridMemberId);
    }

    public List<SupervisorFeedback> listPendingByGridMember(Integer gridMemberId) {
        return feedbackMapper.findPendingByGridMemberId(gridMemberId);
    }

    public SupervisorFeedback getTaskForGridMember(Integer afId, Integer gridMemberId) {
        SupervisorFeedback feedback = feedbackMapper.findById(afId);
        if (feedback == null || !gridMemberId.equals(feedback.getGridMemberId())) {
            return null;
        }
        return feedback;
    }

    public void submitGridMeasure(GridSubmitRequest request) {
        SupervisorFeedback feedback = feedbackMapper.findById(request.getFeedbackId());
        if (feedback == null) {
            throw new IllegalArgumentException("任务不存在");
        }
        if (!request.getGridMemberId().equals(feedback.getGridMemberId())) {
            throw new IllegalStateException("无权操作该任务");
        }
        if (feedback.getStatus() == null || feedback.getStatus() != 1) {
            throw new IllegalStateException("任务状态不允许提交");
        }
        if (feedbackMapper.confirmWithMeasure(
                request.getFeedbackId(), request.getConfirmAqi(), request.getConfirmLevel(),
                request.getSo2(), request.getCo(), request.getPm25()) <= 0) {
            throw new IllegalStateException("提交失败");
        }
    }

    public boolean assign(Integer id, Integer gridMemberId) {
        return feedbackMapper.assign(id, gridMemberId) > 0;
    }

    public boolean confirm(Integer id, Integer confirmAqi, Integer confirmLevel) {
        return feedbackMapper.confirm(id, confirmAqi, confirmLevel) > 0;
    }
}
