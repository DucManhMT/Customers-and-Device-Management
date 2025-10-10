package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.OneToMany;
import java.util.List;

@Entity(tableName = "Role")
public class Role {
    @Key
    @Column(name = "RoleID", type = "INT")
    private Integer roleID;

    @Column(name = "RoleName", length = 50, unique = true)
    private String roleName;

    @OneToMany(mappedBy = "roleID", joinColumn = "RoleID", targetEntity = Account.class)
    List<Account> accounts;

    public Role() {
    }

    public Role(Integer roleID, String roleName) {
        this.roleID = roleID;
        this.roleName = roleName;
    }

    public Integer getRoleID() {
        return roleID;
    }

    public void setRoleID(Integer roleID) {
        this.roleID = roleID;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public List<Account> getAccounts() {
        return accounts;
    }

    public void setAccounts(List<Account> accounts) {
        this.accounts = accounts;
    }
}
