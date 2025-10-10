package crm.core.validator;

public class Validator {
    public final static String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    public final static String phoneRegex = "^(\\+\\d{1,3}[- ]?)?\\d{10}$";
    public final static String usernameRegex = "^[a-zA-Z0-9._-]{3,}$";
    public final static String passwordRegex = "^[A-Za-z\\d@$!%*?&]{2,}$";

    public static boolean isValidEmail(String email) {
        return email != null && email.matches(emailRegex);
    }
    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches(phoneRegex);
    }
    public static boolean isValidUsername(String username) {
        return username != null && username.matches(usernameRegex);
    }
    public static boolean isValidPassword(String password) {
        return password != null && password.matches(passwordRegex);
    }
}
