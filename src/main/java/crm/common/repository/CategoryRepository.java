package crm.common.repository;

import crm.common.model.Category;
import crm.core.repository.persistence.repository.AbstractRepository;

public class CategoryRepository extends AbstractRepository<Category, Integer> {
    public CategoryRepository() {
        super(Category.class);
    }
}
