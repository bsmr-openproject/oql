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
require 'parslet'
require 'parslet/rig/rspec'

describe 'TreeTransform' do
  let(:transform) { TreeTransform.new }

  describe 'filters rule' do
    it 'wraps single filters' do
      tree = { filters: { foo: 'bar' } }
      expect(transform.apply(tree)[:filters]).to eql [ { foo: 'bar' } ]
    end

    it 'keeps multiple filters unchanged' do
      tree = { filters: [ { foo: 'bar' }, { foo: 'bar' } ] }
      expect(transform.apply(tree)[:filters]).to eql [ { foo: 'bar' }, { foo: 'bar' } ]
    end
  end
end