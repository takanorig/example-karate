package examples.wiremock;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.configureFor;
import static com.github.tomakehurst.wiremock.client.WireMock.get;
import static com.github.tomakehurst.wiremock.client.WireMock.post;
import static com.github.tomakehurst.wiremock.client.WireMock.stubFor;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.wireMockConfig;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.core.WireMockConfiguration;

import examples.wiremock.extension.RentResponseTransformer;

/**
 * REST API Mock by WireMock
 */
public class ApiMock {

    public static void setUpStub(RentaCycleService service) {
        configureFor("localhost", 8089);

        // 一覧取得
        {
            stubFor(
                    // Response
                    get("/rentacycles").willReturn(aResponse().withTransformers("rent-response"))
            // END
            );
        }

        // 空き車両一覧取得
        {
            stubFor(
                    // Response
                    get("/rentacycles?available=true").willReturn(aResponse().withTransformers("rent-response"))
            // END
            );
        }

        // レンタル処理
        {
            stubFor(
                    // Response
                    post("/rentacycles/rent").willReturn(aResponse().withTransformers("rent-response"))
            // END
            );
        }

        // 返却処理
        {
            stubFor(
                    // Response
                    post("/rentacycles/return").willReturn(aResponse().withTransformers("rent-response"))
            // END
            );
        }
    }

    public static void main(String args[]) {
        RentaCycleService service = new RentaCycleService();
        service.initialize();

        WireMockConfiguration config = wireMockConfig().port(8089);
        config.extensions(new RentResponseTransformer(service));

        WireMockServer wireMockServer = new WireMockServer(config);
        wireMockServer.start();

        setUpStub(service);
    }

}
