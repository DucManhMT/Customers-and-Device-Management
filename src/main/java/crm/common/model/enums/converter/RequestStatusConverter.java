package crm.common.model.enums.converter;

import crm.common.model.enums.RequestStatus;
import crm.core.repository.persistence.entity.convert.EnumConverter;

public class RequestStatusConverter extends EnumConverter<RequestStatus> {
    public RequestStatusConverter() {
        super(RequestStatus.class);
    }
}
