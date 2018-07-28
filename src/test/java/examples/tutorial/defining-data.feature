Feature: データの指定方法に関するサンプル

# -----------------------------------------------
# 変数の指定
# -----------------------------------------------
Scenario: Normal def

* def text = 'karate example'
* print text
* match text == 'karate example'

* def jatext = '日本語のテキスト'
* print jatext
* match jatext == '日本語のテキスト'


# -----------------------------------------------
# JSON形式のデータの指定
# -----------------------------------------------
Scenario: JSON Format

# MultilineでのJSON指定
* def jsonData = 
"""
[
  {name: 'Bob', age: 2},
  {name: 'Wild', age: 4},
  {name: 'Nyan', age: 3}
]
"""
* match jsonData == [{name: 'Bob', age: 2}, {name: 'Wild', age: 4}, {name: 'Nyan', age: 3}]

# 値の変更
* set jsonData[0].age = 3
* match jsonData == [{name: 'Bob', age: 3}, {name: 'Wild', age: 4}, {name: 'Nyan', age: 3}]

# table指定
* table jsonAsTable
    | name   | age |
    | 'Bob'  | 2   |
    | 'Wild' | 4   |
    | 'Nyan' | 3   |

* match jsonAsTable == [{name: 'Bob', age: 2}, {name: 'Wild', age: 4}, {name: 'Nyan', age: 3}]

# set指定（JSON Pathを意識した指定）
* set jsonAsSetMultipleSyntax
    | path       | 0        | 1      | 2       |
    | name.first | 'John'   | 'Jane' | 'David' |
    | name.last  | 'Smith'  | 'Doe'  | 'Brown' |
    | age        | 20       | 24     |         |

* match jsonAsSetMultipleSyntax[0] == {name: { first: 'John', last: 'Smith' }, age: 20}
* match jsonAsSetMultipleSyntax[1] == {name: { first: 'Jane', last: 'Doe' }, age: 24}
* match jsonAsSetMultipleSyntax[2] == {name: { first: 'David', last: 'Brown' }}


# -----------------------------------------------
# パラメータの置換
# -----------------------------------------------
Scenario: Replace parameters

# デフォルトの置換変数 <val>
* def text1 = 'hello <foo> world'
* replace text1.foo = 'bar'
* match text1 == 'hello bar world'

# カスタムの置換変数 ${val}
* def text2 = 'hello ${foo} world'
* replace text2.${foo} = 'bar'
* match text2 == 'hello bar world'

# 複数のパラメータの置換
* def text3 = 'hello <val1> world <val2> bye'

* replace text3
    | token | value   |
    | val1  | 'cruel' |
    | val2  | 'good'  |

* match text3 == 'hello cruel world good bye'


# -----------------------------------------------
# ファイルからの読み込み
# -----------------------------------------------
Scenario: Reading files

* def sample01Json = read('sample01.json')
* print sample01Json

* match sample01Json == '#[7]'
* match sample01Json[0] == {color: 'red', value: '#f00'}
* match sample01Json[6] == {color: 'black', value: '#000'}
