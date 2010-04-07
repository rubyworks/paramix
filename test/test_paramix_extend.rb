require 'paramix'
require 'test/unit'

class TC_Paramix_Extend < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end

  class C1
    extend M[:p => "mosh"]
  end

  class C2
    extend M[:p => "many"]
  end

  # -- tests --------------------------------

  def test_class_1
    assert_equal( "mosh", C1.f )
  end

  def test_class_2
    assert_equal( "many", C2.f )
  end

end

