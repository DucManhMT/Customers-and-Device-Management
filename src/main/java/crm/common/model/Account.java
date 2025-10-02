package crm.common.model;

import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.converter.AccountStatusConverter;
import crm.core.repository.persistence.annotation.Column;
import crm.core.repository.persistence.annotation.Entity;
import crm.core.repository.persistence.annotation.Key;
import crm.core.repository.persistence.annotation.ManyToOne;
import crm.core.repository.persistence.entity.convert.Convert;
import crm.core.repository.persistence.entity.load.LazyReference;
import crm.core.repository.persistence.entity.relation.FetchMode;

@Entity(tableName = "Account")
public class Account {
    @Key
    @Column(name = "Username", length = 100)
    private String username;

    @Column(name = "PasswordHash", length = 255, nullable = false)
    private String passwordHash;

    // Stored as VARCHAR in DB representing ENUM
    @Column(name = "AccountStatus", length = 20)
    @Convert(converter = AccountStatusConverter.class)
    private AccountStatus accountStatus;

    @Column(name = "RoleID", type = "INT")
    private Integer roleID;

    @ManyToOne(joinColumn = "RoleID", fetch = FetchMode.EAGER)
    private LazyReference<Role> role;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public AccountStatus getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(AccountStatus accountStatus) {
        this.accountStatus = accountStatus;
    }

    public Integer getRoleID() {
        return roleID;
    }

    public void setRoleID(Integer roleID) {
        this.roleID = roleID;
    }

    public Role getRole() {
        return role.get();
    }

    public void setRole(Role role) {
        this.role.setValue(role);
    }
}
