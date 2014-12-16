OpenProject Query Language
==========================

[![Build Status](https://travis-ci.org/opf/oql.svg)](https://travis-ci.org/opf/oql) [![Documentation Evaluation](http://inch-ci.org/github/opf/oql.svg?branch=dev)](http://inch-ci.org/github/opf/oql/)

The OQL (pronounced *Oh cool!*) is intended to specify filter queries on OpenProject data.
It is for now part of the *APIv3*, but might propagate further through OpenProject (URLs etc.).

State of implementation: **DRAFT**

Note that OQL is currently *work in progress* and on its way of being integrated into OpenProject.
Once integrated it will (hopefully) be subject to growth and extension.

Installation
============

Add this line to your application's Gemfile:

```ruby
gem 'oql', :git => 'https://github.com/opf/oql.git', :branch => 'dev'
```

And then execute:

    $ bundle

Examples
========

**Find all tickets with a specific status**

````
# long format
status == "/api/v3/statuses/2"

# short format
status == "2"
````

**Find tickets that are either of one status or another**

````
status == { "/api/v3/statuses/1", "/api/v3/statuses/2" }
````

**Find Bugs about the API**

````
# Assuming 3 is the ID of your Bug-Type
subject ~ "API" && type == "/api/v3/types/3"
````

Query Structure
===============

The general structure of a OQL query can be described as

````
field operator value
````

Where **field** is the name of any property of your ressource, you can consult the [API v3 Specification](https://github.com/opf/openproject/blob/dev/doc/apiv3-documentation.apib)
for the properties available on each ressource.

The **value** can either be a single value (enclosed in quotation marks) or multiple values, like `{ "value A", "value B" }`.
In the case of multiple values you can read the filter as **OR** statement, e.g. "If status either equals value A *or* value B" and
"If the subject either contains foo *or* if it contains bar".

Note that in case of an empty list of values (e.g. `status == { }`, there is nothing to compare against and therefore
such a condition will always evaluate to false.

In the case of referenced properties - like the status - you can either specify the Link-URL as provided by the **APIv3** as a value
or the **ID** of the referenced ressource.

Operators
=========

As of now the following operators are supported by OQL:

* `==` - **is equal**, true if the specified field is the same as the specified value
    * *Note: if the specified value is a string, it is matched case insensitive*
* `!=` - **not equal**, true if the specified field is **not** the same as the specified value
    * *Note: if the specified value is a string, it is matched case insensitive*
* `~` - **contains**, true if the specified field is a string that contains the specified value (case insensitive matching)

Syntax Definition
=================

The OQL Syntax for the currently available features is defined in EBNF.

Note that for readability purposes the following POSIX character classes are used inside the EBNF:

* `[:print:]` - all printable characters, including whitespace
* `[:space:]` - whitespace (horizontal and vertical)

````EBNF
queryExpr = optionalSpace, filterExpr, optionalSpace

filterExpr = conditionExpr | filterExpr, andOperator, filterExpr ;

andOperator = optionalSpace, "&&", optionalSpace ;

conditionExpr = fieldExpr, binaryOperator, valueExpr | fieldExpr, binaryOperator, fieldExpr;

fieldExpr = alpha, { alphaNum } ;

alpha = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" |
        "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" |
        "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" |
        "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z" ;

digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;

alphaNum = alpha | digit ;

binaryOperator =  optionalSpace, "==", optionalSpace
                | optionalSpace, "!=", optionalSpace
                | optionalSpace, "~", optionalSpace ;

valueExpr = singleValue | multipleValues ;

multipleValues = optionalSpace, "{", (singleValue, { "," singleValue } | optionalSpace), "}", optionalSpace ;

singleValue = optionalSpace, '"', {([:print:] - '"' - '\' | '\"' | '\\')}, '"', optionalSpace ;

optionalSpace = {whitespace} ;

whitespace = [:space:] ;
````

Syntactic concepts for eventually planned features (*volatile* and *uncertain*):

````EBNF
filterExpr = conditionExpr | filterExpr, andOperator, filterExpr | conditionExpr, atOperator, singleValue ;

atOperator = requiredSpace, "at", requiredSpace ;

requiredSpace = whitespace, optionalSpace ;
````
