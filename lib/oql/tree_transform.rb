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

class TreeTransform < Parslet::Transform
  # transform values to proper strings (de-escape characters)
  rule(valueString: simple(:x)) {
    x.to_s.gsub('\\\\', '\\').gsub('\"', '"')
  }

  # edge-case: empty strings are parsed as []
  rule(valueString: []) { '' }

  # transform conditions (slices -> to_s)
  rule(field: simple(:field),
       operator: simple(:op),
       values: subtree(:val)) do

    {
      field: field.to_s,
      operator: TreeTransform.parse_operator(op),
      values: TreeTransform.enforce_array(val)
    }
  end

  rule(filters: subtree(:one_or_more_filters)) do

    {
      filters: TreeTransform.enforce_array(one_or_more_filters)
    }
  end

  def self.parse_operator(operator)
    Operators::CONDITION_OPERATORS[operator.to_s]
  end

  # Parslet optimizes repetitions that contain a single element to NOT be Arrays.
  # This is inconvenient for a caller, as intermediate arrays MIGHT be missing.
  # Thus we ensure that everywhere where multiple elements are possible an array is guaranteed
  def self.enforce_array(value_or_array)
    if value_or_array.kind_of?(Array)
      value_or_array
    else
      [value_or_array]
    end
  end
end