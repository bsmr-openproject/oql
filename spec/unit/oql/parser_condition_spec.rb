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
  describe 'condition rule' do
    let(:rule) { Parser.new.condition }

    it 'accepts conditions without whitespace' do
      expect(rule).to parse('a=="b"')
    end

    it 'accepts conditions with inner whitespace' do
      expect(rule).to parse('a   ==   "b"')
    end

    # not accepting preceding whitespace is due to
    # rule optimizations (EBNF does specify it that way)
    # don't know what's the best way to go here (keep or change EBNF?)
    it 'accepts conditions with trailing whitespace' do
      expect(rule).to parse('a == "b"    ')
    end

    it 'accepts conditions with field, operator and value' do
      expect(rule).to parse('a == "b"')
    end

    it 'rejects conditions without value' do
      expect(rule).to_not parse('a == ')
    end

    it 'rejects conditions without operator' do
      expect(rule).to_not parse('a "b"')
    end

    it 'rejects conditions without field' do
      expect(rule).to_not parse(' == "b"')
    end

    it 'returns exactly field, condition and value' do
      tree = rule.parse('a == "b"')

      expect(tree.keys).to include(:field, :operator, :values)
      expect(tree.keys.size).to eql 3
    end
  end
end