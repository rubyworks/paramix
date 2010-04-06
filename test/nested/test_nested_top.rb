require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Top < Test::Unit::TestCase

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
    include Paramix::Parametric
    include M[:p=>"mood"]

    parameterized do |params|
      define :g do
        params[:p]
      end
    end
  end

  class I
    include N[]
  end

  class E
    extend N[]
  end

  # -- tests --------------------------------

  def test_include_f
    assert_equal( "mood", I.new.f )
  end

  def test_include_g
    assert_equal( nil, I.new.g ) # TODO: or error ?
  end

  def test_extend_f
    assert_equal( "mood", E.f )
  end

  def test_extend_g
    assert_equal( nil, E.g )
  end

end

