package crm;

import crm.core.service.MailService;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        MailService mailService = new MailService();
        mailService.sendEmail("hunterskg1@gmail.com", "Test Subject", "This is a test email body.",
                "hunterskg1@gmail.com");
    }
}
