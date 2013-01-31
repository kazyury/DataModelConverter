module DataModel
  class BufferPool
    def initialize(id)
      @id = id
      @name = nil
      @size = nil
      @database = nil
      @tableSpaces = nil
    end
    attr_accessor :name, :size, :database, :tableSpaces
    attr_reader :id

  end
end
