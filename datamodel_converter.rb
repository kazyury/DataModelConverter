#!ruby -Ku

require 'logger'
require 'kconv'
require 'optparse'
require 'rexml/document'
require 'singleton'

class Logger
  # 全体としてUTF-8で処理したいが、コンソールログが文字化けするのを防ぐため
  alias :orig_info :info
  alias :orig_debug :debug
  alias :orig_warn :warn
  alias :orig_error :error
  def info(message); orig_info(Kconv.tosjis(message)); end
  def debug(message);orig_debug(Kconv.tosjis(message));end
  def warn(message); orig_warn(Kconv.tosjis(message)); end
  def error(message);orig_error(Kconv.tosjis(message));end
end

require 'configurator.rb'
require 'exception.rb'
require 'model_space.rb'
require 'processor.rb'
require 'util.rb'
require 'parser/IDA/parser.rb'
require 'parser/IDA/pdm_parser.rb'
require 'parser/IDA/ldm_parser.rb'
require 'model/database.rb'
require 'model/partition_group.rb'
require 'model/partition.rb'
require 'model/table_space.rb'
require 'model/buffer_pool.rb'
require 'model/schema.rb'
require 'model/table.rb'
require 'model/view.rb'
require 'model/sequence.rb'
require 'model/column.rb'
require 'model/contained_type.rb'
require 'model/constraints.rb'
require 'model/identity.rb'
require 'model/identity_specifier.rb'
require 'model/query_expression.rb'
require 'model/entity.rb'
require 'model/field.rb'
require 'faces/face_base.rb'

module DataModel
  # UI層を司るbootstrapクラス
  class DatamodelConverter
    def initialize(conf)
      @config = Configurator.instance
      @config.configuration_file=conf
      @logger = @config.logger
      @logger.level = Logger::INFO
    end
    attr_reader :config

    def log_level=(l)
      @logger.level=l
      @logger.debug("ログレベルを#{l}に変更しました")
    end

    def execute
      @logger.info("構成情報をロードします")
      @config.load
      @logger.debug("以下の構成情報をロードしました\n#{@config.inspect}")
      Processor.new.process
    end

   
    ########################################################
    private


  end
end


# bootstrap
option={}
opt=OptionParser.new
opt.banner ="DataModelConverter\n"
opt.banner+="- your datamodel should have pretty face.\n\n"
opt.banner+="[usage] #{$0} configuration-file"
opt.on('-v','--verbose' ,'冗長出力をONにします'){|v| option[:verbose] = true}
opt.on('-h','--help'    ,'Show this message'){|v| puts opt ; exit }
opt.parse!(ARGV)

if ARGV.size==0
	puts opt
	exit
end

app=DataModel::DatamodelConverter.new(ARGV[0])
app.log_level = Logger::DEBUG if option[:verbose]
app.execute

