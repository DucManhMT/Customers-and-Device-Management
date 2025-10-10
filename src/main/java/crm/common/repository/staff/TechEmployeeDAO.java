package crm.common.repository.staff;

import crm.common.model.Staff;
import crm.core.config.TransactionManager;
import crm.service_request.repository.persistence.AbstractRepository;
import crm.service_request.repository.persistence.query.common.Order;
import crm.service_request.repository.persistence.query.common.Page;
import crm.service_request.repository.persistence.query.common.PageRequest;
import crm.service_request.repository.persistence.query.common.Sort;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TechEmployeeDAO extends AbstractRepository<Staff, Integer> {

    public TechEmployeeDAO() {
        super(Staff.class);
    }

    public List<Staff> findTechEmployeesByRoleId(int roleId) throws SQLException {
        List<Staff> techEmployees = new ArrayList<>();
        Connection connection = TransactionManager.getConnection();

        String query = "SELECT s.StaffID, s.StaffName, s.Phone, s.Address, s.Email, " +
                "s.Image, s.DateOfBirth, s.Username " +
                "FROM Staff s " +
                "INNER JOIN Account a ON s.Username = a.Username " +
                "WHERE a.RoleID = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, roleId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Staff staff = new Staff();
                    staff.setStaffID(resultSet.getInt("StaffID"));
                    staff.setStaffName(resultSet.getString("StaffName"));
                    staff.setPhone(resultSet.getString("Phone"));
                    staff.setAddress(resultSet.getString("Address"));
                    staff.setEmail(resultSet.getString("Email"));
                    staff.setImage(resultSet.getString("Image"));
                    staff.setDateOfBirth(resultSet.getDate("DateOfBirth"));

                    techEmployees.add(staff);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employees", e);
        }

        return techEmployees;
    }

    public Page<Staff> findTechEmployeesPaginated(int roleId, int page, int size) throws SQLException {
        List<Staff> techEmployees = new ArrayList<>();
        int totalElements = 0;
        Connection connection = TransactionManager.getConnection();

        String countQuery = "SELECT COUNT(*) FROM Staff s " +
                "INNER JOIN Account a ON s.Username = a.Username " +
                "WHERE a.RoleID = ?";

        try (PreparedStatement countStatement = connection.prepareStatement(countQuery)) {
            countStatement.setInt(1, roleId);
            try (ResultSet countResult = countStatement.executeQuery()) {
                if (countResult.next()) {
                    totalElements = countResult.getInt(1);
                }
            }
        }

        String query = "SELECT s.StaffID, s.StaffName, s.Phone, s.Address, s.Email, " +
                "s.Image, s.DateOfBirth, s.Username " +
                "FROM Staff s " +
                "INNER JOIN Account a ON s.Username = a.Username " +
                "WHERE a.RoleID = ? " +
                "ORDER BY s.StaffName " +
                "LIMIT ? OFFSET ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, roleId);
            statement.setInt(2, size);
            statement.setInt(3, (page - 1) * size);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Staff staff = new Staff();
                    staff.setStaffID(resultSet.getInt("StaffID"));
                    staff.setStaffName(resultSet.getString("StaffName"));
                    staff.setPhone(resultSet.getString("Phone"));
                    staff.setAddress(resultSet.getString("Address"));
                    staff.setEmail(resultSet.getString("Email"));
                    staff.setImage(resultSet.getString("Image"));
                    staff.setDateOfBirth(resultSet.getDate("DateOfBirth"));

                    techEmployees.add(staff);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve paginated tech employees", e);
        }

        PageRequest pageRequest = new PageRequest(page, size, Sort.by(Order.asc("StaffName")));
        return new Page<>(totalElements, pageRequest, techEmployees);
    }

    public Staff findTechEmployeeById(int staffId) throws SQLException {
        Connection connection = TransactionManager.getConnection();

        String query = "SELECT s.StaffID, s.StaffName, s.Phone, s.Address, s.Email, " +
                "s.Image, s.DateOfBirth, s.Username " +
                "FROM Staff s " +
                "INNER JOIN Account a ON s.Username = a.Username " +
                "WHERE s.StaffID = ? AND a.RoleID = 5";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, staffId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    Staff staff = new Staff();
                    staff.setStaffID(resultSet.getInt("StaffID"));
                    staff.setStaffName(resultSet.getString("StaffName"));
                    staff.setPhone(resultSet.getString("Phone"));
                    staff.setAddress(resultSet.getString("Address"));
                    staff.setEmail(resultSet.getString("Email"));
                    staff.setImage(resultSet.getString("Image"));
                    staff.setDateOfBirth(resultSet.getDate("DateOfBirth"));

                    return staff;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve tech employee by ID", e);
        }

        return null;
    }

    public Page<Staff> findTechEmployeesWithFilters(int roleId, String searchName, String location,
            String ageRange, int page, int size) throws SQLException {
        List<Staff> techEmployees = new ArrayList<>();
        int totalElements = 0;
        Connection connection = TransactionManager.getConnection();

        StringBuilder queryBuilder = new StringBuilder();
        StringBuilder countQueryBuilder = new StringBuilder();
        List<Object> parameters = new ArrayList<>();

        String baseQuery = "FROM Staff s INNER JOIN Account a ON s.Username = a.Username WHERE a.RoleID = ?";

        queryBuilder.append(
                "SELECT s.StaffID, s.StaffName, s.Phone, s.Address, s.Email, s.Image, s.DateOfBirth, s.Username ");
        queryBuilder.append(baseQuery);

        countQueryBuilder.append("SELECT COUNT(*) ");
        countQueryBuilder.append(baseQuery);

        parameters.add(roleId);

        if (searchName != null && !searchName.trim().isEmpty()) {
            String searchCondition = " AND (s.StaffName LIKE ? OR s.StaffID LIKE ?)";
            queryBuilder.append(searchCondition);
            countQueryBuilder.append(searchCondition);
            String searchPattern = "%" + searchName.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (location != null && !location.trim().isEmpty()) {
            String locationCondition = " AND s.Address LIKE ?";
            queryBuilder.append(locationCondition);
            countQueryBuilder.append(locationCondition);
            parameters.add("%" + location.trim() + "%");
        }

        if (ageRange != null && !ageRange.trim().isEmpty()) {
            String ageCondition = getAgeCondition(ageRange);
            if (ageCondition != null) {
                queryBuilder.append(ageCondition);
                countQueryBuilder.append(ageCondition);
            }
        }

        try (PreparedStatement countStatement = connection.prepareStatement(countQueryBuilder.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                countStatement.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet countResult = countStatement.executeQuery()) {
                if (countResult.next()) {
                    totalElements = countResult.getInt(1);
                }
            }
        }

        queryBuilder.append(" ORDER BY s.StaffName LIMIT ? OFFSET ?");

        try (PreparedStatement statement = connection.prepareStatement(queryBuilder.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            statement.setInt(parameters.size() + 1, size);
            statement.setInt(parameters.size() + 2, (page - 1) * size);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Staff staff = new Staff();
                    staff.setStaffID(resultSet.getInt("StaffID"));
                    staff.setStaffName(resultSet.getString("StaffName"));
                    staff.setPhone(resultSet.getString("Phone"));
                    staff.setAddress(resultSet.getString("Address"));
                    staff.setEmail(resultSet.getString("Email"));
                    staff.setImage(resultSet.getString("Image"));
                    staff.setDateOfBirth(resultSet.getDate("DateOfBirth"));

                    techEmployees.add(staff);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve filtered tech employees", e);
        }

        PageRequest pageRequest = new PageRequest(page, size, Sort.by(Order.asc("StaffName")));
        return new Page<>(totalElements, pageRequest, techEmployees);
    }

    private String getAgeCondition(String ageRange) {
        // Base condition to ensure DateOfBirth is not null
        String baseCondition = " AND s.DateOfBirth IS NOT NULL";

        switch (ageRange.toLowerCase()) {
            case "18-25":
                return baseCondition
                        + " AND (YEAR(CURDATE()) - YEAR(s.DateOfBirth) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(s.DateOfBirth, '%m%d'))) BETWEEN 18 AND 25";
            case "26-35":
                return baseCondition
                        + " AND (YEAR(CURDATE()) - YEAR(s.DateOfBirth) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(s.DateOfBirth, '%m%d'))) BETWEEN 26 AND 35";
            case "36-45":
                return baseCondition
                        + " AND (YEAR(CURDATE()) - YEAR(s.DateOfBirth) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(s.DateOfBirth, '%m%d'))) BETWEEN 36 AND 45";
            case "46-55":
                return baseCondition
                        + " AND (YEAR(CURDATE()) - YEAR(s.DateOfBirth) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(s.DateOfBirth, '%m%d'))) BETWEEN 46 AND 55";
            case "56+":
                return baseCondition
                        + " AND (YEAR(CURDATE()) - YEAR(s.DateOfBirth) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(s.DateOfBirth, '%m%d'))) >= 56";
            default:
                return null;
        }
    }

    public List<String> getDistinctLocations(int roleId) throws SQLException {
        List<String> locations = new ArrayList<>();
        Connection connection = TransactionManager.getConnection();

        String query = "SELECT DISTINCT s.Address FROM Staff s " +
                "INNER JOIN Account a ON s.Username = a.Username " +
                "WHERE a.RoleID = ? AND s.Address IS NOT NULL AND s.Address != '' " +
                "ORDER BY s.Address";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, roleId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String address = resultSet.getString("Address");
                    if (address != null && !address.trim().isEmpty()) {
                        locations.add(address.trim());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Failed to retrieve distinct locations", e);
        }

        return locations;
    }
}