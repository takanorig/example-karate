package examples.uiautomation;

import com.intuit.karate.junit5.Karate;

public class UiAutomationRunner {
    @Karate.Test
    Karate test() {
        return Karate.run("users").relativeTo(getClass());
    }
}
