package crm.common.model;


import crm.core.repository.hibernate.annotation.Column;
import crm.core.repository.hibernate.annotation.Entity;
import crm.core.repository.hibernate.annotation.Key;
import crm.core.repository.hibernate.annotation.ManyToOne;
import crm.core.repository.hibernate.entitymanager.LazyReference;

@Entity(tableName = "Village")
public class Village {
    @Key
    @Column(name = "VillageID")
    private int villageID;

    @Column(name = "VillageName")
    private String villageName;

    @ManyToOne(joinColumn = "ProvinceID" )
    private LazyReference<Province> province;

    public int getVillageID() {
        return villageID;
    }

    public void setVillageID(int villageID) {
        this.villageID = villageID;
    }

    public String getVillageName() {
        return villageName;
    }

    public void setVillageName(String villageName) {
        this.villageName = villageName;
    }

    public LazyReference<Province> getProvince() {
        return province;
    }

    public void setProvince(LazyReference<Province> province) {
        this.province = province;
    }
}
