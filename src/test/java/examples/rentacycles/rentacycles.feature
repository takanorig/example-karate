@ignore
Feature: レンタサイクルAPIのテスト
    このテストを実行する際は、事前に、WireMockを利用したモックサーバーを立ち上げておく必要があります。
    以下のいずれかの方法で、モックサーバーを立ち上げることができます。
        方法1) WireMock版
          ・以下のクラスを実行することで、モックサーバーが立ち上がります。
            src/mock/java/examples/wiremock/ApiMock.java
        方法2) Karate Test Double版
          ・以下の feature ファイルを実行することで、モックサーバーが立ち上がります。
            src/mock/java/examples/rentacycles/rentacycles-service-mock.feature
          ・以下のコマンドで、Karateをモックサーバーとして立ち上げることができます。
            java -jar karate.jar -p 8089 -m rentacycles-service-mock.feature

Background:
* url 'http://localhost:8089'

Scenario: Get all rentacycles

    Given path '/rentacycles'
    When method get
    Then status 200
        And assert response.size() === 5

Scenario: Rent / Return the cycle

    # 空き車両一覧取得
    Given path '/rentacycles'
        And param available = true
    When method get
    Then status 200
        And assert response.size() === 3
        And match response contains {id: 'A001', rent: false}
        And match response contains {id: 'A002', rent: false}
        And match response contains {id: 'A003', rent: false}

    # レンタル処理
    * def rentId = response[0].id
    * print rentId
    Given path '/rentacycles/rent'
        And request {id: #(rentId)}
    When method post
    Then status 200
        And match response == 
        """
        {
            result : true
        }
        """

    # 空き車両一覧取得
    Given path '/rentacycles'
        And param available = true
    When method get
    Then status 200
        And assert response.size() === 2

    # レンタル処理（不可）
    Given path '/rentacycles/rent'
        And request {id: #(rentId)}
    When method post
    Then status 409

    # 返却処理
    Given path '/rentacycles/return'
        And request {id: #(rentId)}
    When method post
    Then status 200
        And match response == 
        """
        {
            result : true
        }
        """

    # 空き車両一覧取得
    Given path '/rentacycles'
        And param available = true
    When method get
    Then status 200
        And assert response.size() === 3
