# Paramix
# Copyright 2010 Thomas Sawyer
# Apache 2.0 License

require 'paramix/version'

# Paramix namespace.
#
module Paramix

  # = Parametric
  #
  # Parametric mixins provides parameters for mixin modules.
  # Module parameters can be set at the time of inclusion 
  # or extension using Module#[] method, then parameters
  # can be accessed via the #mixin_parameters method.
  #
  #   module MyMixin
  #     include Paramix::Parametric
  #
  #     parameterized |params|
  #       define_method :hello do
  #         puts "Hello from #{params[:name]}!"
  #       end
  #     end
  #   end
  #
  #   class MyClass
  #     include MyMixin[:name => 'Ruby']
  #   end
  #
  #   MyClass.new.hello   #=> 'Hello from Ruby!'
  #
  module Parametric

    #
    def self.included(base)
      base.extend(Extensions)
    end

    #
    module Extensions
      #
      def [](parameters={})
        Mixin.new(self, parameters)
      end

      #
      def parameterized(&code)
        @code ||= []
        if block_given?
          @code << code
        else
          @code
        end
      end

      def append_features(base)
        return super(base) if Mixin === base || Mixin === self

        base.extend(Extensions)

        anc = ancestors.find{ |a| a.respond_to?(:parameterized) }
        base.parameterized.concat(anc.parameterized)

        super(base)
      end

      #
      def extend_object(base)
        return super(base) if Mixin === base || Mixin === self

        base.extend(Extensions)

        anc = ancestors.find{ |a| a.respond_to?(:parameterized) }
        base.parameterized.concat(anc.parameterized)

        super(base)
      end

    end

    # An instance of the Mixin module class is what is porduced
    # when parameters are applied to a parametric module.
    #
    class Mixin < Module

      def initialize(base, parameters)
        include(base)
        #base.append_features(self)
        base.parameterized.each do |code|
          instance_exec(parameters, &code)
        end
        #base.parameterized.clear
      end

      #
      def public(name, &code)
        define_method(name, &code)
        super(name)
      end

      #
      def private(name, &code)
        define_method(name, &code)
        super(name)
      end

      #
      def protected(name, &code)
        define_method(name, &code)
        super(name)
      end

    end

  end

end
