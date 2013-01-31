module DataModel
  class QueryExpression
    def initialize(id)
      @id = id
      @sql = nil
      @type = nil

    end
    attr_accessor :sql, :type
    attr_reader :id

  end
end

