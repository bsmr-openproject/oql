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
  describe 'value rule' do
    let(:rule) { Parser.new.value }

    it 'can contain link-ish content' do
      expect(rule).to parse('"/api/v3/statuses/2"')
    end

    it 'can contain whitespace and punctuation' do
      expect(rule).to parse('"This is a sentence, with comma."')
    end

    it 'can contain umlaute' do
      expect(rule).to parse('"Straßenhäuser"')
    end

    it 'can be empty' do
      expect(rule).to parse('""')
    end

    it 'can contain an escaped "' do
      expect(rule).to parse('"Foo\"Bar\""')
    end

    it 'can contain an escaped backslash' do
      expect(rule).to parse('"Foo\\\\Bar\\\\s"')
    end

    it 'can contain an escaped " escape sequence' do
      expect(rule).to parse('"To print a \" you have to write \\\\\\"."')
    end

    it 'cannot contain an " alone' do
      expect(rule).to_not parse('"Foo"Bar"')
    end

    it 'cannot contain an " after an escaped backslash' do
      expect(rule).to_not parse('"Foo\\\\"Bar"')
    end

    it 'cannot escape anything but " and backslash' do
      expect(rule).to_not parse('"Fu\n"')
    end

    it 'does not return outer quotes to the tree' do
      tree = rule.parse('    "string"    ')
      result = tree[:valueString].to_s

      expect(result).to eql 'string'
    end
  end
end