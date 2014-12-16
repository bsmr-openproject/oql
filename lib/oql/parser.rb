# encoding: UTF-8

# OpenProject Query Language (OQL) is intended to specify filter queries on OpenProject data.
# Copyright (C) 2014  OpenProject Foundation
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'oql/operators'
require 'parslet'

class Parser < Parslet::Parser
  # rubocop:disable Style/MultilineOperationIndentation
  # rubocop:disable Lint/BlockAlignment

  root :query
  rule(:query)      { spaced(filterList.as(:filters)) }
  rule(:filterList) { filter >> (andOp >> filter).repeat }
  rule(:filter)     { condition.as(:condition) }

  rule(:condition)  {
                      field.as(:field) >>
                      operator >>
                      (value | valueList).as(:values)
                    }

  rule(:valueList)  {
                      spaced(
                        str('{') >> space? >>
                        (value >> (str(',') >> value).repeat).maybe >>
                        str('}')
                      ).as(:valueList)
                    }

  rule(:andOp)      { spaced(str('&&')) }
  rule(:field)      { match('[A-Za-z]') >> match('[A-Za-z0-9]').repeat }
  rule(:operator)   {
                      spaced(
                        operators.as(:operator)
                      )
                    }

  rule(:value)      {
                      spaced(
                        str('"') >>
                          # either match a valid escape sequence
                          (str('\\') >> (str('"') | str('\\')) |
                          # or match any character, but " and \
                          str('"').absent? >> str('\\').absent? >> any).repeat.as(:valueString) >>
                        str('"')
                      )
                    }

  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  # rubocop:enable Lint/BlockAlignment
  # rubocop:enable Style/MultilineOperationIndentation

  def spaced(expression)
    space? >> expression >> space?
  end

  def operators
    Operators::CONDITION_OPERATORS.map { |op, _| str(op) }.reduce(:|)
  end
end
