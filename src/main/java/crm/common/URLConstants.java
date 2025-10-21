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
    public static final String ADMIN_ACTION_CENTER = "/admin/admin_actioncenter";
    //STAFF
    
    public static final String STAFF_REQUEST_TIMELINE = "/staff/requests/timeline";
    // CUSTOMER
    public static final String CUSTOMER_VIEW_CONTRACT_HISTORY = "/customer/contract_history";
    public static final String CUSTOMER_VIEW_REQUEST = "/customer/requests";
    public static final String CUSTOMER_REQUEST_DETAIL = "/customer/requests/detail";
    public static final String CUSTOMER_CREATE_REQUEST = "/customer/requests/create";
    public static final String CUSTOMER_REQUEST_TIMELINE = "/customer/requests/timeline";
    // fix add customer path
    public static final String CUSTOMER_CREATE_FEEDBACK = "/feedback/create";
    public static final String CUSTOMER_VIEW_FEEDBACK = "/feedback/view";
    public static final String CUSTOMER_VIEW_FEEDBACK_LIST = "/feedback/list";

    // CUSTOMER SUPPORTER
    public static final String CUSTOMER_SUPPORTER_CREATE_CONTRACT = "/customer_supporter/create_contract";
    public static final String CUSTOMER_SUPPORTER_REQUEST_DASHBOARD = "/supporter/requests/dashboard";
    public static final String CUSTOMER_SUPPORTER_PROCESS_REQUEST = "/supporter/requests/process";
    public static final String CUSTOMER_SUPPORTER_REQUEST_DETAIL = "/supporter/requests/detail";
    public static final String CUSTOMER_SUPPORTER_REQUEST_LIST = "/supporter/requests/list";

    // TECHNICAL LEADER
    public static final String TECHLEAD_SELECT_TECHNICIAN = "/task/selectTechnician";
    public static final String TECHLEAD_VIEW_APROVED_TASK = "/task/viewAprovedTask";
    public static final String TECHLEAD_VIEW_TECHEM_LIST = "/tech/employees";
    public static final String TECHLEAD_VIEW_TECHEM_DETAIL = "/tech/employees/view";

    // TECHNICAL EMPLOYEE
    public static final String TECHEM_UPDATE_TASK_STATUS = "/task/updateStatus";
    public static final String TECHEM_VIEW_ASSIGNED_TASK = "/task/viewAssignedTasks";

    // TECHNICAL EMPLOYEE
    public static final String CREATE_PRODUCT_REQUEST = "/tech/employees/create_product_requests";

    // WAREHOUSE KEEPER
    public static final String WAREHOUSE_VIEW_PRODUCT_WAREHOUSE = "/warehouse_keeper/view_product_warehouse";
    public static final String WAREHOUSE_VIEW_PRODUCT_DETAIL = "/warehouse_keeper/view_product_detail";
    public static final String WAREHOUSE_VIEW_INVENTORY = "/warehouse_keeper/view_inventory";
    public static final String WAREHOUSE_ADD_PRODUCT = "/warehouse_keeper/add_product";
    public static final String WAREHOUSE_CREATE_EXPORT_REQUEST = "/warehouse_keeper/create_export_request";
    public static final String WAREHOUSE_VIEW_WAREHOUSE_DETAIL = "/warehouse_keeper/view_warehouse_detail";
    public static final String WAREHOUSE_VIEW_PRODUCT_REQUESTS = "/warehouse_keeper/view_warehouse_product_requests";

    // TASK
    public static final String TASK_PROCESS_ASSIGNMENT = "/task/processAssignment";
    public static final String TASK_DETAIL = "/task/detail";

}
