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

# This transform will take a tree containing :valueList nodes and
# for each of those nodes either emit an empty array (for empty lists)
# or the child nodes of the :valueNode
# A separate transform is neccessary for two reasons:
#  1. Empty :valueLists need to be emitted as empty arrays
#  2. This transform has to run before :valueString rules were executed,
#     because otherwise it would not be possible to distinguish between
#     empty :valueLists and single-value :valueLists that have tranformed :valueStrings
#    (because both contain "simple" child nodes
class ValueListTransform < Parslet::Transform
  rule(valueList: simple(:x)) { [] }

  rule(valueList: subtree(:x)) { x }
end
