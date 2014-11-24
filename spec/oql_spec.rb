require 'oql'

describe 'OQL' do
    describe 'parse' do
        it 'accepts a simple equals' do
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
        
        it 'accepts a simple not equal' do
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
        
        it 'accepts a simple contains' do
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
        
        it 'accepts conditions that are AND-concatenated' do
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
        
        it 'accepts a fully featured query without any whitespace' do
            query = 'status=="1"&&type!="2"'

            expect { OQL.parse(query) }.to_not raise_error
        end
        
        it 'accepts a fully featured query with too many whitespaces' do
            query = '   status   ==   "1"   &&   type   !=   "2"   '

            expect { OQL.parse(query) }.to_not raise_error
        end
    end
end