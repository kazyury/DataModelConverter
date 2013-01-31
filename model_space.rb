module DataModel
  
  class ModelSpace
    include Singleton

    def initialize
      @model_space = {}
    end

    def put(obj)
      @model_space[obj.id]=obj
    end

    def get(id)
      @model_space[id]
    end
  end
end

