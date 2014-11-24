require 'oql'

describe 'OQL' do
    describe 'parse' do
        it 'accepts a simple equals' do
            query = 'status == "1"'
            expected = {
                filter: {
                    condition: {
                        field: 'status',
                        operator: :is_equal,
                        values: [ '1' ]
                    }
                }
            }

            expect(OQL.parse(query)).to eql expected
        end
        
        it 'accepts a simple not equal' do
            query = 'status != "1"'
            expected = {
                filter: {
                    condition: {
                        field: 'status',
                        operator: :not_equal,
                        values: [ '1' ]
                    }
                }
            }

            expect(OQL.parse(query)).to eql expected
        end
        
        it 'accepts a simple contains' do
            query = 'name ~ "foo"'
            expected = {
                filter: {
                    condition: {
                        field: 'name',
                        operator: :contains,
                        values: [ 'foo' ]
                    }
                }
            }

            expect(OQL.parse(query)).to eql expected
        end
    end
end