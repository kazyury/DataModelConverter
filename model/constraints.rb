module DataModel
  class Constraints
    def initialize(id)
      @id = id
      @name = nil
      @label = nil
      @type = nil
      @uniqueConstraint = nil
      @members = nil
      @onDelete = nil
      @referencedTable = nil
      @foreignKey = nil

    end
    attr_accessor :name, :label, :type, :uniqueConstraint, :members, :onDelete, :referencedTable, :foreignKey
    attr_reader :id

  end
end

