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

require 'oql/value_list_transform'
require 'parslet/rig/rspec'

describe 'TreeTransform' do
  let(:transform) { ValueListTransform.new }

  describe 'valueList rules' do
    it 'transforms empty lists' do
      tree = { valueList: '{ }' }
      expect(transform.apply(tree)).to eql []
    end

    it 'transforms non-empty lists' do
      tree = { valueList: { valueString: 'foobar!' } }
      expected = { valueString: 'foobar!' }
      expect(transform.apply(tree)).to eql expected
    end
  end
end