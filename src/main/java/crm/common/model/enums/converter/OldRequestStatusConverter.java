package crm.common.model.enums.converter;

import crm.common.model.enums.OldRequestStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class OldRequestStatusConverter extends EnumConverter<OldRequestStatus> {
    public OldRequestStatusConverter() {
        super(OldRequestStatus.class);
    }
}
