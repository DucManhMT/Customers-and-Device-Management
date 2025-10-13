package crm.common.model;

import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.OneToMany;
import java.util.List;

@Entity(tableName = "Province")
public class Province {
    @Key
    @Column(name = "ProvinceID")
    private int provinceID;

    @Column(name = "ProvinceName")
    private String provinceName;

    @OneToMany(mappedBy = "provinceID", joinColumn = "ProvinceID" ,targetEntity = Village.class)
    private List<Village> villages;

    public int getProvinceID() {
        return provinceID;
    }

    public void setProvinceID(int provinceID) {
        this.provinceID = provinceID;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public List<Village> getVillages() {
        return villages;
    }

    public void setVillages(List<Village> villages) {
        this.villages = villages;
    }
}
