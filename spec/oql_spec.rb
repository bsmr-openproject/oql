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
       
    describe 'handles whitespace' do       
        it 'when there is none' do
            query = 'status=="1"&&type!="2"'

            expect { OQL.parse(query) }.to_not raise_error
        end
        
        it 'when there is too much' do
            query = '   status   ==   "1"   &&   type   !=   "2"   '

            expect { OQL.parse(query) }.to_not raise_error
        end
        
        it 'when there are linebreaks' do
            query = '
                    status
                    ==
                    "1"
                    &&
                    type
                    !=
                    "2"
                    '

            expect { OQL.parse(query) }.to_not raise_error
        end
    end
end