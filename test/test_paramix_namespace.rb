require 'paramix'
require 'test/unit'

class TC_Paramix_Namespace < Test::Unit::TestCase

  # -- fixture ------------------------------

  module N
    module M
      include Paramix::Parametric
      parameterized do |params|
        define :f do
          params[:p]
        end
      end
    end
  end

  module Q
    class I
      include N::M[:p => "mosh"]
    end
    class E
      extend N::M[:p => "many"]
    end
  end

  # -- tests --------------------------------

  def test_class_1
    assert_equal( "mosh", Q::I.new.f )
  end

  def test_class_2
    assert_equal( "many", Q::E.f )
  end

end

