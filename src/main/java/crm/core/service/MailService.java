package crm.core.service;

import crm.core.config.PropertyLoader;
import jakarta.mail.*;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailService {

    private static final String SMTP_HOST = PropertyLoader.get("mail.smtp.host", "smtp.gmail.com");
    private static final String SMTP_PORT = PropertyLoader.get("mail.smtp.port", "587");
    private static final boolean SMTP_STARTTLS = PropertyLoader.getBoolean("mail.smtp.starttls.enable", true);
    private static final boolean SMTP_AUTH = PropertyLoader.getBoolean("mail.smtp.auth", true);
    private static final String USERNAME = PropertyLoader.get("mail.username", "");
    private static final String PASSWORD = PropertyLoader.get("mail.password", "");

    public static void sendEmail(String to, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", Boolean.toString(SMTP_AUTH));
        props.put("mail.smtp.starttls.enable", Boolean.toString(SMTP_STARTTLS));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setRecipients(Message.RecipientType.TO, to);
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
