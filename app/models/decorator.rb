module Decorator

  def in_transaction(*method_names)
    m = Module.new do
      method_names.each do |name|
        define_method name do |*params|
          transaction do
            super(*params)
          end
        end
      end
    end
    prepend m
  end
end
