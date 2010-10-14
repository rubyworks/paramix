#--
# Dynamic Mixins
#
# Copyright (c) 2005 George Moschovitis and Thomas Sawyer
#
# Ruby License
#
# This module is free software. You may use, modify, and/or redistribute this
# software under the same terms as Ruby.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.
#
# ==========================================================================
# Revision History ::
# --------------------------------------------------------------------------
#  2005.09.19  trans     * Cleaned up and renamed.
#  2005.04.28  trans     * Added to Calibre.
# ==========================================================================
#
# TODO include parameters may need to be kept separate from include
# parameters. Currently they are clobbering one another --which must be
# fixed.
#++

#:title: Dynamic Mixins
#
# Provides a construction mechinism for creating dynamically generated
# module features as well as instance accessible module parameters which
# can be set at the time of inclusion or extension.
#
# == Example
#
# To create a dynamic feature use the #dyanmic_feature method defining a block
# which returns a block or string to by evaluated into the modules body upon
# inclusion or extension.
#
#   module Mixin
#
#     dynamic_feature do |options|
#
#         define_method :hello do
#           puts "Hello from #{options[:name]}"
#         end
#
#     end
#
#   end
#
#   class MyClass
#     include Mixin, :name => 'Ruby'
#   end
#
#   m = MyClass.new
#   m.hello -> 'Hello from Ruby'
#
# Rather then an open code block the block can instead
# return a string to be evaluated.
#
#   module Mixin
#
#     dynamic_feature do |options| %/
#
#         def hello
#           puts "Hello from #{options[:name]}"
#         end
#
#     /end
#
#   end
#
#   class MyClass
#     include Mixin, :name => 'Ruby'
#   end
#
#   m = MyClass.new
#   m.hello -> 'Hello from Ruby'
#
# == Author(s)
#
# * George Moschovitis
# * Thomas Sawyer
#

class Module

  def dynamic_feature( &blk )
    (@module_features ||= []) << blk
  end

  # Store for a module's dynamic features.
  def module_features ; @module_features ||= [] ; end

  # Store for module parameters. This is local per module
  # and indexed on module/class included-into.
  def module_parameters ; @module_parameters ||= {} ; end

  alias_method :include_without_dynamic_features, :include

  def include(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    for mod in args
      module_parameters[mod] = options
      mod.append_dynamic_features( self, options )
    end
    include_without_dynamic_features(*args)
  end

  def append_dynamic_features( base, options )
    # module_options
    mod = self
    define_method( :module_options ) do |key|
      base.module_parameter_get( mod, key )
    end
    # dynamic features
    module_features.each do |mf|
      eingenclass = (class << base; self; end)
      eingenclass.class_eval {
        define_method( :_explode, &mf )
      }
      r = base._explode(options)
      eingenclass.class_eval {
        remove_method( :_explode )
      }
      # if string block
      base.class_eval r if r.is_a?(String)
    end
  end

  alias_method :extend_without_dynamic_features, :extend

  def extend(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    for mod in args
      module_parameters[mod] = options
      mod.extend_dynamic_object( self, options )
    end
    extend_without_dynamic_features(*args)
  end

  # Note: Is this the best name for this callback?
  def extend_dynamic_object( base, options )
    # module_options
    mod = self
    eingenclass = (class << base; self; end)
    eingenclass.__send__(:define_method, :module_options ) do |key|
      base.module_parameter_get( mod, key )
    end
    module_features.each do |mf|
      eingenclass.class_eval {
        (class << self; self; end).__send__(:define_method, :_explode, &mf )
      }
      r = eingenclass._explode(options)
      eingenclass.class_eval {
        (class << self; self; end).__send__(:remove_method, :_explode )
      }
      # if it is a string block
      eingenclass.class_eval r if r.is_a?(String)
    end
  end

#   # Defines a instance attribute linked to a specific module parameter.
#   def attr_parameter( *opts )
#     hopts = opts.pop if Hash === opts.last
#     opts.each { |k| hopts[k] = nil }
#     mod = self
#     hopts.each { |key, default|
#       self.instance_eval {
#         define_method( key ) do
#           self.class.module_parameter_get( mod, key ) || default
#         end
#       }
#     }
#   end

  # Convenice method for looking up a parameter
  def module_parameter_get( mod, key )
    if self.module_parameters.key?(mod)
      self.module_parameters[mod][key]
    else
      anc = self.ancestors[1]
      if anc
        anc.module_parameter_get( mod, key )
      end
    end
  end
  #protected :module_parameter_get

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

#=begin testing

  require 'test/unit'

  class TC01 < Test::Unit::TestCase

    module M
      dynamic_feature do |opt|
        p self
        define_method :f do
          opt[:p]
        end
      end
    end
    class C
      include M, :p => "check"
    end

    def test_01_001
      assert_equal( "check", C.new.f )
    end
  end

  class TC02 < Test::Unit::TestCase
    module M
      def f ; module_options(:s) ; end
    end
    class C
      include M, :s => "check 123"
    end

    def test_02_001
      assert_equal( "check 123", C.new.f )
    end
  end

  class TC03 < Test::Unit::TestCase
    module M
      def f ; module_options(:q) ; end
    end
    class C
      extend M, :q => "check 123"
    end

    def test_03_001
      assert_equal( "check 123", C.f )
    end
  end

#=end
