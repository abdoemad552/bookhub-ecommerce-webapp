package com.iti.jets.service.extra;

import com.iti.jets.model.dto.response.UserDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class EmailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailService.class);

    private static final Properties SMTP_CONFIG = new Properties();

    static {
        try (InputStream input = EmailService.class.getClassLoader()
                .getResourceAsStream("smtp_config.properties")) {

            SMTP_CONFIG.load(input);

        } catch (IOException e) {
            throw new RuntimeException("Failed to load SMTP config", e);
        }
    }

    private Session createSession() {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_CONFIG.getProperty("smtp.host"));
        props.put("mail.smtp.port", SMTP_CONFIG.getProperty("smtp.port"));

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        SMTP_CONFIG.getProperty("smtp.username"),
                        SMTP_CONFIG.getProperty("smtp.password")
                );
            }
        });
    }

    public void sendEmail(String to, String subject, String body) {

        try {

            Session session = createSession();

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_CONFIG.getProperty("smtp.username")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);

            LOGGER.info("Email sent to {}", to);

        } catch (MessagingException e) {
            LOGGER.error("Failed to send email to {}", to, e);
        }
    }

    public void sendLoginNotification(UserDTO user) {

        String subject = "🔐 New Login to BookHub";

        String body = """
                Hello %s,
                
                We noticed a new login to your BookHub account.
                
                If this was you, welcome back! 📚✨ No action needed — enjoy exploring BookHub.
                
                If you didn't log in, please secure your account immediately.
                
                Best Regards,
                BookHub Team
                """.formatted(user.getUsername());

        sendEmail(user.getEmail(), subject, body);
    }

    public void sendPlaceOrderNotification(UserDTO user, String orderId, double totalPrice) {

        String subject = "🛒 Your Order Has Been Placed Successfully!";

        String body = """
                Hello %s,
                
                Thank you for your order with BookHub 📚✨
                
                We’re happy to inform you that your order has been successfully placed and is now being processed.
                
                🧾 Order Details:
                Order ID: #%s
                Total Amount: %.2f EGP
                
                🚚 Delivery Information:
                Your order is expected to arrive within approximately 5 working days.
                
                📦 Need Help with Your Order?
                If you would like to cancel, return, or request a refund, please contact our customer support team as soon as possible.
                We’ll be happy to assist you.
                
                You can also track your order anytime from your account.
                
                Thank you for choosing BookHub 💙
                Happy reading!
                
                Best Regards,
                BookHub Team
                """.formatted(
                user.getUsername(),
                orderId,
                totalPrice
        );

        sendEmail(user.getEmail(), subject, body);
    }
}