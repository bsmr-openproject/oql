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

require 'oql/tree_transform'
require 'parslet/rig/rspec'

describe 'TreeTransform' do
  describe 'enforce_array method' do
    it 'does not wrap an array' do
      input = ['a', 'b']
      expect(TreeTransform.enforce_array(input)).to eql ['a', 'b']
    end

    it 'does wrap a string' do
      input = 'a'
      expect(TreeTransform.enforce_array(input)).to eql ['a']
    end

    it 'does wrap a hash' do
      input = { foo: 'bar' }
      expect(TreeTransform.enforce_array(input)).to eql [ { foo: 'bar' } ]
    end
  end
end