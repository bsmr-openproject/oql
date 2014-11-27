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
  let(:transform) { TreeTransform.new }

  describe 'valueString rules' do
    it 'transforms empty strings' do
      tree = { valueString: [] }
      expect(transform.apply(tree)).to eql ''
    end

    it 'transforms non-empty strings' do
      tree = { valueString: 'foobar!' }
      expect(transform.apply(tree)).to eql 'foobar!'
    end

    it 'transforms an escaped quote' do
      tree = { valueString: 'Foo\"Bar\"' }
      expect(transform.apply(tree)).to eql 'Foo"Bar"'
    end

    it 'transforms an escaped backslash' do
      tree = { valueString: 'Foo\\\\Bar\\\\s' }
      expect(transform.apply(tree)).to eql 'Foo\Bar\s'
    end

    it 'transforms an escaped quote escape sequence' do
      tree = { valueString: 'To print a \" you have to write \\\\\\".' }
      expect(transform.apply(tree)).to eql 'To print a " you have to write \".'
    end
  end
end
