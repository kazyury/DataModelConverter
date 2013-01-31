module DataModel
  class PDMParser
    
    # 物理データモデルファイル内のエレメント名をキーとし、
    # 格納結果キーシンボル、実装するモデルクラス名の配列を値としたHash
    IMPLEMENTED_FIRSTCLASS_ELEMENTS={
      'LUWDatabase'=>[:database, 'Database'],
      'LUWPartitionGroup'=>[:partitiongroup, 'PartitionGroup'],
      'LUWDatabasePartition'=>[:partition, 'Partition'],
      'LUWBufferPool'=>[:bufferpool, 'BufferPool'],
      'LUWTableSpace'=>[:tablespace, 'TableSpace'],
      'DB2Schema'=>[:schema, 'Schema'],
      'LUWTable'=>[:table, 'Table'],
      'LUWView'=>[:view, 'View'],
      'Sequence'=>[:sequence, 'Sequence']
    }

    # 構造はIMPLEMETED_FIRSTCLASS_ELEMENTS と同様
    # こちらは子要素
    IMPLEMENTED_CHILD_ELEMENTS={
      'columns'=>[:column, 'Column'],
      'containedType'=>[:containedType, 'ContainedType'],
      'constraints'=>[:constraints, 'Constraints'],
      'identitySpecifier'=>[:identitySpecifier, 'IdentitySpecifier'],
      'queryExpression'=>[:queryExpression,'QueryExpression'],
      'identity'=>[:identity, 'Identity']
    }

    def initialize
      @config = Configurator.instance
      @logger = @config.logger
      @model_space = ModelSpace.instance
      @result = {}
    end

    def parse(pdm)
      @logger.debug("物理データモデル[#{pdm}]の解析を開始します")
      doc = REXML::Document.new(File.read("inputs/#{Kconv.tosjis(pdm)}"))
      root = doc.root
      root.elements.each do |elem|
        if IMPLEMENTED_FIRSTCLASS_ELEMENTS.include?(elem.name)
          result_key  = IMPLEMENTED_FIRSTCLASS_ELEMENTS[elem.name].first
          model_klass = IMPLEMENTED_FIRSTCLASS_ELEMENTS[elem.name].last
          if @result[result_key]
            @result[result_key].push build_model(model_klass,elem)
          else
            @result[result_key] = [build_model(model_klass, elem)]
          end
          @logger.debug("[#{elem.name}]を認識しました")
        else
          @logger.warn("未実装の第1クラス要素:#{elem.name}です。スキップします")
        end
      end
      if @logger.debug?
        @result.each do |key,val|
          @logger.debug("解析結果 @result[:#{key}]は以下の値です")
          val.each do |v|
            @logger.debug("　CLASS:[#{v.class}] #{v.to_s}")
          end
        end
      end
      @result
    end

    ############################################################################
    private
    def build_model(klass_name, elem)
      attributes = attribute_map(elem)
      id = attributes['id']
      unless id
        message = "必須属性[ID]が#{klass_name}に存在しません"
        @logger.error(message)
        raise DataModelParseError.new(message)
      end

      @logger.debug("DataModel::#{klass_name}オブジェクトを生成します。ID=[#{id}]")
      const = DataModel.const_get(klass_name)
      obj = const.new(id)
      @model_space.put(obj)
      attributes.each do |nm, val|
        begin
          obj.__send__("#{nm}=", val) unless nm == 'id'
        rescue NoMethodError
          @logger.warn("@#{klass_name} 未実装の属性:#{nm}です。スキップします")
        end
      end

      # element に子要素(ただしeAnnotationsを除く)が存在する場合、
      # 再帰的にbuild_modelを呼び出す
      elem.elements.each do |child|
        next if child.name == 'eAnnotations'
        if IMPLEMENTED_CHILD_ELEMENTS.include?(child.name)
          result_key  = IMPLEMENTED_CHILD_ELEMENTS[child.name].first
          model_klass = IMPLEMENTED_CHILD_ELEMENTS[child.name].last
          child_obj = build_model(model_klass, child)

          begin # 子要素を親要素にattach
            obj.__send__("attach_#{child.name}", child_obj)
          rescue NoMethodError
            @logger.warn("@#{klass_name} 未実装の子要素:#{child.name}です。スキップします")
          end
        else
          @logger.warn("未実装の第2クラス要素:#{child.name}です。スキップします")
        end
      end
      obj
    end

    def attribute_map(elem)
      map={}
      elem.attributes.each do |nm, val|
        nm = 'id' if nm == 'xmi:id'
        nm = 'type' if nm == 'xsi:type'
        nm = 'lobDataTables' if nm == 'LOBDataTables'
        nm = 'lobDataTableSpace' if nm == 'LOBDataTableSpace'
        nm = 'foreignKey' if nm == 'ForeignKey'
        nm = 'sql' if nm == 'SQL'
        /\s/=~val ?  val = val.split(/\s/) : val = [val]
        map[nm] = val
      end
      map
    end

  end
end
