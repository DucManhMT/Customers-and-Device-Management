package crm.common.model.enums.converter;

import crm.common.model.enums.ProductStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class ProductStatusConverter extends EnumConverter<ProductStatus> {
    public ProductStatusConverter() {
        super(ProductStatus.class);
    }
}
