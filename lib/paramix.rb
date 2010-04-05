# = Parametric Mixin
#
# Parametric Mixins provides parameters for mixin modules.
# Module parameters can be set at the time of inclusion 
# or extension using Module#[] method, then parameters
# can be accessed via the #mixin_param and #mixin_parameters
# methods.
#
#   module MyMixin
#     include Paramix
#
#     def hello
#       puts "Hello from #{ mixin_param(MyMixin, :name) }!"
#     end
#   end
#
#   class MyClass
#     include MyMixin[:name => 'Ruby']
#   end
#
#   m = MyClass.new
#   m.hello   #=> 'Hello from Ruby!'
#
# You can view the full set of parameters via the +mixin_parameters+ method.
#
#   MyClass.mixin_parameters  #=> {MyMixin => {:name => 'ruby'}}
#
# Including Paramix into a module is essentially equivalent to defining
# a module method:
#
#   def [](parameters)
#     Paramix::Proxy.new(self, parameters)
#   end
#
# Paramix::Proxy.new can also take a block that injects code into the
# mixin. This is useful as an alternative to using the #included
# callback for creating metaclass dynamics based on mixin parameters.
# For example:
#
#   module MyMixin
#     def self.[](parameters)
#       Paramix::Mixin.new(self, parameters) do
#         attr_accessor parameters[:name]
#       end
#     end
#   end
#
# As opposed to:
#
#   module MyMixin
#     include Paramix
#
#     def self.included(base)
#       base.class_eval do
#         attr_accessor base.mixin_parameters[MyMixin][:name]
#       end
#       super(base)
#     end
#   end
#
module Paramix

  #
  def self.included(base)
    base.extend(ClassMethods)
    super(base)
  end

  #
  module ClassMethods
    def [](parameters)
      Proxy.new(self, parameters)
    end

    def included(base)
      base.extend(ClassMethods)
      super(base)
    end
  end

  class Proxy < Module
    attr :mixin
    attr :parameters
    attr :block

    #
    def initialize(mixin, parameters, &block)
      @mixin      = mixin
      @parameters = parameters || {}
      @block      = block
    end

    #
    def append_features(base)
      mixin = @mixin

      base.mixin_parameters[mixin] ||= {}
      base.mixin_parameters[mixin].update(@parameters)

      mixin.module_eval{ append_features(base) }

      base.module_eval{ include InstanceParameterize }
      #base.extend ClassParameterize

      mixin.module_eval{ included(base) }

      base.module_eval(&@block) if @block
    end

    #
    def extend_object(base)
      mixin = @mixin

      metabase = (class << base; self; end)

      metabase.mixin_parameters[mixin] ||= {}
      metabase.mixin_parameters[mixin].update(@parameters)

      mixin.module_eval{ extend_object(base) }

      base.extend ClassParameterize

      metabase.module_eval(&@block) if @block
    end

    #
    module InstanceParameterize
      #
      def mixin_param(m, n)
        h = {}; r = nil
        self.class.ancestors.each do |a|
          break if Paramix == a
          break if m == a
          q = a.mixin_parameters
          #if q = Paramix.mixin_params[a]
            if q[m] && q[m].key?(n)
              r = q[m][n]
            else
              q.each do |k,v|
                h.update(v)
              end
            end
          #end
        end
        r ? r : h[n]
      end
    end

    #
    module ClassParameterize
      #
      def mixin_param(m, n)
        h = {}; r = nil
        ancestors.each do |a|
          break if Paramix==a
          if q = a.meta_class.mixin_parameters #[class << a; self ; end]
          #if q = Paramix.mixin_params[class << a; self ; end]
            if q[m] && q[m].key?(n)
              r = q[m][n]
            else
              q.each do |k,v|
                h.update(v)
              end
            end
          end
        end
        r ? r : h[n]
      end
    end

  end

end

#
class Module

  def mixin_parameters
    @mixin_params ||= {}
  end

  alias_method :mixin_params, :mixin_parameters

end

module Kernel
  def meta_class
    (class << self; self; end)
  end
end
