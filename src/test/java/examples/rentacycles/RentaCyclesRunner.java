package examples.rentacycles;

import com.intuit.karate.KarateOptions;
import com.intuit.karate.junit4.Karate;
import org.junit.runner.RunWith;

@KarateOptions(features = "classpath:examples/rentacycles", tags = "~@ignore") 
@RunWith(Karate.class)
public class RentaCyclesRunner {

}
