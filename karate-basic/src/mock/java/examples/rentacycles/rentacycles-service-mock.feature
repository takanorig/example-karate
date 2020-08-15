Feature: レンタサイクルAPIのサービスモック
    このファイルは、呼び出されるAPIをモック化したものです。
    Karate の Standalone JAR を利用して、以下のコマンドで、単体のプロセスとして起動できます。
    
    java -jar karate.jar -p 8089 -m rentacycles-service-mock.feature


Background:
    * configure cors = true
    * def rentacycles =
    """
    [
      {id: 'A001', rent: false},
      {id: 'A002', rent: false},
      {id: 'A003', rent: false},
      {id: 'A004', rent: true},
      {id: 'A005', rent: true}
    ]
    """


# -----------------------------------------------
# 空き車両一覧取得
# GET:/rentacycles?available=true
# -----------------------------------------------
Scenario: methodIs('get') && pathMatches('/rentacycles') && paramValue('available') == 'true'
    * def availables = karate.jsonPath(rentacycles, "$[?(@.rent==false)]")
    * def response = availables


# -----------------------------------------------
# 車両一覧取得
# GET:/rentacycles
# -----------------------------------------------
Scenario: methodIs('get') && pathMatches('/rentacycles')
    * def response = rentacycles


# -----------------------------------------------
# レンタル処理
# POST:/rentacycles/rent
# -----------------------------------------------
Scenario: methodIs('post') && pathMatches('/rentacycles/rent')
     * def requestBody = request
     * def id = requestBody.id
     * def target = karate.jsonPath(rentacycles, "$[?(@.id=='" + id + "')]")[0]
     * print 'rental target : ', target
     * eval if (target == null) karate.abort()

     # 既にレンタル済みの場合は、409をリターンして終了
     * eval if (target.rent == true) karate.set('responseStatus', 409)
     * eval if (responseStatus == 409) karate.abort()

     # レンタル可能な場合は、状態を変更して200をリターン
     * set target.rent = true
     * def response = {result : true}


# -----------------------------------------------
# 返却処理
# POST:/rentacycles/return
# -----------------------------------------------
Scenario: methodIs('post') && pathMatches('/rentacycles/return')
     * def requestBody = request
     * def id = requestBody.id
     * def target = karate.jsonPath(rentacycles, "$[?(@.id=='" + id + "')]")[0]
     * print 'rental target : ', target
     * eval if (target == null) karate.abort()

     # 状態を変更して200をリターン
     * set target.rent = false
     * def response = {result : true}


# -----------------------------------------------
# API が一致しない場合
# -----------------------------------------------
Scenario:
    * def responseStatus = 404
