package crm.common.model.enums.converter;

import crm.common.model.enums.TransactionStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class TransactionStatusConverter extends EnumConverter<TransactionStatus> {
    public TransactionStatusConverter() {
        super(TransactionStatus.class);
    }
}
