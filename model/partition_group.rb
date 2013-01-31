module DataModel
  class PartitionGroup
    def initialize(id)
      @id = id
      @name = nil
      @database = nil
      @tableSpaces = nil
      @partitions = nil
    end
    attr_accessor :name, :database, :tableSpaces, :partitions
    attr_reader :id
  end
end

