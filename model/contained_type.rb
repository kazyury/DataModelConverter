module DataModel
  class ContainedType
    def initialize(id)
      @config = Configurator.instance
      @logger = @config.logger
      @id = id
      @name = nil
      @type = nil
      @length = nil
      @fractionalSecondsPrecision = nil
      @precision = nil
      @primitiveType = nil
      @scale = nil
    end
    attr_accessor :name, :type, :fractionalSecondsPrecision, :precision, :primitiveType, :scale
    attr_writer :length  # length はCHARなどで桁数:1のときは未設定の場合があるので、attr_reader を使用しない
    attr_reader :id

    # length はCHARなどで桁数:1のときは未設定の場合があるので、attr_reader を使用しない
    def length
      case @name.first
      when 'CHAR' , 'VARCHAR' , 'CLOB' , 'BLOB'
        return ["1"] unless @length
        return @length
      else
        return @length
      end
    end


    alias :orig_to_s :to_s
    def to_s
      str = @name.first
      case @name.first
      when 'CHAR' , 'VARCHAR' , 'CLOB' , 'BLOB'
        if length
          str+="(#{length.first})"
        else
          @logger.warn("@lengthが未定義です[#{@id}]")
          str+="()"
        end
      when 'INTEGER' , 'SMALLINT' , 'TIMESTAMP' , 'DATE' , 'TIME'
        str+=''
      when 'DECIMAL'
        str+="(#{@precision.first},#{@scale.first})"
      else
        @logger.warn("未実装のデータ型：[#{@name.first}]")
        str = self.orig_to_s()
      end
      str
    end
  end
end

