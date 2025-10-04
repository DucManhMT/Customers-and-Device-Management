# Customers and Device Management

## Configuration Setup

Before running the application, you must create a configuration file for application properties.

### Step 1: Create `application.properties`

Create the file at:

```
src/main/resources/META-INF/application.properties
```

### Step 2: Add the following sample content

```
mail.username=your_email@gmail.com
mail.password=your_mail_password
repository.url=jdbc:mysql://localhost:3306/your_database
repository.username=your_db_username
repository.password=your_db_password
repository.driver-class-name=com.mysql.cj.jdbc.Driver
repository.show-sql=true
```

Replace the placeholder values with your actual email and database credentials.

---

**Note:** The application will not start correctly without this file. Make sure to keep your credentials secure and do not share them publicly.

---

_Last updated: September 27, 2025_

