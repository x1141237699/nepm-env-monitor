package com.shixun.nepm.controller;

import com.shixun.nepm.common.PageResult;
import com.shixun.nepm.common.Result;
import com.shixun.nepm.dto.AssignCandidatesDTO;
import com.shixun.nepm.dto.AssignRequest;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.service.AssignService;
import com.shixun.nepm.service.FeedbackService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/feedback")
public class FeedbackController {
    private final FeedbackService feedbackService;
    private final AssignService assignService;

    public FeedbackController(FeedbackService feedbackService, AssignService assignService) {
        this.feedbackService = feedbackService;
        this.assignService = assignService;
    }

    @GetMapping
    public Result<PageResult<SupervisorFeedback>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(feedbackService.page(pageNum, pageSize));
    }

    @GetMapping("/{afId}")
    public Result<SupervisorFeedback> detail(@PathVariable Integer afId) {
        SupervisorFeedback feedback = feedbackService.getById(afId);
        if (feedback == null) {
            return Result.error(404, "反馈不存在");
        }
        return Result.success(feedback);
    }

    @GetMapping("/{afId}/assign/local")
    public Result<AssignCandidatesDTO> localCandidates(@PathVariable Integer afId) {
        try {
            return Result.success(assignService.getLocalCandidates(afId));
        } catch (IllegalArgumentException e) {
            return Result.error(404, e.getMessage());
        } catch (IllegalStateException e) {
            return Result.error(400, e.getMessage());
        }
    }

    @GetMapping("/{afId}/assign/other")
    public Result<AssignCandidatesDTO> otherCandidates(@PathVariable Integer afId) {
        try {
            return Result.success(assignService.getOtherProvinceCandidates(afId));
        } catch (IllegalArgumentException e) {
            return Result.error(404, e.getMessage());
        } catch (IllegalStateException e) {
            return Result.error(400, e.getMessage());
        }
    }

    @PostMapping("/{afId}/assign")
    public Result<String> assign(@PathVariable Integer afId, @RequestBody AssignRequest request) {
        if (request.getGridMemberId() == null || request.getAssignType() == null) {
            return Result.error(400, "参数不完整");
        }
        try {
            if ("other".equals(request.getAssignType())) {
                assignService.assignOtherProvince(afId, request.getGridMemberId());
            } else {
                assignService.assignLocal(afId, request.getGridMemberId());
            }
            return Result.success("指派成功");
        } catch (IllegalArgumentException e) {
            return Result.error(404, e.getMessage());
        } catch (IllegalStateException e) {
            return Result.error(400, e.getMessage());
        }
    }
}
