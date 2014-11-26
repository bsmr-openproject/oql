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

require 'parslet'

class Parser < Parslet::Parser
  root :query
  rule(:query)      { space? >> filterList.as(:filters) >> space? }
  rule(:filterList) { filter >> (andOp >> filter).repeat }
  rule(:filter)     { condition.as(:condition) }

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