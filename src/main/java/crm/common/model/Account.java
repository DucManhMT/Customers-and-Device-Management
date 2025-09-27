package crm.common.model;

public class Account {
    private String username;
    private String password;
    private boolean activeStatus;
    private int role;

    public Account() {}
    public Account(String username, String password, boolean activeStatus, int role) {
        this.username = username;
        this.password = password;
        this.activeStatus = activeStatus;
        this.role = role;
    }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public boolean isActiveStatus() { return activeStatus; }
    public void setActiveStatus(boolean activeStatus) { this.activeStatus = activeStatus; }
    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }
}

