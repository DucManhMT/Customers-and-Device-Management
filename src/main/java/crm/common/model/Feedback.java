package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
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

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "FeedbackDate", type = "DATETIME", nullable = false)
    private LocalDateTime feedbackDate;

    @Column(name = "CustomerID")
    private String customerID;

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
    public String getDescription() { return description; }

    public void setDescription(String description) { this.description = description; }

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

    public String getCustomerID() {
        return customerID;
    }
    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackID=" + feedbackID +
                ", content='" + content + '\'' +
                ", rating=" + rating +
                ", response='" + response + '\'' +
                ", description='" + description + '\'' +
                ", feedbackDate=" + feedbackDate +
                ", customerID='" + customerID + '\'' +
                '}';
    }
}
