module DataModel
  class Table
    def initialize(id)
      @config = Configurator.instance
      @logger = @config.logger
      @model_space = ModelSpace.instance
      @id = id
      @name = nil
      @label = nil
      @schema = nil
      @description = nil
      @indexDataTableSpace = nil
      @regularDataTableSpace = nil
      @lobDataTableSpace = nil
      @referencingForeignKeys = nil

      @columns = []
      @constraints = []

      @schema_name = nil
      @index_tablespace_name = nil
      @regular_tablespace_name = nil
      @lob_tablespace_name = nil
    end
    attr_accessor :schema, :indexDataTableSpace, :regularDataTableSpace, :lobDataTableSpace, :referencingForeignKeys
    attr_writer :description, :label, :name
    attr_reader :id
    attr_reader :columns

    def name
      @name.first
    end

    def label
      @label.first
    end

    def description
      @description ? @description.first : ''
    end

    def attach_columns(column)
      @columns.push column
    end

    def attach_constraints(constraint)
      @constraints.push constraint
    end

    def has_lob_column?
      @logger.debug(@columns.collect{|c| c.to_s }.join(','))
      @columns.any?{|col| col.data_type == 'CLOB' or col.data_type == 'BLOB' }
    end

    def has_identity_column?
      ! @columns.all?{|col| col.identity_specifier.nil? }
    end

    def identity_columns
      @columns.find_all{|col| col.identity_specifier }
    end

    def schema_name
      unless @schema_name
        mod = @model_space.get(@schema)
        @schema_name = mod.name if mod.respond_to?(:name)
      end
      @schema_name
    end

    def index_tablespace_name
      unless @index_tablespace_name
        mod = @model_space.get(@indexDataTableSpace)
        @index_tablespace_name = mod.name if mod.respond_to?(:name)
      end
      @index_tablespace_name
    end

    def regular_tablespace_name
      unless @regular_tablespace_name
        mod = @model_space.get(@regularDataTableSpace)
        @regular_tablespace_name = mod.name if mod.respond_to?(:name)
      end
      @regular_tablespace_name
    end

    def lob_tablespace_name
      unless @lob_tablespace_name
        mod = @model_space.get(@lobDataTableSpace)
        @lob_tablespace_name = mod.name if mod.respond_to?(:name)
      end
      @lob_tablespace_name
    end
  end
end

