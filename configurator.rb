
module DataModel
  # 構成情報を管理するsingletonクラス
  class Configurator
    include Singleton

    def initialize
      @configuration_file = nil
      @logger = Logger.new(STDOUT)
      @dmtype = nil
      @faces  = []
      # IDA データモデル用
      @ldm_path = nil
      @pdm_path = nil
      @ddm_path = nil
      @ndm_path = nil
    end
    attr_accessor :configuration_file
    attr_reader :dmtype, :logger, :faces
    attr_reader :ldm_path, :pdm_path, :ddm_path, :ndm_path

    def load
      @logger.info("構成ファイルの検査を開始します。")
      unless File.exist?(@configuration_file)
        message="構成ファイル[#{@configuration_file}]が存在しません"
        @logger.error(message)
        raise ConfigError.new(message)
      end

      doc = REXML::Document.new(File.read(@configuration_file))
      root=doc.root

      # datamodel
      # 当面はIDA以外実装する予定なし.
      @dmtype = root.elements['datamodel'].attributes['type']
      case @dmtype.upcase
      when 'IDA'
        @ldm_path = root.elements['datamodel/inputs/ldm_path'].text if root.elements['datamodel/inputs/ldm_path']
        @pdm_path = root.elements['datamodel/inputs/pdm_path'].text if root.elements['datamodel/inputs/pdm_path']
        @ddm_path = root.elements['datamodel/inputs/ddm_path'].text if root.elements['datamodel/inputs/ddm_path']
        @ndm_path = root.elements['datamodel/inputs/ndm_path'].text if root.elements['datamodel/inputs/ndm_path']
      else
        message="Sorry, 未実装のtype属性[#{dmtype}]です"
        @logger.error(message)
        raise NotImplementedDataModelError.new(message)
      end

      # faces
      root.elements.each('faces/face'){|face|
        face_conf = {}
        face_conf['face'] = face.attributes['value']
        face.elements.each('option'){|opt|
          optkey=opt.attributes['key']
          optval=opt.attributes['value']
          face_conf[optkey] = optval
        }
        @faces.push face_conf
      }
    end

    def to_s
      buf = "Configuration File:[#{@configuration_file}]\n"
      buf+= "DataModel type    :[#{@dmtype}]\n"
      buf+= "  ldm model path  :[#{@ldm_path}]\n" if @ldm_path
      buf+= "  pdm model path  :[#{@pdm_path}]\n" if @pdm_path
      buf+= "  ddm model path  :[#{@ddm_path}]\n" if @ddm_path
      buf+= "  ndm model path  :[#{@ndm_path}]\n" if @ndm_path
      @faces.each do |f|
        buf+="---------------\n"
        f.each_pair do |k,v|
          buf+= "Faces :[#{k}]=>[#{v}]\n"
        end
      end
      buf
    end
  end
end


