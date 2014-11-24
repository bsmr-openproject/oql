require 'parslet'
include Parslet

class OQL
    class Parser < Parslet::Parser
        rule(:space)      { match('\s').repeat(1) }
        rule(:space?)     { space.maybe }
        
        rule(:field)      { match('\w').repeat(1) }
        rule(:operator)   { str('==') | str('!=') | str('~') }
        rule(:value)      { str('"') >> match('\w').repeat.as(:valueString) >> str('"') }
    
        rule(:condition) { field.as(:field) >>
                            space? >>
                            operator.as(:operator) >>
                            space? >>
                            value.as(:value)
                         }
        
        rule(:filter) { condition.as(:condition) }
        
        rule(:query) { filter.as(:filter) }
        
        root :query
    end
    
    class Transform < Parslet::Transform
        OPERATORS = {
            '==' => :is_equal,
            '!=' => :not_equal,
            '~' => :contains
        }
    
        # transform values to proper strings
        # TODO: remove escaped "
        rule(valueString: simple(:x)) { x.to_s }
        
        rule(field: simple(:field),
             operator: simple(:op),
             value: simple(:val)) do
             
            {
                field: field.to_s,
                operator: Transform.parse_operator(op),
                values: [ val ]
            }
        end
        
        def self.parse_operator(operator)
            OPERATORS[operator.to_s]
        end
    end

    def self.parse(query)
        parse_tree = Parser.new.parse(query)
        
        Transform.new.apply(parse_tree)
    end
end