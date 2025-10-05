package crm.common.model;
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

    public void setRole(Role role) {
        if (role != null) {
            this.role = new LazyReference<>(Role.class, role.getRoleID());
        } else {
            this.role = null;
        }
    }
    public Role getRole() {
        return role.get();
    }

    @Override
    public String toString() {
        return "Account{" +
                "username='" + username + '\'' +
                ", passwordHash='" + passwordHash + '\'' +
                ", accountStatus=" + accountStatus +
                ", role=" + role +
                '}';
    }
}
