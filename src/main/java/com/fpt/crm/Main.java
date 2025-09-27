package com.fpt.crm;

import com.fpt.crm.core.service.MailService;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        MailService mailService = new MailService();
        mailService.sendEmail("brosskt123@gmail.com","Test Subject","This is a test email body.","tuna26hn@gmail.com");
    }
}
