package crm.common.model;

import crm.common.model.enums.FeedbackStatus;
import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Enumerated;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.OneToOne;
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

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "FeedbackDate", type = "DATETIME", nullable = false)
    private LocalDateTime feedbackDate;

    @Column(name = "ResponseDate", type = "DATETIME", nullable = false)
    private LocalDateTime responseDate;

    @Column(name = "CustomerID")
    private String customerID;

    @OneToOne(mappedBy = "requestID", joinColumn = "RequestID")
    private LazyReference<Request> requestID;

    @Enumerated
    @Column(name = "FeedbackStatus")
    private FeedbackStatus feedbackStatus;

    public FeedbackStatus getFeedbackStatus() {
        return feedbackStatus;
    }

    public void setFeedbackStatus(FeedbackStatus feedbackStatus) {
        this.feedbackStatus = feedbackStatus;
    }

    public LazyReference<Request> getRequestID() {
        return requestID;
    }

    public void setRequestID(LazyReference<Request> requestID) {
        this.requestID = requestID;
    }

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public LocalDateTime getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(LocalDateTime responseDate) {
        this.responseDate = responseDate;
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
                ", responseDate=" + responseDate +
                ", customerID='" + customerID + '\'' +
                ", requestID=" + requestID +
                ", feedbackStatus=" + feedbackStatus +
                '}';
    }

}
