module DataModel
  class View
    def initialize(id)
      @id = id
      @name = nil
      @label = nil
      @schema = nil
      @checkType = nil
      @description = nil

      @query_expression = []
    end
    attr_accessor :name, :label, :schema, :checkType, :description
    attr_reader :id, :query_expression

    def attach_queryExpression(q)
      @query_expression.push q
    end

  end
end
