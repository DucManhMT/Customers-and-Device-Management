package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;

@Entity(tableName = "Role")
public class Role {
    @Key
    @Column(name = "RoleID", type = "BIGINT")
    private Long roleID;

    @Column(name = "RoleName", length = 50, unique = true)
    private String roleName;

    public Long getRoleID() {
        return roleID;
    }

    public void setRoleID(Long roleID) {
        this.roleID = roleID;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
