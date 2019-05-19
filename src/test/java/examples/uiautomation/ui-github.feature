Feature: GitHubに対するUI操作
  https://intuit.github.io/karate/karate-core/

Background:
  * configure driver = { type: 'chrome' }
  # * configure driver = { type: 'chromedriver' }
  # * configure driver = { type: 'geckodriver' }
  # * configure driver = { type: 'safaridriver' }
  # * configure driver = { type: 'mswebdriver' }

# -----------------------------------------------
# GitHubでのリポジトリ検索
# -----------------------------------------------
Scenario: Search intuit/karate in GitHub

    * def keyword = 'karate'

    Given driver 'https://github.com/search'
        And eval driver.waitUntil(driver.title == 'Code Search · GitHub')
        And driver.input('input[name=q]', keyword)
    When driver.submit('#search_form button.btn')
    Then eval driver.waitUntil(driver.location == 'https://github.com/search?utf8=%E2%9C%93&q=' + keyword + '&ref=simplesearch')
        And eval driver.title == 'Search · karate · GitHub'

    * print driver.text('li.repo-list-item h3:first-child a')
    * match driver.text('li.repo-list-item h3:first-child a') == 'intuit/karate'

    * def bytes = driver.screenshot()
    * eval karate.embed(bytes, 'image/png')


# -----------------------------------------------
# GitHubでのリポジトリ検索
#   ・ブラウザ内でのJavaScript実行あり
# -----------------------------------------------
Scenario: Search2 intuit/karate in GitHub

    * def keyword = 'karate'

    # ブラウザで動作させるJSは、Karate自体の JS Function とは定義方法が異なる。
    # 関数自体は、文字列として定義し、それを driver.eval で実行させる。
    # 以下は、function(selector) 自体は、Karate内部で動作さうる部分であるが、
    # return 後の部分は、ブラウザ内で動作する内容となる。
    * def formSubmitWebFn =
        """
        function(selector) {
            return "var formElem = document.querySelector('" + selector + "');"
                 + "formElem.submit();"
        }
        """

    Given driver 'https://github.com/search'
        And eval driver.waitUntil(driver.title == 'Code Search · GitHub')
        And driver.input('input[name=q]', keyword)
    When eval driver.eval(formSubmitWebFn('#search_form'))
    Then eval driver.waitUntil(driver.location == 'https://github.com/search?utf8=%E2%9C%93&q=' + keyword + '&ref=simplesearch')
        And match driver.title == 'Search · karate · GitHub'

    * print driver.text('li.repo-list-item h3:first-child a')
    * match driver.text('li.repo-list-item h3:first-child a') == 'intuit/karate'

    * def bytes = driver.screenshot()
    * eval karate.embed(bytes, 'image/png')


# -----------------------------------------------
# Get star-history
# -----------------------------------------------
Scenario: Get star-history of intuit/karate

    * def repo = 'intuit/karate'

    Given driver 'https://star-history.t9t.io/'
        And eval driver.waitUntil(driver.title == 'Star history')
        And driver.input('input#repo', repo)
    When driver.click('button#theBtn')
    Then eval driver.waitUntil(driver.location == 'https://star-history.t9t.io/#' + repo)

    * match driver.value('input#repo') == repo

    * def bytes = driver.screenshot()
    * eval karate.embed(bytes, 'image/png')
