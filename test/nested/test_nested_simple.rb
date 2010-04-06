require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Simple < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix::Parametric

    parameterized do |params|
      define :f do
        params[:p]
      end
    end
  end

  module N
    include M[:p=>"NMp"]
  end

  class I
    include N
  end

  class E
    extend  N
  end

  # -- tests --------------------------------

  def test_include_if
    assert_equal( "NMp", I.new.f )
  end

  def test_extend_ef
    assert_equal( "NMp", E.f )
  end

end

