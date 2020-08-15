package examples.rentacycles;

import com.intuit.karate.junit5.Karate;

public class RentaCyclesRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
