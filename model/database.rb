module DataModel
  class Database
    def initialize(id)
      @id = id
      @name = nil
      @schemas = nil
      @groups = nil
      @tablespaces = nil
      @bufferpools = nil
      @version = nil
      @vendor = nil
    end
    attr_accessor :name, :schemas, :groups, :tablespaces, :bufferpools, :version, :vendor
    attr_reader :id

  end
end

