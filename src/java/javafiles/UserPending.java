package javafiles;

import java.sql.Date;

public class UserPending {

    private int id;
    private int holidays_id;
    private String fullname;
    private Date start_date;
    private Date end_date;
    private String type;
    private String status;
    private String motif;

    public UserPending(int id, int holidays_id, String fullName, Date startDate, Date endDate, String type, String status, String motif) {
        this.id = id;
        this.holidays_id = holidays_id;
        this.fullname = fullName;
        this.start_date = startDate;
        this.end_date = endDate;
        this.type = type;
        this.status = status;
        this.motif = motif;
    }

    public Integer getUserId() {
        return id;
    }

    public Integer getHolidayId() {
        return holidays_id;
    }

    public String getName() {
        return fullname;
    }

    public Date getStartDate() {
        return start_date;
    }

    public Date getEndDate() {
        return end_date;
    }

    public String getType() {
        return type;
    }

    public String getStatus() {
        return status;
    }

    public String getMotif() {
        return motif;
    }
}
