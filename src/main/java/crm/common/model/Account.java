package crm.common.model;
import crm.auth.service.Hasher;
import crm.common.model.enums.AccountStatus;
import crm.core.repository.hibernate.annotation.*;
import crm.core.repository.hibernate.entitymanager.LazyReference;


@Entity(tableName = "Account")
public class Account {
    @Key
    @Column(name = "Username")
    private String username;

    @Column(name = "PasswordHash")
    private String passwordHash;

    // Stored as VARCHAR in DB representing ENUM
    @Enumerated
    @Column(name = "AccountStatus")
    private AccountStatus accountStatus;

    @ManyToOne(joinColumn = "RoleID")
    LazyReference<Role> role;

    public Account() {
    }

    public Account(String username, String passwordHash, AccountStatus accountStatus, Role role) {
        this.username = username;
        this.passwordHash = Hasher.hashPassword(passwordHash);
        this.accountStatus = accountStatus;
        this.role = new LazyReference<>(Role.class, role.getRoleID());
    }

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
        this.passwordHash = Hasher.hashPassword(passwordHash);
    }

    public AccountStatus getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(AccountStatus accountStatus) {
        this.accountStatus = accountStatus;
    }

    public void setRole(Role role) {
        this.role = new LazyReference<>(Role.class, role.getRoleID());
    }
    public Role getRole() {
        return role.get();
    }

}
