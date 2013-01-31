module DataModel
  class TableSpace
    def initialize(id)
      @id = id
      @name = nil
      @database = nil
      @group = nil
      @bufferPool = nil
      @tablespaceType = nil
      @managementType = nil
      @indexDataTables = nil
      @regularDataTables = nil
      @lobDataTables = nil
    end
    attr_accessor :name, :database, :group, :bufferPool, :tablespaceType, :managementType, :indexDataTables, :regularDataTables, :lobDataTables
    attr_reader :id

  end
end
