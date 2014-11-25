require 'oql/parsing_failed'
require 'parslet'
include Parslet

class OQL
    class Parser < Parslet::Parser
        root :query
        rule(:query) { space? >> filterList.as(:filters) >> space? }
        rule(:filterList) { filter >> (andOp >> filter).repeat }
        rule(:filter) { condition.as(:condition) }

        rule(:condition)  {
                            field.as(:field) >>
                            operator >>
                            (value | valueList).as(:values)
                          }

        rule(:valueList)  {
                            space? >> str('{') >>
                            value >>
                            (str(',') >> value).repeat >>
                            str('}') >> space?
                          }

        rule(:andOp)      { space? >> str('&&') >> space? }
        rule(:field)      { match('[A-Za-z]') >> match('[A-Za-z0-9]').repeat }
        rule(:operator)   {
                            space? >>
                            (str('==') |
                            str('!=') |
                            str('~')).as(:operator) >>
                            space?
                          }
        rule(:value)      {
                            space? >> str('"') >>
                                # either match a valid escape sequence
                                (str('\\') >> (str('"') | str('\\')) |
                                # or match any character, but " and \
                                str('"').absent? >> str('\\').absent? >> any).repeat.as(:valueString) >>
                            str('"') >> space?
                          }

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
        rule(valueString: simple(:x)) {
            x.to_s.sub('\\\\', '\\').sub('\"', '"')
        }
        
        # edge-case: empty strings are parsed as []
        rule(valueString: []) { '' }

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
        begin
            parse_tree = Parser.new.parse(query)
        rescue Parslet::ParseFailed => e
            raise ParsingFailed, e.message
        end

        Transform.new.apply(parse_tree)
    end
end