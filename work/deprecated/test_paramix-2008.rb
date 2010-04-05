require 'paramix'
require 'test/unit'

class TC_Paramix_Callback < Test::Unit::TestCase

  module M
    include Paramix

    def f
      mixin_params[M][:p]
    end

    def self.included(base)
      params = base.mixin_params[self]
      base.class_eval do
        define_method :check do
          params
        end
      end
    end
  end

  class C
    include M[:p => "check"]
  end

  class D
    include M[:p => "steak"]
  end

  def test_01_001
    c = C.new
    assert_equal( "check", c.mixin_params[M][:p] )
    assert_equal( "check", c.f )
  end

  def test_01_002
    d = D.new
    assert_equal( "steak", d.mixin_params[M][:p] )
    assert_equal( "steak", d.f )
  end

  def test_01_003
    assert_equal( {M=>{:p => "check"}}, C.mixin_parameters )
    assert_equal( {M=>{:p => "steak"}}, D.mixin_parameters )
  end

  def test_01_004
    c = C.new
    assert_equal( {:p => "check"}, c.check )
    d = D.new
    assert_equal( {:p => "steak"}, d.check )
  end

end

