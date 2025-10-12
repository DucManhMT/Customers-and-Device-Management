package testbuilder;

import crm.auth.service.Hasher;
import crm.auth.service.LoginService;
import crm.common.model.*;
import crm.common.model.enums.AccountStatus;
import crm.common.model.enums.RequestStatus;
import crm.common.repository.account.AccountDAO;
import crm.core.repository.hibernate.entitymanager.EntityManager;
import crm.core.repository.hibernate.entitymanager.LazyReference;
import crm.core.repository.hibernate.querybuilder.*;
import crm.core.config.DBcontext;
import crm.core.repository.hibernate.querybuilder.DTO.SqlAndParamsDTO;
import crm.core.repository.hibernate.querybuilder.enums.SortDirection;
import crm.core.service.IDGeneratorService;
import crm.core.service.MailService;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuilderTest {
    public static void main(String[] args) {
      EntityManager em  = new EntityManager(DBcontext.getConnection());

        Category category = new Category();
//        category.setCategoryName("New Category");
//        category.setCategoryID(IDGeneratorService.generateID(Category.class));
//        em.persist(category, Category.class);
        category = em.find(Category.class, 1);

        Type type = new Type();
//        type.setTypeName("New Type");
//        type.setCategory(category);
//        type.setTypeID(IDGeneratorService.generateID(Type.class));
//        em.persist(type, Type.class);
        type = em.find(Type.class, 1);


        for (int i = 2; i < 100; i++) {
            Product product = new Product();
            product.setProductName("New Product " + i);
            product.setProductDescription("This is a new product " + i);
            product.setType(type);
            product.setProductID(IDGeneratorService.generateID(Product.class));
            em.persist(product, Product.class);
        }

    }

 }
