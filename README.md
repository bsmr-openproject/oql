OQL
===

Oh Cool! The OpenProject Query Language


Let's try it EBNF-like:

````EBNF
    queryExpr = optionalSpace, filterExpr, optionalSpace

    filterExpr = conditionExpr | filterExpr, andOperator, filterExpr | conditionExpr, atOperator, singleValue ;

    andOperator = optionalSpace, "&&", optionalSpace ;
    
    atOperator = requiredSpace, "at", requiredSpace ;
    
    conditionExpr = fieldExpr, binaryOperator, valueExpr | fieldExpr, binaryOperator, fieldExpr;

    fieldExpr = alpha, { alphaNum } ;
    
    alpha = characters A-Z and a-z
    
    alphaNum = alpha | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    
    binaryOperator =  optionalSpace, "==", optionalSpace
                    | optionalSpace, "!=", optionalSpace
                    | optionalSpace, "~", optionalSpace ;

    valueExpr = singleValue | multipleValues ;
    
    multipleValues = optionalSpace, "{", singleValue,  { "," singleValue }, "}", optionalSpace ;
    
    singleValue = optionalSpace, '"', {(all unicode characters - '"' - '\' | '\"' | '\\')}, '"', optionalSpace ;
    
    requiredSpace = whitespace, optionalSpace ;
    
    optionalSpace = {whitespace} ;
    
    whitespace = all unicode whitespace characters ;
````
