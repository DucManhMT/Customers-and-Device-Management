package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

import java.time.LocalDateTime;

@Entity(tableName = "Feedback")
public class Feedback {
    @Key
    @Column(name = "FeedbackID", type = "INT")
    private Integer feedbackID;

    @Column(name = "Content", length = 255)
    private String content;

    @Column(name = "Rating", type = "INT")
    private Integer rating;

    @Column(name = "Response", length = 255)
    private String response;

    @Column(name = "FeedbackDate", type = "DATETIME", nullable = false)
    private LocalDateTime feedbackDate;

    @ManyToOne(joinColumn = "Username")
    private LazyReference<Account> account;

    public Integer getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(Integer feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public LocalDateTime getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(LocalDateTime feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public Account getAccount() {
        return account.get();
    }

    public void setAccount(Account account) {
        this.account = new LazyReference<>(Account.class, account.getUsername());
    }
}
