require 'paramix'
require 'test/unit'

class TC_Paramix_Namespace < Test::Unit::TestCase

  # -- fixture ------------------------------

  module N1
    module M
      include Paramix

      def f
        mixin_param(M,:p)
      end
    end
  end

  module N2
    class I
      include N1::M[:p => "mosh"]
    end

    class E
      extend N1::M[:p => "many"]
    end
  end

  # -- tests --------------------------------

  def test_class_1
    assert_equal( "mosh", N2::I.new.f )
  end

  def test_class_2
    assert_equal( "many", N2::E.f )
  end

end

