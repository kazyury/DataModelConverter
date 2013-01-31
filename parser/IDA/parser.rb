module DataModel
  class IDAParser
    def initialize
      @config = Configurator.instance
      @logger = @config.logger
    end

    def parse_ldm(ldm)
      parser = LDMParser.new()
      parser.parse(ldm)
    end

    def parse_pdm(pdm)
      parser = PDMParser.new()
      parser.parse(pdm)
    end

    # TODO not implemented yet...
    def parse_ddm(ddm);end
    def parse_ndm(ndm);end
  end
end

