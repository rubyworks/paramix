require 'paramix'
require 'test/unit'

class TC_Paramix_Basic < Test::Unit::TestCase

  module M
    include Paramix

    def f
      mixin_params[M][:p]
    end
  end

  class C
    extend M[:p => "mosh"]
  end

  class D
    extend M[:p => "many"]
  end

  def test_03_001
    assert_equal( "mosh", C.f )
  end

  def test_03_002
    assert_equal( "many", D.f )
  end

  def test_03_003
    assert_equal( {M=>{:p => "mosh"}}, (class << C; self; end).mixin_parameters )
    assert_equal( {M=>{:p => "many"}}, (class << D; self; end).mixin_parameters )
  end

end

