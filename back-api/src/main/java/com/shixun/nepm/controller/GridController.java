package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.dto.GridSubmitRequest;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.service.FeedbackService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/grid")
public class GridController {
    private final FeedbackService feedbackService;

    public GridController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @GetMapping("/tasks")
    public Result<List<SupervisorFeedback>> listTasks(@RequestParam Integer gridMemberId) {
        return Result.success(feedbackService.listPendingByGridMember(gridMemberId));
    }

    @GetMapping("/tasks/{afId}")
    public Result<SupervisorFeedback> taskDetail(@PathVariable Integer afId,
                                                  @RequestParam Integer gridMemberId) {
        SupervisorFeedback feedback = feedbackService.getTaskForGridMember(afId, gridMemberId);
        if (feedback == null) {
            return Result.error(404, "任务不存在或无权访问");
        }
        return Result.success(feedback);
    }

    @PostMapping("/tasks/submit")
    public Result<String> submitTask(@RequestBody GridSubmitRequest request) {
        if (request.getFeedbackId() == null || request.getGridMemberId() == null
                || request.getSo2() == null || request.getCo() == null || request.getPm25() == null
                || request.getConfirmAqi() == null || request.getConfirmLevel() == null) {
            return Result.error(400, "参数不完整");
        }
        try {
            feedbackService.submitGridMeasure(request);
            return Result.success("提交成功");
        } catch (IllegalArgumentException e) {
            return Result.error(404, e.getMessage());
        } catch (IllegalStateException e) {
            return Result.error(400, e.getMessage());
        }
    }

    @GetMapping("/feedback/list")
    public Result<List<SupervisorFeedback>> listFeedback(@RequestParam Integer gridMemberId) {
        return Result.success(feedbackService.listByGridMember(gridMemberId));
    }

    @PostMapping("/feedback/confirm")
    public Result<String> confirmFeedback(@RequestBody Map<String, Integer> body) {
        Integer id = body.get("feedbackId");
        Integer confirmAqi = body.get("confirmAqi");
        Integer confirmLevel = body.get("confirmLevel");
        if (id == null || confirmAqi == null || confirmLevel == null) {
            return Result.error(400, "参数不完整");
        }
        if (!feedbackService.confirm(id, confirmAqi, confirmLevel)) {
            return Result.error(500, "确认失败");
        }
        return Result.success("确认成功");
    }
}
