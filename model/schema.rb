module DataModel
  class Schema
    def initialize(id)
      @id = id
      @sequences = nil
      @name = nil
      @database = nil
      @tables = nil
    end
    attr_accessor :sequences, :database, :tables
    attr_writer :name
    attr_reader :id

    def name
      @name.first
    end

  end
end

