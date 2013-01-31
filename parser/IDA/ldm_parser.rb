module DataModel
  class LDMParser
    def initialize
      @config = Configurator.instance
      @logger = @config.logger
      @model_space = ModelSpace.instance
      @result = {} # データの分類を示すシンボル=>値のHash. このLDMParserでは,:entity=>[EntityObj1,EntityObj2,...] の形式のみ
    end

    def parse(ldm)
      @logger.debug("論理データモデル[#{ldm}]の解析を開始します")
      doc = REXML::Document.new(File.read("inputs/#{Kconv.tosjis(ldm)}"))
      doc.elements.each('*/LogicalDataModel:Entity') do |elem|
        entity = Entity.new()
        entity.name=elem.attributes['name']
        @logger.debug("エンティティ[#{entity.inspect}]を発見しました")
        elem.elements.each('attributes') do |f|
          field = Field.new()
          field.name = f.attributes['name'] if f.attributes['name']
          field.description = f.attributes['description'] if f.attributes['description']
          field.data_type = f.attributes['dataType'] if f.attributes['dataType']
          field.required = f.attributes['required'] if f.attributes['required']
          entity.append(field)
        end
        if @result[:entity]
          @result[:entity].push entity
        else
          @result[:entity] = [entity]
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
  end
end
