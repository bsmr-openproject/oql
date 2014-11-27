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
  describe 'filterlist rule' do
    let(:rule) { Parser.new.filterList }

    it 'accepts a single condition' do
      expect(rule).to parse('a=="b"')
    end

    it 'accepts a single and-concatenation' do
      expect(rule).to parse('a=="b" && a=="b"')
    end

    it 'accepts multiple and-concatenations' do
      expect(rule).to parse('a=="b" && a=="b" && a=="b" && a=="b"')
    end

    it 'accepts and-concatenation with extra whitespace' do
      expect(rule).to parse('a=="b"   &&   a=="b"')
    end

    it 'accepts and-concatenation with missing whitespace' do
      expect(rule).to parse('a=="b"&&a=="b"')
    end

    it 'returns a single hash for single filters' do
      expect(rule.parse('a=="b"')).to be_kind_of(Hash)
    end

    it 'returns an array for multiple filters' do
      result = rule.parse('a=="b" && a=="b"')
      expect(result).to be_kind_of(Array)
      expect(result.size).to eql 2
    end
  end
end