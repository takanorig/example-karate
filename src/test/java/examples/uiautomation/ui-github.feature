Feature: GitHubに対するUI操作
  https://intuit.github.io/karate/karate-core/

Background:
  * configure driver = { type: 'chrome' }
  # * configure driver = { type: 'chromedriver' }
  # * configure driver = { type: 'geckodriver' }
  # * configure driver = { type: 'safaridriver' }
  # * configure driver = { type: 'mswebdriver' }

Scenario: Search intuit/karate in GitHub

    * def keyword = 'karate'

    Given driver 'https://github.com/search'
        And driver.input('input[name=q]', keyword)
    When driver.submit('#search_form button.btn')
    Then eval driver.waitUntil(driver.location == 'https://github.com/search?utf8=%E2%9C%93&q=' + keyword + '&ref=simplesearch')

    * match driver.title == 'Search · karate · GitHub'
    * print driver.text('li.repo-list-item h3:first-child a')
    * match driver.text('li.repo-list-item h3:first-child a') == 'intuit/karate'

    * def bytes = driver.screenshot()
    * eval karate.embed(bytes, 'image/png')


Scenario: Get star-history of intuit/karate

    * def repo = 'intuit/karate'

    Given driver 'https://star-history.t9t.io/'
        And driver.input('input#repo', repo)
    When driver.click('button#theBtn')
    Then eval driver.waitUntil(driver.location == 'https://star-history.t9t.io/#' + repo)

    * match driver.value('input#repo') == repo

    * def bytes = driver.screenshot()
    * eval karate.embed(bytes, 'image/png')
