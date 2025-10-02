package crm.common.model.enums.converter;

import crm.common.model.enums.ProductRequestStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class ProductRequestStatusConverter extends EnumConverter<ProductRequestStatus> {
    public ProductRequestStatusConverter() {
        super(ProductRequestStatus.class);
    }
}
