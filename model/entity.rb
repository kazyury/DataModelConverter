
module DataModel
  class Entity
    def initialize
      @name = nil
      @label = nil
      @fields=[]
    end
    attr_accessor :name, :label
    attr_reader :fields

    def append(field)
      @fields.push field
    end

    def inspect
      buf = "name:#{@name}"
    end
  end
end

