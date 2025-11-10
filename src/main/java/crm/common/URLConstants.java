package crm.common;

import crm.common.model.Feature;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.service.IDGeneratorService;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class URLConstants {

    // REGISTRATION
    public static final String HOME = "/";
    public static final String AUTH_LOGOUT = "/auth/logout";
    public static final String AUTH_STAFF_LOGIN = "/auth/staff_login";
    public static final String AUTH_CUSTOMER_LOGIN = "/auth/customer_login";
    public static final String AUTH_CUSTOMER_REGISTER = "/auth/customer_register";
    public static final String AUTH_FORGOT_PASSWORD = "/auth/forgot_password";

    // ADMIN
    public static final String ADMIN_VIEW_ROLE_LIST = "/admin/role_list";
    public static final String ADMIN_VIEW_ROLE_DETAIL = "/admin/role_list/view_role_detail";
    public static final String ADMIN_EDIT_ROLE = "/admin/role_list/edit_role";
    public static final String ADMIN_CREATE_ROLE = "/admin/role_list/create_role";
    public static final String ADMIN_VIEW_ACCOUNT_LIST = "/admin/account_list";
    public static final String ADMIN_ACTION_CENTER = "/admin/admin_actioncenter";
    public static final String ADMIN_EDIT_ACCOUNT = "/admin/account_list/edit_account";
    public static final String ADMIN_CREATE_ACCOUNT = "/admin/create_account";
    public static final String ADMIN_VIEW_ACCOUNT_DETAIL = "/admin/account_list/view_account_detail";
    public static final String ADMIN_ASSIGN_FEATURE = "/admin/assign_feature";
    //STAFF

    public static final String STAFF_REQUEST_TIMELINE = "/staff/requests/timeline";
    public static final String STAFF_EDIT_PROFILE = "/staff/profile/edit";
    public static final String STAFF_VIEW_PROFILE = "/staff/profile";
    // CUSTOMER
    public static final String CUSTOMER_ACTION_CENTER = "/customer/customer_actioncenter";
    public static final String CUSTOMER_VIEW_CONTRACT_HISTORY = "/customer/contract_history";
    public static final String CUSTOMER_VIEW_REQUEST = "/customer/requests";
    public static final String CUSTOMER_REQUEST_DETAIL = "/customer/requests/detail";
    public static final String CUSTOMER_CREATE_REQUEST = "/customer/requests/create";
    public static final String CUSTOMER_REQUEST_TIMELINE = "/customer/requests/timeline";
    // fix add customer path
    public static final String CUSTOMER_CREATE_FEEDBACK = "/feedback/create";
    public static final String CUSTOMER_VIEW_FEEDBACK = "/feedback/view";
    public static final String CUSTOMER_VIEW_FEEDBACK_LIST = "/feedback/list";
    public static final String CUSTOMER_VIEW_PROFILE = "/customer/profile";
    public static final String CUSTOMER_EDIT_PROFILE = "/customer/profile/edit";

    // CUSTOMER SUPPORTER
    public static final String CUSTOMER_SUPPORTER_ACTION_CENTER = "/customer_supporter/customersupporter_actioncenter";
    public static final String CUSTOMER_SUPPORTER_CREATE_CONTRACT = "/customer_supporter/create_contract";
    public static final String CUSTOMER_SUPPORTER_FEEDBACK_MANAGEMENT = "/customer_supporter/feedback/management";
    public static final String CUSTOMER_SUPPORTER_REQUEST_DASHBOARD = "/supporter/requests/dashboard";
    public static final String CUSTOMER_SUPPORTER_PROCESS_REQUEST = "/supporter/requests/process";
    public static final String CUSTOMER_SUPPORTER_REQUEST_DETAIL = "/supporter/requests/detail";
    public static final String CUSTOMER_SUPPORTER_REQUEST_LIST = "/supporter/requests/list";

    // TECHNICAL LEADER
    public static final String TECHLEAD_ACTION_CENTER = "/technician_leader/techlead_actioncenter";
    public static final String TECHLEAD_SELECT_TECHNICIAN = "/task/selectTechnician";
    public static final String TECHLEAD_VIEW_APROVED_TASK = "/task/viewAprovedTask";
    public static final String TECHLEAD_VIEW_TECHEM_LIST = "/tech/employees";
    public static final String TECHLEAD_VIEW_TECHEM_DETAIL = "/tech/employees/view";

    // TECHNICAL EMPLOYEE
    public static final String TECHEM_ACTION_CENTER = "/technician_employee/techemployee_actioncenter";
    public static final String TECHEM_UPDATE_TASK_STATUS = "/task/updateStatus";
    public static final String TECHEM_VIEW_ASSIGNED_TASK = "/task/viewAssignedTasks";
    public static final String CREATE_PRODUCT_REQUEST = "/tech/employees/create_product_requests";

    // WAREHOUSE KEEPER
    public static final String WAREHOUSE_ACTION_CENTER = "/warehouse_keeper/warehousekeeper_actioncenter";
    public static final String WAREHOUSE_VIEW_PRODUCT_WAREHOUSE = "/warehouse_keeper/view_product_warehouse";
    public static final String WAREHOUSE_VIEW_PRODUCT_DETAIL = "/warehouse_keeper/view_product_detail";
    public static final String WAREHOUSE_VIEW_INVENTORY = "/warehouse_keeper/view_inventory";
    public static final String WAREHOUSE_ADD_PRODUCT = "/warehouse_keeper/add_product";
    public static final String WAREHOUSE_CREATE_TRANSFER_REQUEST = "/warehouse_keeper/create_transfer_request";
    public static final String WAREHOUSE_VIEW_WAREHOUSE_DETAIL = "/warehouse_keeper/view_warehouse_detail";
    public static final String WAREHOUSE_VIEW_PRODUCT_REQUESTS = "/warehouse_keeper/view_warehouse_product_requests";
    public static final String WAREHOUSE_VIEW_PROFILE = "/warehouse_keeper/profile";
    public static final String WAREHOUSE_VIEW_WAREHOUSE_REQUEST = "/warehouse_keeper/view_warehouse_request";
    public static final String WAREHOUSE_EXPORT_INTERNAL = "/warehouse_keeper/export_internal";

    // INVENTORY MANAGER
    public static final String INVENTORY_ACTION_CENTER = "/inventory_manager/inventorymanager_actioncenter";
    public static final String INVENTORY_VIEW_TRANSFER_REQUESTS = "/inventory_manager/view_transfer_requests";

    // TASK
    public static final String TASK_PROCESS_ASSIGNMENT = "/task/processAssignment";
    public static final String TASK_ASSIGNMENT_DECISION = "/task/assignmentDecision";
    public static final String TASK_VIEW_RECEIVED_ASSIGNMENTS = "/task/viewReceivedAssignments";
    public static final String TASK_DETAIL = "/task/detail";


    //OTHERs
    public static final String UNAUTHORIZED = "/unauthorized";


    public static void addToDataBase(){
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try{
            em.beginTransaction();
            Field[] fields = URLConstants.class.getDeclaredFields();
            clearData();
            for (Field field : fields) {
                if (field.getType() == String.class) {
                    String url = (String) field.get(null);
                    Map<String, Object> params = Map.of("featureURL", url);
                    boolean exists = !em.findWithConditions(Feature.class ,params).isEmpty();

                    if (exists) {
                        continue;
                    }
                    Feature feature = new Feature();
                    feature.setFeatureID(IDGeneratorService.generateID(Feature.class));
                    feature.setFeatureURL((String) field.get(null));
                    feature.setDescription(field.getName());
                    em.persist(feature, Feature.class);
                }
            }
            em.commit();

        }catch (Exception e){
            e.printStackTrace();
        }       em.rollback();
    }

    private static void clearData() {
        EntityManager em = new EntityManager(DBcontext.getConnection());
        try {
            em.beginTransaction();
            List<Feature> features = em.findAll(Feature.class);
            List<String> urls = getAllUrls();
            for (Feature feature : features) {
                if (!urls.contains(feature.getFeatureURL())) {
                    em.remove(feature, Feature.class);
                }
            }
            em.commit();
        } catch (Exception e) {
            e.printStackTrace();
            em.rollback();
        }

    }

    public static List<String> getAllUrls(){
        try {
            Field[] fields = URLConstants.class.getDeclaredFields();
            List<String> urls = new ArrayList<>();
            for (Field field : fields) {
                if (field.getType() == String.class) {
                    String url = (String) field.get(null);
                    urls.add(url);
                }
            }
            return urls;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

}
