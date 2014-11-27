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
require 'parslet'
require 'parslet/rig/rspec'

describe 'TreeTransform' do
  let(:transform) { TreeTransform.new }
  let(:field) { double('field', to_s: 'foo') }
  let(:operator) { double('operator', to_s: 'bar') }
  let(:values) { double('values', to_s: 'baz') }

  describe 'condition rule' do
    it 'transforms into the same structure' do
      tree = { field: field, operator: operator, values: values }
      result = transform.apply(tree)
      expect(result.keys).to include(:field, :operator, :values)
      expect(result.keys.size).to eql 3
    end

    it 'symbolifies the == operator' do
      tree = { field: field, operator: '==', values: values }
      expect(transform.apply(tree)[:operator]).to eql :is_equal
    end

    it 'symbolifies the != operator' do
      tree = { field: field, operator: '!=', values: values }
      expect(transform.apply(tree)[:operator]).to eql :not_equal
    end

    it 'symbolifies the ~ operator' do
      tree = { field: field, operator: '~', values: values }
      expect(transform.apply(tree)[:operator]).to eql :contains
    end

    it 'stringifies the field' do
      tree = { field: field, operator: operator, values: values }
      expect(transform.apply(tree)[:field]).to eql field.to_s
    end

    it 'stringifies the operator' do
      expect(operator).to receive(:to_s)
      tree = { field: field, operator: operator, values: values }
      transform.apply(tree)
    end

    it 'wraps a single value into an array' do
      tree = { field: field, operator: operator, values: values }
      expect(transform.apply(tree)[:values]).to eql [values]
    end

    it 'does not wrap multiple values' do
      tree = { field: field, operator: operator, values: ['a', 'b'] }
      expect(transform.apply(tree)[:values]).to eql ['a', 'b']
    end
  end
end
