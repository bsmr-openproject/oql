require 'parslet'
include Parslet

class OQL
    class Parser < Parslet::Parser
        root :query
        rule(:query) { space? >> filterList.as(:filters) >> space? }
        rule(:filterList) { filter >> (andOp >> filter).repeat }
        rule(:filter) { condition.as(:condition) }

        rule(:condition) { field.as(:field) >>
                            space? >>
                            operator.as(:operator) >>
                            space? >>
                            (value | valueList).as(:values)
                         }

        rule(:valueList) { str('{') >> space? >>
                           value >> space? >>
                           (str(',') >> space? >> value >> space?).repeat >>
                           str('}')
                         }

        rule(:andOp)      { space? >> str('&&') >> space? }
        rule(:field)      { match('\w').repeat(1) }
        rule(:operator)   { str('==') | str('!=') | str('~') }
        rule(:value)      { str('"') >> match('\w').repeat.as(:valueString) >> str('"') }

        rule(:space)      { match('\s').repeat(1) }
        rule(:space?)     { space.maybe }
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

        # transform conditions with a single value
        rule(field: simple(:field),
             operator: simple(:op),
             values: subtree(:val)) do

            {
                field: field.to_s,
                operator: Transform.parse_operator(op),
                values: Transform.enforce_array(val)
            }
        end

        # enforce that even single filters are put into a sequence
        rule(filters: subtree(:one_or_more_filters)) do

            {
                filters: Transform.enforce_array(one_or_more_filters)
            }
        end

        def self.parse_operator(operator)
            OPERATORS[operator.to_s]
        end

        def self.enforce_array(value_or_array)
            if value_or_array.kind_of?(Array)
                value_or_array
            else
                [value_or_array]
            end
        end
    end

    def self.parse(query)
        parse_tree = Parser.new.parse(query)

        Transform.new.apply(parse_tree)
    end
end