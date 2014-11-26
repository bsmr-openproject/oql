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
  describe 'operator rule' do
    let(:rule) { Parser.new.operator }

    it 'supports the equals operator' do
      expect(rule).to parse('==')
    end

    it 'supports the not equal operator' do
      expect(rule).to parse('!=')
    end

    it 'supports the contains operator' do
      expect(rule).to parse('~')
    end

    it 'consumes whitespaces' do
      expect(rule).to parse('    ~    ')
    end

    it 'does not return whitespace to the tree' do
      tree = rule.parse('    ~    ')
      result = tree[:operator].to_s

      expect(result).to eql '~'
    end
  end
end