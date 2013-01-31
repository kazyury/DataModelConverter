
module DataModel
  class Field
    def initialize
      @name = nil
      @label = nil
      @data_type = nil
      @required = nil
      @description = nil
    end
    attr_accessor :name, :label, :data_type, :required, :description

    def inspect
      buf = "name:#{@name}]"
    end
  end
end

