package crm.common;

public class URLConstants {

    // REGISTRATION
    public static final String HOME = "/";
    public static final String AUTH_LOGOUT = "/auth/logout";
    public static final String AUTH_STAFF_LOGIN = "/auth/staff_login";
    public static final String AUTH_CUSTOMER_LOGIN = "/auth/customer_login";
    public static final String AUTH_CUSTOMER_REGISTER = "/auth/customer_register";

    // ADMIN
    public static final String ADMIN_VIEW_ROLE_LIST = "/admin/role_list";
    public static final String ADMIN_VIEW_ROLE_DETAIL = "/admin/role_list/view_role_detail";
    public static final String ADMIN_EDIT_ROLE = "/admin/role_list/edit_role";
    public static final String ADMIN_CREATE_ROLE = "/admin/role_list/create_role";
    public static final String ADMIN_VIEW_ACCOUNT_LIST = "/admin/account_list";
    // STAFF

    // CUSTOMER
    public static final String CUSTOMER_VIEW_CONTRACT_HISTORY = "/customer/contract_history";
    public static final String CUSTOMER_CREATE_FEEDBACK = "/feedback/create";
    public static final String CUSTOMER_VIEW_FEEDBACK = "/feedback/view";
    public static final String CUSTOMER_VIEW_FEEDBACK_LIST = "/feedback/list";
    // CUSTOMER SUPPORTER
    public static final String CUSTOMER_SUPPORTER_CREATE_CONTRACT = "/customer_supporter/create_contract";

    // TECHNICAL LEADER
    public static final String TECHLEAD_SELECT_TECHNICIAN = "/task/selectTechnician";
    public static final String TECHLEAD_VIEW_APROVED_TASK = "/task/viewAprovedTask";
    public static final String TECHLEAD_VIEW_TECHEM_LIST = "/tech/employees";
    public static final String TECHLEAD_VIEW_TECHEM_DETAIL = "/tech/employees/view";

    // TECHNICAL EMPLOYEE
    public static final String TECHEM_UPDATE_TASK_STATUS = "/task/updateStatus";
    public static final String TECHEM_VIEW_ASSIGNED_TASK = "/task/viewAssignedTasks";

    // WAREHOUSE KEEPER

    // TASK
    public static final String TASK_PROCESS_ASSIGNMENT = "/task/processAssignment";
    public static final String TASK_DETAIL = "/task/detail";

}
