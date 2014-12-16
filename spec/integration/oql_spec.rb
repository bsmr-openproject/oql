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

require 'oql'

describe 'OQL' do
  it 'returns a valid tree for a simple query'do
    query = 'status == "1"'
    expected = {
      filters: [
        {
          condition: {
            field: 'status',
            operator: :is_equal,
            values: ['1']
          }
        }
      ]
    }

    expect(OQL.parse(query)).to eql expected
  end

  it 'returns a valid tree for multiple filters and values' do
    query = 'status == "1" && type != { "1", "2" }'
    expected = {
      filters: [
        {
          condition: {
            field: 'status',
            operator: :is_equal,
            values: ['1']
          }
        },
        {
          condition: {
            field: 'type',
            operator: :not_equal,
            values: ['1', '2']
          }
        }
      ]
    }

    expect(OQL.parse(query)).to eql expected
  end

  it 'returns a valid tree for a query with a single multi-value'do
    query = 'status == { "1" }'
    expected = {
      filters: [
        {
          condition: {
            field: 'status',
            operator: :is_equal,
            values: [ "1" ]
          }
        }
      ]
    }

    expect(OQL.parse(query)).to eql expected
  end

  it 'returns a valid tree for a query without value'do
    query = 'status == { }'
    expected = {
      filters: [
        {
          condition: {
            field: 'status',
            operator: :is_equal,
            values: [ ]
          }
        }
      ]
    }

    expect(OQL.parse(query)).to eql expected
  end

  it 'throws a ParsingFailed error on invalid input' do
    query = 'this is not a query!'

    expect { OQL.parse(query) }.to raise_error(ParsingFailed)
  end
end
