module ReportLogic
  class Session
    include Decorable

    attr_accessor :key

    def initialize(key = nil)
      @key = key
    end

    def fields
      @fields ||= []
    end

    def current_row
      @current_row ||= fields
    end

    def field(name, value = nil, **options)
      current_row << Field.new(name, value, **options)
    end

    def value(val, **options)
      field(nil, val, **options)
    end

    def process(collection = nil, &block)
      if collection.respond_to?(:each)
        collection.each do |record|
          @current_row = []
          instance_exec record, &block
          fields.push current_row
          @current_row = nil
        end
      else
        instance_exec &block
      end
    end

    def decorate(master_decorators = nil)
      master_decorators ||= []
      fields.each do |field_or_row|
        if field_or_row.respond_to?(:each)
          field_or_row.each { |f| f.decorate(master_decorators + decorators) }
        else
          field_or_row.decorate(master_decorators + decorators)
        end
      end
    end
  end
end
