module DataModel
  class Partition
    def initialize(id)
      @id = id
      @group = nil
    end
    attr_accessor :group
    attr_reader :id

  end
end

