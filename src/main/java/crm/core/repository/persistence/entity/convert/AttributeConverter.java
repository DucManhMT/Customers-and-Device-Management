package crm.core.repository.persistence.entity.convert;

public interface AttributeConverter<C, F> {
    C convertToDatabaseColumn(F attribute);

    F convertToEntityAttribute(C dbData);
}
