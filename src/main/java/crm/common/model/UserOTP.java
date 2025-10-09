package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;

import java.time.LocalDateTime;

@Entity(tableName = "UserOTP")
public class UserOTP {
    @Key
    @Column(name = "UserOTPID")
    private int UserOTPID;

    @Column(name = "Email")
    private String email;

    @Column(name = "OTPCode")
    private String otpCode;

    @Column(name = "ExpiredTime")
    private LocalDateTime expiredTime;

    public int getUserOTPID() {
        return UserOTPID;
    }

    public void setUserOTPID(int userOTPID) {
        UserOTPID = userOTPID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public LocalDateTime getExpiredTime() {
        return expiredTime;
    }

    public void setExpiredTime(LocalDateTime expiredTime) {
        this.expiredTime = expiredTime;
    }
}
