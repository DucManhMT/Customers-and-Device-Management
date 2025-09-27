package com.fpt.crm.core.service;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailService {
public void sendEmail(String to, String subject, String body,String email ) {
    Properties props = new Properties();
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");

    Session session = Session.getInstance(props, new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication("tuna26hn@gmail.com","vpum snkr pmdo xmdk");
        }
    });

    try {
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(email));
        message.setRecipients(jakarta.mail.Message.RecipientType.TO, to);
        message.setSubject(subject);
        message.setText(body);

     Transport.send(message);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
