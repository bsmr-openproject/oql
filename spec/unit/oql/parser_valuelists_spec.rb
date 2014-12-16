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
  describe 'valuelist rule' do
    let(:rule) { Parser.new.valueList }

    it 'can contain no values' do
      expect(rule).to parse('{ }')
    end

    it 'can contain a single value' do
      expect(rule).to parse('{ "1" }')
    end

    it 'can contain multiple values' do
      expect(rule).to parse('{ "1", "2", "3" }')
    end

    it 'can parse with missing whitespace' do
      expect(rule).to parse('{"1","2","3"}')
    end

    it 'can parse with extra whitespace' do
      expect(rule).to parse('   {   "1"   ,   "2"   ,   "3"   }   ')
    end

    it 'can parse empty list with missing whitespace' do
      expect(rule).to parse('{}')
    end

    it 'can parse empty list with missing whitespace' do
      expect(rule).to parse('   {      }   ')
    end

    it 'returns one element per value' do
      tree = rule.parse('{ "1", "2", "3" }')
      expect(tree[:valueList].size).to eql 3
    end

    it 'can not parse extra comma in front of value' do
      expect(rule).to_not parse('{,"1"}')
    end

    it 'can not parse extra comma after value' do
      expect(rule).to_not parse('{"1",}')
    end
  end
end
