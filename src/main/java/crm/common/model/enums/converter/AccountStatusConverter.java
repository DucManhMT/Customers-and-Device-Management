package crm.common.model.enums.converter;

import crm.common.model.enums.AccountStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class AccountStatusConverter extends EnumConverter<AccountStatus> {
    public AccountStatusConverter() {
        super(AccountStatus.class);
    }

}
