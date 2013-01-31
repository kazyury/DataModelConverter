module DataModel
  class Sequence
    def initialize(id)
      @id = id
      @name = nil
      @label = nil
      @schema = nil

      @contained_type = []
      @identity_specifier = []
    end
    attr_accessor :name, :label, :schema
    attr_reader :id
    attr_reader :contained_type, :identity_specifier

    def attach_containedType(type)
      @contained_type.push type
    end

    def attach_identity(s)
      @identity_specifier.push s
    end

  end
end

