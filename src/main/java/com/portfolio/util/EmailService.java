package com.portfolio.util;

import com.portfolio.model.RecruiterMessage;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * Handles sending recruiter contact form notifications via SMTP (Jakarta Mail).
 * All credentials and settings are read from environment variables or JVM system properties.
 */
public class EmailService {

    public static String getConfig(String envKey, String sysPropKey, String defaultValue) {
        String val = System.getProperty(sysPropKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        val = System.getProperty(envKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        val = System.getenv(envKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        String secretVal = DBConnection.getSecret(envKey, sysPropKey, null);
        if (secretVal != null && !secretVal.trim().isEmpty()) {
            return secretVal.trim();
        }
        return defaultValue;
    }

    public static void sendContactEmail(RecruiterMessage msg, String defaultRecipientEmail) throws Exception {
        String smtpHost = getConfig("SMTP_HOST", "smtp.host",
                getConfig("MAIL_HOST", "mail.host", "smtp.gmail.com"));
        String smtpPort = getConfig("SMTP_PORT", "smtp.port",
                getConfig("MAIL_PORT", "mail.port", "587"));
        String smtpUser = getConfig("SMTP_USERNAME", "smtp.username",
                getConfig("MAIL_USERNAME", "mail.username",
                        getConfig("SMTP_USER", "smtp.user", "")));
        String smtpPass = getConfig("SMTP_PASSWORD", "smtp.password",
                getConfig("MAIL_PASSWORD", "mail.password",
                        getConfig("SMTP_PASS", "smtp.pass", "")));
        String recipientEmail = getConfig("CONTACT_RECEIVER_EMAIL", "contact.receiver.email",
                getConfig("MAIL_TO", "mail.to",
                        (defaultRecipientEmail != null && !defaultRecipientEmail.trim().isEmpty())
                                ? defaultRecipientEmail.trim()
                                : (!smtpUser.isEmpty() ? smtpUser : "siddhiarote5@gmail.com")));

        boolean allowLocalUnauth = "true".equalsIgnoreCase(
                getConfig("SMTP_ALLOW_UNAUTH_LOCAL", "smtp.allow.unauth.local", "false"));

        if ((smtpUser.isEmpty() || smtpPass.isEmpty()) && !allowLocalUnauth) {
            throw new IllegalStateException("SMTP credentials (SMTP_USERNAME and SMTP_PASSWORD) are not configured.");
        }

        boolean useAuth = !smtpUser.isEmpty() && !smtpPass.isEmpty();
        String defaultStartTls = "587".equals(smtpPort) ? "true" : "false";
        boolean useStartTls = "true".equalsIgnoreCase(
                getConfig("SMTP_STARTTLS", "smtp.starttls", defaultStartTls));
        boolean useSsl = "465".equals(smtpPort) || "true".equalsIgnoreCase(
                getConfig("SMTP_SSL", "smtp.ssl", "false"));

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", String.valueOf(useAuth));
        props.put("mail.smtp.starttls.enable", String.valueOf(useStartTls));
        if (useStartTls) {
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        }
        if (useSsl) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        }
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        Session mailSession;
        if (useAuth) {
            final String authUser = smtpUser;
            final String authPass = smtpPass;
            mailSession = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(authUser, authPass);
                }
            });
        } else {
            mailSession = Session.getInstance(props);
        }

        String senderName = sanitizeHeader(msg.getRecruiterName());
        String senderEmail = sanitizeHeader(msg.getRecruiterEmail());
        String subjectLine = sanitizeHeader(msg.getRoleOffered());
        String company = msg.getCompanyName() != null ? sanitizeHeader(msg.getCompanyName()) : "";
        String phone = msg.getRecruiterPhone() != null ? sanitizeHeader(msg.getRecruiterPhone()) : "";
        String bodyText = msg.getMessage() != null ? msg.getMessage().trim() : "";

        String fromAddress = !smtpUser.isEmpty() ? smtpUser : recipientEmail;

        MimeMessage mimeMessage = new MimeMessage(mailSession);
        mimeMessage.setFrom(new InternetAddress(fromAddress, "Portfolio Contact (" + senderName + ")", "UTF-8"));
        mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail, false));
        mimeMessage.setReplyTo(new Address[]{new InternetAddress(senderEmail, senderName, "UTF-8")});
        mimeMessage.setSubject("[Portfolio Contact] " + subjectLine + " - from " + senderName, "UTF-8");

        StringBuilder emailBody = new StringBuilder();
        emailBody.append("You have received a new contact message from your portfolio website.\n");
        emailBody.append("==================================================================\n\n");
        emailBody.append("Name:    ").append(senderName).append("\n");
        emailBody.append("Email:   ").append(senderEmail).append("\n");
        emailBody.append("Subject: ").append(subjectLine).append("\n");
        if (!company.isEmpty() && !"Direct Portfolio Inquiry".equalsIgnoreCase(company)) {
            emailBody.append("Company: ").append(company).append("\n");
        }
        if (!phone.isEmpty()) {
            emailBody.append("Phone:   ").append(phone).append("\n");
        }
        emailBody.append("\nMessage:\n");
        emailBody.append("------------------------------------------------------------------\n");
        emailBody.append(bodyText).append("\n");
        emailBody.append("------------------------------------------------------------------\n\n");
        emailBody.append("You can reply directly to this email to respond to ").append(senderName)
                .append(" (").append(senderEmail).append(").\n");

        mimeMessage.setText(emailBody.toString(), "UTF-8");
        Transport.send(mimeMessage);
    }

    private static String sanitizeHeader(String input) {
        if (input == null) return "";
        return input.replace("\r", "").replace("\n", "").trim();
    }
}
