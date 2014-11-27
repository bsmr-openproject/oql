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
  describe 'field rule' do
    let(:rule) { Parser.new.field }

    it 'accepts fields that contain numbers' do
      expect(rule).to parse('field12')
    end

    it 'accepts fields that contain upper and lower case' do
      expect(rule).to parse('FieldOne')
    end

    it 'rejects fields that start with a number' do
      expect(rule).to_not parse('1field')
    end

    it 'rejects fields that contain non ASCII characters' do
      expect(rule).to_not parse('füld')
    end

    it 'rejects fields that contain underscores' do
      expect(rule).to_not parse('field_one')
    end
  end
end
