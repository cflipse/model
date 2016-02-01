require 'test_helper'

SEQUEL_TO_HANAMI_MAPPING = {
  'Sequel::UniqueConstraintViolation'     => 'Hanami::Model::UniqueConstraintViolationError',
  'Sequel::ForeignKeyConstraintViolation' => 'Hanami::Model::ForeignKeyConstraintViolationError',
  'Sequel::NotNullConstraintViolation'    => 'Hanami::Model::NotNullConstraintViolationError',
  'Sequel::CheckConstraintViolation'      => 'Hanami::Model::CheckConstraintViolationError'
}

describe Hanami::Model::Adapters::Sql::Command do
  describe 'when #create raises Sequel Database Violation Error' do
    SEQUEL_TO_HANAMI_MAPPING.each do |sequel_error, hanami_error|

      it "raises #{hanami_error} instead of #{sequel_error}" do
        query = SqlQueryFake.new
        command = Hanami::Model::Adapters::Sql::Command.new(query)

        query.scoped.stub(:insert, ->(entity) { raise Object.const_get(sequel_error).new }) do
          assert_raises(Object.const_get(hanami_error)) { command.create(Object.new) }
        end
      end

    end
  end

  describe 'when #update raises Sequel Database Violation Error' do
    SEQUEL_TO_HANAMI_MAPPING.each do |sequel_error, hanami_error|

      it "raises #{hanami_error} instead of #{sequel_error}" do
        query = SqlQueryFake.new
        command = Hanami::Model::Adapters::Sql::Command.new(query)

        query.scoped.stub(:update, ->(entity) { raise Object.const_get(sequel_error).new }) do
          assert_raises(Object.const_get(hanami_error)) { command.update(Object.new) }
        end
      end

    end
  end

  describe 'when #delete raises Sequel Database Violation Error' do
    SEQUEL_TO_HANAMI_MAPPING.each do |sequel_error, hanami_error|

      it "raises #{hanami_error} instead of #{sequel_error}" do
        query = SqlQueryFake.new
        command = Hanami::Model::Adapters::Sql::Command.new(query)

        query.scoped.stub(:delete, -> { raise Object.const_get(sequel_error).new }) do
          assert_raises(Object.const_get(hanami_error)) { command.delete }
        end
      end
    end
  end

  class SqlQueryFake
    def scoped
      @collection ||= CollectionFake.new
    end
  end

  class CollectionFake
    def insert(entity)
    end

    def update(entity)
    end

    def delete
    end
  end
end
