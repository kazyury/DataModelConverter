module DataModel
  class FaceBase

    # FaceBase#convert()は再定義されなければならない
    # 引数としてparse_resultを受け取る
    def convert(parse_result)
      raise FaceImplementationError.new("MUST implement convert() method at #{self.class}")
    end
  end
end

