
Feature: Assertの仕方に関するサンプル

# -----------------------------------------------
# 基本的な変数の一致判定
# -----------------------------------------------
Scenario: Basic Matching

* def data1 = {name: 'Bob', age: 2}
* def data2 = {age: 2, name: 'Bob'}
* match data1 == data2

* def data3 = {name: 'Bob', age: 2}
* match data3 != {name: 'Bob', age: 3}


# -----------------------------------------------
# Fuzzy Matching 1
# -----------------------------------------------
Scenario: Fuzzy Matching 1

# ignore
* def test = {id: '001', name: { first: 'John', last: 'Smith' }, age: 20}
* match test == {id: '001', name: { first: '#ignore', last: 'Smith' }, age: 20}

# null / notnull
* def test = {id: '001', name: null}
* match test == {id: '#notnull', name: '#null'}

# present / notpresent
* def test = {id: '001', name: 'Bob'}
* match test == {id: '001', name: '#present', age: '#notpresent'}

# compare #null/#notnull, ##null/##null, #present/#notpresent
* def foo = { }
* match foo != {a: '#null'}
* match foo == {a: '##null'}
* match foo != {a: '#notnull'}
* match foo == {a: '##notnull'}
* match foo == {a: '#notpresent'}

* def foo = {a: null}
* match foo == {a: '#null'}
* match foo == {a: '##null'}
* match foo == {a: '#present'}

* def foo = {a: 1}
* match foo == {a: '#notnull'}
* match foo == {a: '##notnull'}
* match foo == {a: '#present'}


# -----------------------------------------------
# Fuzzy Matching 2
# -----------------------------------------------
Scenario: Fuzzy Matching 2

# number
* def test = {foo: 1}
* match test == {foo: '#number'}

# string
* def test = {foo: 'test'}
* match test == {foo: '#string'}

# boolean
* def test = {foo: true}
* match test == {foo: '#boolean'}

# array
* def test = {foo: [1, 2]}
* match test == {foo: '#array'}

# object
* def test = {foo: {bar: 'baz'}}
* match test == {foo: '#object'}

# regex
* def test = {foo: 'test123'}
* match test == {foo: '#regex [a-z0-9]{7}'}

# uuid
* def test = {id: 'a9f7a56b-8d5c-455c-9d13-808461d17b91'}
* match test == {id: '#uuid'}


# -----------------------------------------------
# Validation Expressions
# -----------------------------------------------
Scenario: Validation Expressions

* def month = {value: 3}

* match month == {value: '#? _ > 0 && _ < 13'}

* def min = 1
* def max = 12
* match month == {value: '#? _ >= min && _ <= max'}

* def isValid = function(v) { return v >= 1 && v <= 12 }
* match month == {value: '#? isValid(_)'}


# -----
# >
# -----


# -----------------------------------------------
# Containsを利用した一致判定
# -----------------------------------------------
Scenario: Contains Matching

* def test = {id: '001', first_name: 'John', last_name: 'Smith', age: 20}

# contains / not contains
* match test contains {id:'001'}
* match test contains {first_name: 'John', last_name: 'Smith'}
* match test !contains {foo: '001'}
* match test contains only {id: '001', first_name: 'John', last_name: 'Smith', age: 20}
* match test contains only {age: 20, first_name: 'John', last_name: 'Smith', id: '001'}

# array
* def testArray = [1, 2, 3]

* match testArray contains 1
* match testArray contains [1, 2]
* match testArray !contains 4
* match testArray !contains [4, 5]
* match testArray contains only [1, 2, 3]

# marker
* def test = {id: '001', name: { first: 'John', last: 'Smith' }, age: 20}
* match test contains {id: '#string', name: '#notnull', age: '#number'}


# -----------------------------------------------
# JSON Path
# -----------------------------------------------
Scenario: JSON Path

* def jsonData = 
"""
{
  name: 'Billie',
  kittens: [
    { id: 23, name: 'Bob' },
    { id: 42, name: 'Wild' }
  ]
}
"""

* match jsonData.kittens[*].id == [23, 42]

# 'contains' for JSON arrays
* match jsonData.kittens[*].id contains 23
* match jsonData.kittens[*].id contains [23, 42]

# nested objects within JSON arrays
* match jsonData.kittens contains [{ id: 42, name: 'Wild' }, { id: 23, name: 'Bob' }]


# -----------------------------------------------
# Validate every element
# -----------------------------------------------
Scenario: Validate every element

* def arrayData = {foo: [{bar: 1, baz: 'a'}, {bar: 2, baz: 'b'}, {bar: 3, baz: 'c'}]}

# validate each element
* match each arrayData.foo == {bar: '#number', baz: '#string'}

# 'contains' with 'each'
* match each arrayData.foo contains {bar: '#number'}
* match each arrayData.foo contains {bar: '#? _ > 0'}


# -----------------------------------------------
# Schema Validation
# -----------------------------------------------
Scenario: Schema Validation

* def foo = ['bar', 'baz']

# should be an array
* match foo == '#[]'

# should be an array of size 2
* match foo == '#[2]'

# should be an array of strings with size 2
* match foo == '#[2] #string'

# should be null or an array of strings
* match foo == '##[] #string'

# each array element should have a 'length' property with value 3
* match foo == '#[]? _.length == 3'

# should be an array of strings each of length 3
* match foo == '#[] #string? _.length == 3'

