package com.shixun.nepm.dto;

import com.shixun.nepm.entity.GridMember;

import java.util.List;

public class AssignCandidatesDTO {
    private boolean hasLocalMembers;
    private List<GridMember> members;

    public AssignCandidatesDTO() {}

    public AssignCandidatesDTO(boolean hasLocalMembers, List<GridMember> members) {
        this.hasLocalMembers = hasLocalMembers;
        this.members = members;
    }

    public boolean isHasLocalMembers() { return hasLocalMembers; }
    public void setHasLocalMembers(boolean hasLocalMembers) { this.hasLocalMembers = hasLocalMembers; }
    public List<GridMember> getMembers() { return members; }
    public void setMembers(List<GridMember> members) { this.members = members; }
}
