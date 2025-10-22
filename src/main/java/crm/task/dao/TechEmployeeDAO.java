//package crm.task.dao;
//
//import crm.common.model.Staff;
//import crm.common.model.Account;
//import crm.core.repository.hibernate.entitymanager.EntityManager;
//import crm.core.config.DBcontext;
//import crm.service_request.repository.persistence.AbstractRepository;
//import crm.service_request.repository.persistence.query.common.Order;
//import crm.service_request.repository.persistence.query.common.Page;
//import crm.service_request.repository.persistence.query.common.PageRequest;
//import crm.service_request.repository.persistence.query.common.Sort;
//
//import java.sql.Connection;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.stream.Collectors;
//
//public class TechEmployeeDAO extends AbstractRepository<Staff, Integer> {
//
//    public TechEmployeeDAO() {
//        super(Staff.class);
//    }
//
//    public List<Staff> findTechEmployeesByRoleId(int roleId) throws Exception {
//        try (Connection connection = DBcontext.getConnection();
//             EntityManager entityManager = new EntityManager(connection)) {
//
//            List<Account> allAccounts = entityManager.findAll(Account.class);
//            List<Staff> allStaff = entityManager.findAll(Staff.class);
//
//            List<Staff> technicians = new ArrayList<>();
//
//            for (Account account : allAccounts) {
//                try {
//                    if (account.getRole() != null &&
//                        account.getRole().getRoleID() != null &&
//                        account.getRole().getRoleID().equals(roleId)) {
//
//                        for (Staff staff : allStaff) {
//                            if (staff.getAccount() != null &&
//                                account.getUsername().equals(staff.getAccount().getUsername())) {
//                                staff.setAccount(account);
//                                technicians.add(staff);
//                                break;
//                            }
//                        }
//                    }
//                } catch (Exception e) {
//                    System.err.println("Error processing account: " + account.getUsername() + " - " + e.getMessage());
//                    continue;
//                }
//            }
//
//            return technicians;
//        }
//    }
//
//    public Page<Staff> findTechEmployeesPaginated(int roleId, int page, int size) throws Exception {
//        try (Connection connection = DBcontext.getConnection();
//             EntityManager entityManager = new EntityManager(connection)) {
//
//            List<Staff> allTechnicians = findTechEmployeesByRoleId(roleId);
//
//            int totalElements = allTechnicians.size();
//
//            int startIndex = (page - 1) * size;
//            int endIndex = Math.min(startIndex + size, totalElements);
//
//            List<Staff> paginatedTechnicians = new ArrayList<>();
//            if (startIndex < totalElements) {
//                paginatedTechnicians = allTechnicians.subList(startIndex, endIndex);
//            }
//
//            PageRequest pageRequest = new PageRequest(page, size, Sort.by(Order.asc("StaffName")));
//            return new Page<>(totalElements, pageRequest, paginatedTechnicians);
//        }
//    }
//
//    public Staff findTechEmployeeById(int staffId) throws Exception {
//        try (Connection connection = DBcontext.getConnection();
//             EntityManager entityManager = new EntityManager(connection)) {
//
//            Staff staff = entityManager.find(Staff.class, staffId);
//            if (staff == null) {
//                return null;
//            }
//
//            Account account = staff.getAccount();
//            if (account != null && account.getRole() != null && account.getRole().getRoleID() == 5) {
//                return staff;
//            }
//
//            return null;
//        }
//    }
//
//    public Page<Staff> findTechEmployeesWithFilters(int roleId, String searchName, String location,
//            String ageRange, int page, int size) throws Exception {
//        try (Connection connection = DBcontext.getConnection();
//             EntityManager entityManager = new EntityManager(connection)) {
//
//            List<Staff> allTechnicians = findTechEmployeesByRoleId(roleId);
//
//            List<Staff> filteredTechnicians = allTechnicians.stream()
//                .filter(staff -> {
//                    if (searchName != null && !searchName.trim().isEmpty()) {
//                        String search = searchName.toLowerCase();
//                        boolean nameMatch = staff.getStaffName().toLowerCase().contains(search);
//                        boolean idMatch = staff.getStaffID().toString().contains(search);
//                        if (!nameMatch && !idMatch) {
//                            return false;
//                        }
//                    }
//
//                    if (location != null && !location.trim().isEmpty()) {
//                        if (staff.getAddress() == null ||
//                            !staff.getAddress().toLowerCase().contains(location.toLowerCase())) {
//                            return false;
//                        }
//                    }
//
//                    if (ageRange != null && !ageRange.trim().isEmpty()) {
//                        if (staff.getDateOfBirth() != null) {
//                            int age = calculateAge(staff.getDateOfBirth());
//                            boolean ageMatches = isAgeInRange(age, ageRange.trim());
//                            System.out.println("Staff: " + staff.getStaffName() +
//                                ", Age: " + age +
//                                ", Range: " + ageRange +
//                                ", Matches: " + ageMatches);
//                            if (!ageMatches) {
//                                return false;
//                            }
//                        } else {
//                            // If birth date is null, exclude from age-filtered results
//                            System.out.println("Staff: " + staff.getStaffName() + " - No birth date, excluded from age filter");
//                            return false;
//                        }
//                    }
//
//                    return true;
//                })
//                .sorted((s1, s2) -> s1.getStaffName().compareTo(s2.getStaffName()))
//                .collect(Collectors.toList());
//
//            int totalElements = filteredTechnicians.size();
//
//            int startIndex = (page - 1) * size;
//            int endIndex = Math.min(startIndex + size, totalElements);
//
//            List<Staff> paginatedTechnicians = new ArrayList<>();
//            if (startIndex < totalElements) {
//                paginatedTechnicians = filteredTechnicians.subList(startIndex, endIndex);
//            }
//
//            PageRequest pageRequest = new PageRequest(page, size, Sort.by(Order.asc("StaffName")));
//            return new Page<>(totalElements, pageRequest, paginatedTechnicians);
//        }
//    }
//
//    public List<String> getDistinctLocations(int roleId) throws Exception {
//        try (Connection connection = DBcontext.getConnection();
//             EntityManager entityManager = new EntityManager(connection)) {
//
//            List<Staff> technicians = findTechEmployeesByRoleId(roleId);
//
//            return technicians.stream()
//                .map(Staff::getAddress)
//                .filter(address -> address != null && !address.trim().isEmpty())
//                .map(String::trim)
//                .distinct()
//                .sorted()
//                .collect(Collectors.toList());
//        }
//    }
//
//    private int calculateAge(java.sql.Date birthDate) {
//        if (birthDate == null) {
//            return 0;
//        }
//
//        java.time.LocalDate birth = birthDate.toLocalDate();
//        java.time.LocalDate now = java.time.LocalDate.now();
//        return java.time.Period.between(birth, now).getYears();
//    }
//
//    private boolean isAgeInRange(int age, String ageRange) {
//        if (ageRange == null || ageRange.trim().isEmpty()) {
//            return true;
//        }
//
//        String range = ageRange.toLowerCase().trim();
//
//        try {
//            if (range.startsWith("under-") || range.startsWith("dưới-")) {
//                String ageStr = range.substring(range.indexOf("-") + 1);
//                int maxAge = Integer.parseInt(ageStr);
//                return age < maxAge;
//            } else if (range.startsWith("over-") || range.startsWith("trên-")) {
//                String ageStr = range.substring(range.indexOf("-") + 1);
//                int minAge = Integer.parseInt(ageStr);
//                return age > minAge;
//            } else if (range.contains("-")) {
//                String[] parts = range.split("-");
//                if (parts.length == 2) {
//                    int minAge = Integer.parseInt(parts[0].trim());
//                    int maxAge = Integer.parseInt(parts[1].trim());
//                    return age >= minAge && age <= maxAge;
//                }
//            } else {
//                int exactAge = Integer.parseInt(range);
//                return age == exactAge;
//            }
//        } catch (NumberFormatException e) {
//            System.out.println("Invalid age range format: " + ageRange);
//            return true;
//        }
//
//        return true;
//    }
//}