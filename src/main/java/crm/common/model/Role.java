package crm.common.model;

import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;

@Entity(tableName = "Role")
public class Role {
    @Key
    @Column(name = "RoleID", type = "INT")
    private Integer roleID;

    @Column(name = "RoleName", length = 50, unique = true)
    private String roleName;

    public Integer getRoleID() { return roleID; }
    public void setRoleID(Integer roleID) { this.roleID = roleID; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}
