require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Bottom < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  module N
    include M

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  class I
    include N[:p => "INp"]
  end

  class E
    extend N[:p => "ENp"]
  end

  # -- tests --------------------------------

  def test_include_f
    assert_equal( "INp", I.new.f )
  end

  def test_include_g
    assert_equal( "INp", I.new.g )
  end

  def test_extend_f
    assert_equal( "ENp", E.f )
  end

  def test_extend_g
    assert_equal( "ENp", E.g )
  end

end

