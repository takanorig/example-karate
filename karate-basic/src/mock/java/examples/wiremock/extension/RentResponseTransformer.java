package examples.wiremock.extension;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.github.tomakehurst.wiremock.client.ResponseDefinitionBuilder;
import com.github.tomakehurst.wiremock.common.FileSource;
import com.github.tomakehurst.wiremock.common.Json;
import com.github.tomakehurst.wiremock.extension.Parameters;
import com.github.tomakehurst.wiremock.extension.ResponseDefinitionTransformer;
import com.github.tomakehurst.wiremock.http.Request;
import com.github.tomakehurst.wiremock.http.ResponseDefinition;

import examples.wiremock.RentaCycle;
import examples.wiremock.RentaCycleService;

public class RentResponseTransformer extends ResponseDefinitionTransformer {

    private RentaCycleService service;

    public RentResponseTransformer(RentaCycleService service) {
        this.service = service;
    }

    /**
     * {@inheritDoc}}
     */
    @Override
    public ResponseDefinition transform(Request request, ResponseDefinition responseDefinition, FileSource files,
            Parameters parameters) {

        String path = request.getUrl();

        ResponseDefinitionBuilder newResponseDefBuilder = ResponseDefinitionBuilder.like(responseDefinition);
        ResponseDefinition newResponseDefinition;
        switch (path) {
        case "/rentacycles":
            newResponseDefinition = getList(request, newResponseDefBuilder);
            break;
        case "/rentacycles?available=true":
            newResponseDefinition = getListIsAvailable(request, newResponseDefBuilder);
            break;
        case "/rentacycles/rent":
            newResponseDefinition = doRent(request, newResponseDefBuilder);
            break;
        case "/rentacycles/return":
            newResponseDefinition = doReturn(request, newResponseDefBuilder);
            break;
        default:
            newResponseDefinition = newResponseDefBuilder.withStatus(404).withBody("").build();
            break;
        }

        return newResponseDefinition;
    }

    /**
     * 一覧取得
     */
    private ResponseDefinition getList(Request request, ResponseDefinitionBuilder newResponseDefBuilder) {
        List<RentaCycle> list = service.getList();
        String json = Json.write(list);

        return newResponseDefBuilder
                // Status
                .withStatus(200)
                // Response Header
                .withHeader("Content-Type", "application/json")
                // Response Body
                .withBody(json)
                // Build
                .build();
    }

    /**
     * 空き車両一覧取得
     */
    private ResponseDefinition getListIsAvailable(Request request, ResponseDefinitionBuilder newResponseDefBuilder) {
        List<RentaCycle> availableList = service.getAvailableList();
        String json = Json.write(availableList);

        return newResponseDefBuilder
                // Status
                .withStatus(200)
                // Response Header
                .withHeader("Content-Type", "application/json")
                // Response Body
                .withBody(json)
                // Build
                .build();
    }

    /**
     * レンタル処理
     */
    @SuppressWarnings("unchecked")
    private ResponseDefinition doRent(Request request, ResponseDefinitionBuilder newResponseDefBuilder) {
        String json = request.getBodyAsString();
        Map<String, ?> requestMap = Json.read(json, LinkedHashMap.class);
        String id = requestMap.get("id").toString();

        // レンタル処理
        boolean result = service.rent(id);
        int status = result ? 200 : 409;

        return newResponseDefBuilder
                // Status
                .withStatus(status)
                // Response Header
                .withHeader("Content-Type", "application/json")
                // Response Body
                .withBody("{\"result\":" + result + "}")
                // Build
                .build();
    }

    /**
     * 返却処理
     */
    @SuppressWarnings("unchecked")
     private ResponseDefinition doReturn(Request request, ResponseDefinitionBuilder newResponseDefBuilder) {
        String json = request.getBodyAsString();
        Map<String, ?> requestMap = Json.read(json, LinkedHashMap.class);
        String id = requestMap.get("id").toString();

        // レンタル処理
        boolean result = service.rentReturn(id);
        int status = result ? 200 : 409;

        return newResponseDefBuilder
                // Status
                .withStatus(status)
                // Response Header
                .withHeader("Content-Type", "application/json")
                // Response Body
                .withBody("{\"result\":" + result + "}")
                // Build
                .build();
    }

    /**
     * {@inheritDoc}}
     */
    @Override
    public String getName() {
        return "rent-response";
    }

    /**
     * {@inheritDoc}}
     */
    @Override
    public boolean applyGlobally() {
        return false;
    }
}
