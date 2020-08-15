@ignore
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
        And waitUntil("document.title == 'Code Search · GitHub'")
        And input('input[name=q]', keyword)
    When submit().click('#search_form button.btn')
        And waitForUrl('/github.com/search?utf8=%E2%9C%93&q=' + keyword + '&ref=simplesearch')
    Then match driver.title == 'Search · karate · GitHub'

    * print text('li.repo-list-item div.f4:first-child a')
    * match text('li.repo-list-item div.f4:first-child a') == 'intuit/karate'

    * screenshot()


# -----------------------------------------------
# GitHubでのリポジトリ検索
#   ・ブラウザ内でのJavaScript実行あり
# -----------------------------------------------
Scenario: Search2 intuit/karate in GitHub

    * def keyword = 'karate'

    # ブラウザで動作させるJSは、Karate自体の JS Function とは定義方法が異なる。
    # 関数自体は、文字列として定義し、それを driver.eval で実行させる。
    # 以下は、JS Function を文字列として定義し、変数部分は replace を使って置換している。
    * text formSubmitWebFn =
        """
        var formElem = document.querySelector('${selector}');
        formElem.submit();
        """
    * replace formSubmitWebFn.${selector} = '#search_form'

    Given driver 'https://github.com/search'
        And waitUntil("document.title == 'Code Search · GitHub'")
        And input('input[name=q]', keyword)
    When script(formSubmitWebFn)
        And waitForUrl('/github.com/search?utf8=%E2%9C%93&q=' + keyword + '&ref=simplesearch')
    Then match driver.title == 'Search · karate · GitHub'

    * print text('li.repo-list-item div.f4:first-child a')
    * match text('li.repo-list-item div.f4:first-child a') == 'intuit/karate'

    * screenshot()


# -----------------------------------------------
# Get star-history
# -----------------------------------------------
Scenario: Get star-history of intuit/karate

    * def repo = 'intuit/karate'

    Given driver 'https://star-history.t9t.io/'
        And waitUntil("document.title == 'Star history'")
        And input('input#repo', repo)
    When click('button#theBtn')
        And waitForUrl('/star-history.t9t.io/#' + repo)
    Then match value('input#repo') == repo

    * screenshot()
