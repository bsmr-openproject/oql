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
  describe 'supports the operator' do
    it 'equals' do
      query = 'status == "1"'
      expected = {
        filters: [
          {
            condition: {
              field: 'status',
              operator: :is_equal,
              values: [ '1' ]
            }
          }
        ]
      }

      expect(OQL.parse(query)).to eql expected
    end

    it 'not equal' do
      query = 'status != "1"'
      expected = {
        filters: [
          {
            condition: {
              field: 'status',
              operator: :not_equal,
              values: [ '1' ]
            }
          }
        ]
      }

      expect(OQL.parse(query)).to eql expected
    end

    it 'contains' do
      query = 'name ~ "foo"'
      expected = {
        filters: [
          {
            condition: {
              field: 'name',
              operator: :contains,
              values: [ 'foo' ]
            }
          }
        ]
      }

      expect(OQL.parse(query)).to eql expected
    end
  end

  describe 'supports AND concatenation' do
    it 'once' do
      query = 'status == "1" && type != "2"'
      expected = {
        filters: [
          {
            condition: {
              field: 'status',
              operator: :is_equal,
              values: [ '1' ]
            }
          },
          {
            condition: {
              field: 'type',
              operator: :not_equal,
              values: [ '2' ]
            }
          }
        ]
      }

      expect(OQL.parse(query)).to eql expected
    end

    it 'repeatedly' do
      query = 'status == "1" && type != "2" && status == "1" && type != "2"'
      result = OQL.parse(query)

      expect(result[:filters].size).to eql 4
    end
  end

  # --------------------------------------------------------
  # integrative tests to keep (TODO: remove this line once tests above have been replaced by unit tests)
  # --------------------------------------------------------

  it 'returns a valid tree for a simple query'do
    query = 'status == "1"'
    expected = {
      filters: [
        {
          condition: {
            field: 'status',
            operator: :is_equal,
            values: [ '1' ]
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
            values: [ '1' ]
          }
        },
        {
          condition: {
            field: 'type',
            operator: :not_equal,
            values: [ '1', '2' ]
          }
        }
      ]
    }

    expect(OQL.parse(query)).to eql expected
  end

  it 'throws a ParsingFailed error on invalid input' do
    query = 'this is not a query!'

    expect{OQL.parse(query)}.to raise_error(ParsingFailed)
  end

  it 'handles missing whitespace' do
    query = 'status=="1"&&type!={"2","3"}'

    expect { OQL.parse(query) }.to_not raise_error
  end

  it 'handles extra whitespace' do
    query = '   status   ==   "1"   &&   type   !=   {   "2"   ,   "3"   }   '

    expect { OQL.parse(query) }.to_not raise_error
  end

  it 'handles linebreaks' do
    query = '
            status
            ==
            "1"
            &&
            type
            !=
            {
            "2"
            ,
            "3"
            }
            '

    expect { OQL.parse(query) }.to_not raise_error
  end
end