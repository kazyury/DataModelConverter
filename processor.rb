module DataModel
  class Processor
    def initialize
      @config = Configurator.instance
      @logger = @config.logger
      @parse_result={}
    end

    def process
      @parse_result = parse_datamodel

      @config.faces.each do |f|
        name = f['face']
        faceobj = factory(name)
        apply_option(faceobj, f)

        @logger.info("#{name}を使用して変換を開始します")
        faceobj.convert(@parse_result)
      end

    end

    ########################################################
    private
    def parse_datamodel
      parse_result={}
      dmtype = @config.dmtype
      @logger.debug("#{dmtype}用パーサを用いてパースします")
      case dmtype.upcase
      when 'IDA'
        parser = IDAParser.new
        parse_result[:dmtype] = 'IDA'
        parse_result[:ldm] = parser.parse_ldm(@config.ldm_path) if @config.ldm_path
        parse_result[:pdm] = parser.parse_pdm(@config.pdm_path) if @config.pdm_path
        parse_result[:ddm] = parser.parse_ddm(@config.ddm_path) if @config.ddm_path
        parse_result[:ndm] = parser.parse_ndm(@config.ndm_path) if @config.ndm_path
      else
        message="Sorry, 未実装のtype属性[#{dmtype}]です"
        @logger.error(message)
        raise NotImplementedDataModelError.new(message)
      end
      parse_result
    end


    def factory(name)
      klass_name = StringUtil.to_const_name(name)
      @logger.info("faces/#{klass_name}/#{name}をロードします")
      require "faces/#{klass_name}/#{name}"

      @logger.debug("#{klass_name}オブジェクトを生成します")
      const = DataModel.const_get(klass_name)
      const.new()
    end

    def apply_option(face, face_def)
      # オプション定義を適用
      face_def.each_pair do |k,v|
        next if k == 'face'
        @logger.debug("face option:[#{k}] => [#{v}] を適用します")
        face.__send__(k,v)
      end
    end

  end
end
