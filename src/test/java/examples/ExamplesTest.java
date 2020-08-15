package examples;

import com.intuit.karate.junit5.Karate;

class ExamplesTest {

    // @Karate.Test
    // Karate testAll() {
    // return Karate.run().relativeTo(getClass());
    // }

    @Karate.Test
    Karate testExcludesIgnore() {
        return Karate.run().tags("~@ignore").relativeTo(getClass());
    }
}
