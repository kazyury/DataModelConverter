require 'erb'

module DataModel
  class TableList < FaceBase
    def initialize
      @logger = Configurator.instance.logger
      @erb_template='faces/TableList/table_list.erb'
      @outputs='outputs/table_list.csv'
    end

    def convert(parse_result)
      pdm = parse_result[:pdm]
      if pdm.empty?
        @logger.warn("物理データモデルの解析が行われていません")
        return
      end
      @logger.info("TableList フェイスで出力します")
      format=File.read(@erb_template)
      File.open(@outputs,'w'){|f| f.puts(Kconv.tosjis(ERB.new(format,0,"-").result(binding)))}
    end
  end
end
