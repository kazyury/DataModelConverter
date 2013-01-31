module DataModel
  class Column
    def initialize(id)
      @config = Configurator.instance
      @logger = @config.logger
      @model_space = ModelSpace.instance
      @id = id
      @name = nil
      @label = nil
      @type = nil
      @nullable = nil
      @defaultValue = nil
      @description = nil

      @contained_type = nil
      @identity_specifier = nil
    end
    attr_accessor :type, :nullable, :defaultValue, :description
    attr_reader :id
    attr_reader :contained_type, :identity_specifier
    attr_writer :name, :label 

    # Columnのcontaind_type は 単数なので注意
    def attach_containedType(type)
      @contained_type=type
    end

    # Columnのidentity_specifier は 単数なので注意
    def attach_identitySpecifier(s)
      @identity_specifier = s
    end

    def name
      @name.first
    end

    def label
      @label.first
    end

    def data_type
      @contained_type.name.first
    end

    def length
      @contained_type.length
    end

    def to_s
      str = ""
      str+= "#{@name.first} " if @name
      str+= "#{@contained_type.to_s} " if @contained_type
      if @nullable
        str +='NOT NULL ' if @nullable.first.upcase == 'FALSE'
      else
        str +='NOT NULL '
      end
      str
    end


  end
end

