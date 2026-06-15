package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.service.FeedbackService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/supervisor")
public class SupervisorController {
    private final FeedbackService feedbackService;

    public SupervisorController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @PostMapping("/feedback")
    public Result<SupervisorFeedback> submitFeedback(@RequestBody SupervisorFeedback feedback) {
        if (feedback.getSupervisorId() == null || feedback.getProvinceId() == null
                || feedback.getCityId() == null || feedback.getGridAddress() == null) {
            return Result.error(400, "必填参数不完整");
        }
        feedbackService.submitFeedback(feedback);
        return Result.success(feedback);
    }
}
