package examples.tutorial;

import com.intuit.karate.junit5.Karate;

public class TutorialRunner {
    @Karate.Test
    Karate test() {
        return Karate.run("tutorial").relativeTo(getClass());
    }    
}
