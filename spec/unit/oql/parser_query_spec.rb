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

require 'oql/parser'
require 'parslet/rig/rspec'

describe 'Parser' do
  describe 'query rule' do
    let(:rule) { Parser.new.query }

    it 'accepts a single filter' do
      expect(rule).to parse('a=="b"')
    end

    it 'accepts leading and trailing whitespace' do
      expect(rule).to parse('   a=="b"   ')
    end

    it 'returns hash with :filters for single filters' do
      expect(rule.parse('a=="b"')).to include(:filters)
    end

    it 'returns hash with :filters for multiple filters' do
      result = rule.parse('a=="b" && a=="b"')
      expect(result).to include(:filters)
    end
  end
end