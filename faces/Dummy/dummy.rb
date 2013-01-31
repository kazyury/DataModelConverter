module DataModel
  class Dummy < FaceBase
    def initialize; @logger = Configurator.instance.logger; end
    def opt1(val);@logger.debug("Hi! This is Dummy Face. Method:opt1 was called with #{val}");end
    def convert(parse_result); @logger.debug("Hi! This is Dummy Face. convert() was called");end
  end
end

