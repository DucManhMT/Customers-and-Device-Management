package crm.core.repository.hibernate.querybuilder.DTO;
import java.util.ArrayList;
import java.util.List;
/**
 * Data Transfer Object to hold SQL string and its parameters.
 */

public class SqlAndParamsDTO {
    private final String sql;
    private final List<Object> params;

    public SqlAndParamsDTO(String sql, List<Object> params) {
        this.sql = sql;
        this.params = params;
    }
    public SqlAndParamsDTO(String sql, Object param) {
        this.sql = sql;
        List<Object> paramList = new ArrayList<>();
        paramList.add(param);
        this.params = paramList;
    }

    public String getSql() {
        return sql;
    }

    public List<Object> getParams() {
        return params;
    }
}