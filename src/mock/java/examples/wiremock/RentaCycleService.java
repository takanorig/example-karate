package examples.wiremock;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * レンタルサービス
 */
public class RentaCycleService {
    private Map<String, RentaCycle> rentaCycleMap = new LinkedHashMap<>();

    public RentaCycleService() {
    }

    /**
     * 初期化を行う。
     */
    public void initialize() {
        this.rentaCycleMap.clear();

        this.rentaCycleMap.put("A001", new RentaCycle("A001"));
        this.rentaCycleMap.put("A002", new RentaCycle("A002"));
        this.rentaCycleMap.put("A003", new RentaCycle("A003"));
        {
            RentaCycle rentaCycle = new RentaCycle("A004");
            rentaCycle.rent();
            this.rentaCycleMap.put(rentaCycle.getId(), rentaCycle);
        }
        {
            RentaCycle rentaCycle = new RentaCycle("A005");
            rentaCycle.rent();
            this.rentaCycleMap.put(rentaCycle.getId(), rentaCycle);
        }
    }

    /**
     * 全車両を取得する。
     */
    public List<RentaCycle> getList() {
        List<RentaCycle> list = this.rentaCycleMap.values().stream().collect(Collectors.toList());
        return list;
    }

    /**
     * レンタル可能な車両の一覧を取得する。
     */
    public List<RentaCycle> getAvailableList() {
        List<RentaCycle> list = new ArrayList<>();
        for (RentaCycle cycle : this.rentaCycleMap.values()) {
            if (cycle.isRent() == false) {
                list.add(cycle);
            }
        }
        return list;
    }

    /**
     * 車両をレンタルする。
     */
    public boolean rent(String cycleId) {
        RentaCycle cycle = this.rentaCycleMap.get(cycleId);
        if (cycle == null || cycle.isRent()) {
            return false;
        }

        cycle.rent();
        return true;
    }

    /**
     * 車両を返却する。
     */
    public boolean rentReturn(String cycleId) {
        RentaCycle cycle = this.rentaCycleMap.get(cycleId);
        if (cycle == null || cycle.isRent() == false) {
            return false;
        }

        cycle.rentReturn();
        return true;
    }

}