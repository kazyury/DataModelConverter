module DataModel
  class IdentitySpecifier
    def initialize(id)
      @id = id
      @cycleOption = nil
      @increment = nil
      @maximum = nil
      @minimum = nil
      @startValue = nil
      @type = nil

    end
    attr_accessor :cycleOption, :increment, :maximum, :minimum, :startValue, :type
    attr_reader :id


  end
end

