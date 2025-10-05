package crm.core.repository.hibernate.querybuilder.DTO;

import java.util.ArrayList;
import java.util.List;

public class ColumnsAndValuesDTO {
    private final List<String> columns;
    private final List<Object> values;

    public ColumnsAndValuesDTO(List<String> columns, List<Object> values) {
        this.columns = columns;
        this.values = values;
    }
    public ColumnsAndValuesDTO(List<String> columns, Object value) {
        this.columns = columns;
        List<Object> valueList = new ArrayList<>();
        valueList.add(value);
        this.values = valueList;
    }
    public List<String> getColumns() {
        return columns;
    }
    public List<Object> getValues() {
        return values;
    }


}
