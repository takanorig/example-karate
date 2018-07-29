Feature: Assertの仕方に関するサンプル

# -----------------------------------------------
# 基本的な変数の確認方法
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
* match foo != { a: '#null' }
* match foo == { a: '##null' }
* match foo != { a: '#notnull' }
* match foo == { a: '##notnull' }
* match foo == { a: '#notpresent' }

* def foo = { a: null }
* match foo == { a: '#null' }
* match foo == { a: '##null' }
* match foo == { a: '#present' }

* def foo = { a: 1 }
* match foo == { a: '#notnull' }
* match foo == { a: '##notnull' }
* match foo == { a: '#present' }


# -----------------------------------------------
# Fuzzy Matching 2
# -----------------------------------------------
Scenario: Fuzzy Matching 2

# number
* def test = { foo: 1 }
* match test == { foo: '#number' }

# string
* def test = { foo: 'test' }
* match test == { foo: '#string' }

# boolean
* def test = { foo: true }
* match test == { foo: '#boolean' }

# array
* def test = { foo: [1, 2] }
* match test == { foo: '#array' }

# object
* def test = { foo: { bar: 'baz' } }
* match test == { foo: '#object' }

# regex
* def test = { foo: 'test123' }
* match test == { foo: '#regex [a-z0-9]{7}' }

# uuid
* def test = { id: 'a9f7a56b-8d5c-455c-9d13-808461d17b91' }
* match test == { id: '#uuid' }


# -----------------------------------------------
# Validation Expressions
# -----------------------------------------------
* def val = { value: 3 }

* match val == { value: '#? _ > 0 && _ < 13' }

* def min = 1
* def max = 12
* match val == { value: '#? _ >= min && _ <= max' }

* def isValid = function(v) { return v >= 0 && v <= 12 }
* match val == { value: '#? isValid(_)' }

