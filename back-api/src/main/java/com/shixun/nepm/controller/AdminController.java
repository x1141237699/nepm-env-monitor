package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.entity.GridMember;
import com.shixun.nepm.entity.SupervisorFeedback;
import com.shixun.nepm.mapper.GridMemberMapper;
import com.shixun.nepm.service.FeedbackService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
public class AdminController {
    private final FeedbackService feedbackService;
    private final GridMemberMapper gridMemberMapper;

    public AdminController(FeedbackService feedbackService, GridMemberMapper gridMemberMapper) {
        this.feedbackService = feedbackService;
        this.gridMemberMapper = gridMemberMapper;
    }

    @GetMapping("/feedback/list")
    public Result<List<SupervisorFeedback>> listFeedback() {
        return Result.success(feedbackService.listAll());
    }

    @GetMapping("/feedback/{id}")
    public Result<SupervisorFeedback> getFeedback(@PathVariable Integer id) {
        SupervisorFeedback feedback = feedbackService.getById(id);
        if (feedback == null) {
            return Result.error(404, "反馈不存在");
        }
        return Result.success(feedback);
    }

    @PostMapping("/feedback/assign")
    public Result<String> assignFeedback(@RequestBody Map<String, Integer> body) {
        Integer id = body.get("feedbackId");
        Integer gridMemberId = body.get("gridMemberId");
        if (id == null || gridMemberId == null) {
            return Result.error(400, "参数不完整");
        }
        if (!feedbackService.assign(id, gridMemberId)) {
            return Result.error(500, "指派失败");
        }
        return Result.success("指派成功");
    }

    @GetMapping("/grid-members")
    public Result<List<GridMember>> listGridMembers() {
        return Result.success(gridMemberMapper.findAll());
    }
}
