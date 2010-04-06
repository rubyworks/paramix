require 'paramix'
require 'test/unit'

include Paramix

class TC_Paramix_Callback < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Parametric

    parameterized do |params|

      define :f do
        params[:p]
      end

      attr_accessor params[:p]
    end

    #
    #def self.included(base)
    #  base.class_eval do
    #    attr_accessor mixin_parameters[M][:p]
    #  end
    #  super(base)
    #end
  end

  class C1
    include M[:p => "c1"]
  end

  class C2
    include M[:p => "c2"]
  end

  # -- tests --------------------------------

  def test_class_1
    c = C1.new
    #assert_equal( "c1", c.mixin_params[:p] )
    assert_equal( "c1", c.f )
  end

  def test_class_2
    c = C2.new
    #assert_equal( "c2", c.mixin_params[:p] )
    assert_equal( "c2", c.f )
  end

  def test_callback_class_1
    c = C1.new
    c.c1 = :yes1
    assert_equal(:yes1, c.c1)
  end

  def test_callback_class_2
    c = C2.new
    c.c2 = :yes2
    assert_equal(:yes2, c.c2)
  end

end

