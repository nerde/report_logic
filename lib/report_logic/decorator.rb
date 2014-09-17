module ReportLogic
  class Decorator
    def decorate(field)
      raise NotImplementedError
    end

    def decorate_if_matches(field)
      decorate(field) if matches?(field)
    end

    def matches?(field)
      true
    end
  end
end
