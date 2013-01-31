module DataModel
  class StringUtil
    def self.to_const_name(str)
      str.split('_').collect{|x| x.capitalize }.join('')
    end
  end

  class BooleanUtil
    def self.yes_no(bool)
      bool ? 'YES' : 'NO'
    end

    def self.y_blank(bool)
      bool ? 'Y' : ''
    end
  end
end

