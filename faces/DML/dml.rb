require 'erb'

module DataModel
  class Dml < FaceBase
    def initialize
      @logger = Configurator.instance.logger
      @export_template='faces/DML/export.erb'
      @import_template='faces/DML/import.erb'
      @refresh_id_template='faces/DML/refresh_identity.erb'
      @table = nil
      @schema = nil
    end

    def schema(name)
      @schema = name.upcase
    end

    def table(name)
      @table = name.upcase
    end

    def convert(parse_result)
      export_statement="outputs/export_#{@schema}.#{@table}.sql"
      import_statement="outputs/import_#{@schema}.#{@table}.sql"
      refresh_statement="outputs/refresh_id_#{@schema}.#{@table}.sql"
      pdm = parse_result[:pdm]
      tab = preconvert(pdm)
      return unless tab

      @logger.info("DML フェイスでExport文を出力します")
      format=File.read(@export_template)
      File.open(export_statement,'w'){|f| f.puts(Kconv.tosjis(ERB.new(format,0,"-").result(binding)))}
      @logger.info("DML フェイスでImport文を出力します")
      format=File.read(@import_template)
      File.open(import_statement,'w'){|f| f.puts(Kconv.tosjis(ERB.new(format,0,"-").result(binding)))}

      if tab.has_identity_column?
        @logger.info("DML フェイスでID列のrefresh文を出力します。設定値はxxxとしているので値を適宜確認してください。")
        format=File.read(@refresh_id_template)
        File.open(refresh_statement,'w'){|f| f.puts(Kconv.tosjis(ERB.new(format,0,"-").result(binding)))}
      end
      @logger.info("[#{tab.label}]用DMLの出力を完了しました")
    end

    def preconvert(pdm)
      if pdm.empty?
        @logger.warn("物理データモデルの解析が行われていません")
        return false
      end
      unless @table and @schema
        @logger.warn("このフェイスにはkey='table', key='schema'指定が必要です")
        return false
      end
      #tableObj = pdm[:table].find{|x| Kconv.tosjis(x.name) == @table }
      tableObj = pdm[:table].find{|x| x.name.upcase == @table && x.schema_name.upcase == @schema }
      unless tableObj
        @logger.warn("解析結果に#{@schema}.#{@table}テーブルが含まれていません")
        @logger.debug("解析結果[ #{pdm[:table].collect{|x|x.name}.join(',')} ]")
        return false
      end
      return tableObj
    end

  end
end
