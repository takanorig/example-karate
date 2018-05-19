package examples.wiremock;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.configureFor;
import static com.github.tomakehurst.wiremock.client.WireMock.get;
import static com.github.tomakehurst.wiremock.client.WireMock.okJson;
import static com.github.tomakehurst.wiremock.client.WireMock.post;
import static com.github.tomakehurst.wiremock.client.WireMock.stubFor;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.client.ResponseDefinitionBuilder;
import com.github.tomakehurst.wiremock.common.FileSource;
import com.github.tomakehurst.wiremock.common.Json;
import com.github.tomakehurst.wiremock.extension.Parameters;
import com.github.tomakehurst.wiremock.extension.ResponseDefinitionTransformer;
import com.github.tomakehurst.wiremock.http.Request;
import com.github.tomakehurst.wiremock.http.ResponseDefinition;

/**
 * REST API Mock by WireMock
 */
public class ApiMock {

    public static void setUpStub(RentalService service) {
        configureFor("localhost", 8089);

        // 一覧取得
        {
            List<RentaCycle> allList = service.getList();
            String json = Json.write(allList);
            stubFor(
                    // Path
                    get("/rentacycles")
                            // Response
                            .willReturn(okJson(json))
            // END
            );
        }

        // 空き車両一覧取得
        {
            List<RentaCycle> availableList = service.getAvailableList();
            String json = Json.write(availableList);
            stubFor(
                    // Path
                    get("/rentacycles?available=true")
                            // Response
                            .willReturn(okJson(json))
            // END
            );
        }

        // レンタル処理
        // カスタムのTransformを利用して、動的にレスポンスを生成する。
        {
            stubFor(
                    // Path
                    post("/rentacycles/rent")
                            // Response
                            .willReturn(aResponse().withTransformers("do-rent-transform"))
            // END
            );
        }
    }

    public static void main(String args[]) {
        RentalService service = new RentalService();
        service.initialize();

        WireMockServer wireMockServer = new WireMockServer(
                options().port(8089).extensions(new RentResponseTransformer(service)));
        wireMockServer.start();

        setUpStub(service);
    }

    private static class RentResponseTransformer extends ResponseDefinitionTransformer {

        private RentalService service;

        RentResponseTransformer(RentalService service) {
            this.service = service;
        }

        @Override
        public ResponseDefinition transform(Request request, ResponseDefinition responseDefinition, FileSource files,
                Parameters parameters) {

            String json = request.getBodyAsString();
            Map<String, ?> requestMap = Json.read(json, LinkedHashMap.class);
            String id = requestMap.get("id").toString();

            // レンタル処理
            boolean result = service.rent(id);
            int status = result ? 200 : 409;

            return new ResponseDefinitionBuilder()
                    // Status
                    .withStatus(status)
                    // Response
                    .withHeader("Content-Type", "application/json").withBody("{\"result\":" + result + "}")
                    // Build
                    .build();
        }

        @Override
        public String getName() {
            return "do-rent-transform";
        }
    }
}
