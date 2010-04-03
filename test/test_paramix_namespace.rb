require 'paramix'
require 'test/unit'

class TC_Paramix_Basic < Test::Unit::TestCase

  module Q1
    module M
      include Paramix

      def f
        mixin_params[M][:p]
      end
    end
  end

  module Q2
    class C
      extend Q1::M[:p => "mosh"]
    end

    class D
      extend Q1::M[:p => "many"]
    end
  end

  def test_03_001
    assert_equal( "mosh", Q2::C.f )
  end

  def test_03_002
    assert_equal( "many", Q2::D.f )
  end

  def test_03_003
    assert_equal( {Q1::M=>{:p => "mosh"}}, (class << Q2::C; self; end).mixin_parameters )
    assert_equal( {Q1::M=>{:p => "many"}}, (class << Q2::D; self; end).mixin_parameters )
  end

end

