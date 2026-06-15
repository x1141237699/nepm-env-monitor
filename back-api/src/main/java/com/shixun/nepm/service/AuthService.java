package com.shixun.nepm.service;

import com.shixun.nepm.entity.GridMember;
import com.shixun.nepm.entity.SysAdmin;
import com.shixun.nepm.entity.Supervisor;
import com.shixun.nepm.mapper.GridMemberMapper;
import com.shixun.nepm.mapper.SysAdminMapper;
import com.shixun.nepm.mapper.SupervisorMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class AuthService {
    private final SysAdminMapper sysAdminMapper;
    private final SupervisorMapper supervisorMapper;
    private final GridMemberMapper gridMemberMapper;

    public AuthService(SysAdminMapper sysAdminMapper, SupervisorMapper supervisorMapper,
                       GridMemberMapper gridMemberMapper) {
        this.sysAdminMapper = sysAdminMapper;
        this.supervisorMapper = supervisorMapper;
        this.gridMemberMapper = gridMemberMapper;
    }

    public Map<String, Object> adminLogin(String adminCode, String password) {
        SysAdmin admin = sysAdminMapper.findByCode(adminCode);
        if (admin == null || !admin.getPassword().equals(password)) {
            return null;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("token", UUID.randomUUID().toString().replace("-", ""));
        Map<String, Object> adminInfo = new HashMap<>();
        adminInfo.put("id", admin.getId());
        adminInfo.put("adminCode", admin.getAdminCode());
        adminInfo.put("adminName", admin.getAdminName());
        data.put("adminInfo", adminInfo);
        return data;
    }

    public Map<String, Object> supervisorLogin(String supervisorCode, String password) {
        Supervisor supervisor = supervisorMapper.findByCode(supervisorCode);
        if (supervisor == null || !supervisor.getPassword().equals(password)) {
            return null;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("token", UUID.randomUUID().toString().replace("-", ""));
        Map<String, Object> info = new HashMap<>();
        info.put("id", supervisor.getId());
        info.put("supervisorCode", supervisor.getSupervisorCode());
        info.put("supervisorName", supervisor.getSupervisorName());
        data.put("supervisorInfo", info);
        return data;
    }

    public Supervisor supervisorRegister(Supervisor supervisor) {
        if (supervisorMapper.findByCode(supervisor.getSupervisorCode()) != null) {
            return null;
        }
        supervisorMapper.insert(supervisor);
        return supervisor;
    }

    public Map<String, Object> gridLogin(String memberCode, String password) {
        GridMember member = gridMemberMapper.findByCode(memberCode);
        if (member == null || !member.getPassword().equals(password)) {
            return null;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("token", UUID.randomUUID().toString().replace("-", ""));
        Map<String, Object> info = new HashMap<>();
        info.put("id", member.getId());
        info.put("memberCode", member.getMemberCode());
        info.put("memberName", member.getMemberName());
        info.put("cityId", member.getCityId());
        data.put("gridInfo", info);
        return data;
    }
}
