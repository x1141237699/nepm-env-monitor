package com.shixun.nepm.controller;

import com.shixun.nepm.common.Result;
import com.shixun.nepm.entity.Supervisor;
import com.shixun.nepm.service.AuthService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/admin/login")
    public Result<Map<String, Object>> adminLogin(@RequestBody Map<String, String> body) {
        String adminCode = body.get("adminCode");
        String password = body.get("password");
        if (adminCode == null || password == null) {
            return Result.error(400, "账号和密码不能为空");
        }
        Map<String, Object> data = authService.adminLogin(adminCode, password);
        if (data == null) {
            return Result.error(401, "账号或密码错误");
        }
        return Result.success(data);
    }

    @PostMapping("/supervisor/login")
    public Result<Map<String, Object>> supervisorLogin(@RequestBody Map<String, String> body) {
        String supervisorCode = body.get("supervisorCode");
        String password = body.get("password");
        if (supervisorCode == null || password == null) {
            return Result.error(400, "账号和密码不能为空");
        }
        Map<String, Object> data = authService.supervisorLogin(supervisorCode, password);
        if (data == null) {
            return Result.error(401, "账号或密码错误");
        }
        return Result.success(data);
    }

    @PostMapping("/supervisor/register")
    public Result<Supervisor> supervisorRegister(@RequestBody Supervisor supervisor) {
        if (supervisor.getSupervisorCode() == null || supervisor.getPassword() == null) {
            return Result.error(400, "账号和密码不能为空");
        }
        if (supervisor.getSupervisorName() == null) {
            supervisor.setSupervisorName(supervisor.getSupervisorCode());
        }
        Supervisor created = authService.supervisorRegister(supervisor);
        if (created == null) {
            return Result.error(400, "账号已存在");
        }
        created.setPassword(null);
        return Result.success(created);
    }

    @PostMapping("/grid/login")
    public Result<Map<String, Object>> gridLogin(@RequestBody Map<String, String> body) {
        String memberCode = body.get("memberCode");
        String password = body.get("password");
        if (memberCode == null || password == null) {
            return Result.error(400, "账号和密码不能为空");
        }
        Map<String, Object> data = authService.gridLogin(memberCode, password);
        if (data == null) {
            return Result.error(401, "账号或密码错误");
        }
        return Result.success(data);
    }
}
