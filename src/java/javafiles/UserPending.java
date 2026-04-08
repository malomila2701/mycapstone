package javafiles;

public class UserPending {

    private int id;
    private int holidays_id;
    private String fullname;
    private String start_date;
    private String end_date;
    private String type;
    private String status;
    private String motif;

    public UserPending(int id, int holidays_id, String fullName, String startDate, String endDate, String type, String status, String motif) {
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

    public String getStartDate() {
        return start_date;
    }

    public String getEndDate() {
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
