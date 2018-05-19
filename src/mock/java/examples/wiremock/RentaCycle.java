package examples.wiremock;

/**
 * レンタサイクル
 */
public class RentaCycle {

    /** レンタサイクルID */
    private String id;

    /** 利用状況 */
    private boolean rent;

    public RentaCycle(String id) {
        this.id = id;
    }

    protected void rent() {
        this.rent = true;
    }

    protected void rentReturn() {
        this.rent = false;
    }

    public String getId() {
        return this.id;
    }

    public boolean isRent() {
        return this.rent;
    }
}
