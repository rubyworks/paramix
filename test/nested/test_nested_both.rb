require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Both < Test::Unit::TestCase

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
    include Paramix::Parametric
    include M[:p=>"NMp"]

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
    assert_equal( "NMp", I.new.f )
  end

  def test_include_g
    assert_equal( "INp", I.new.g )
  end

  def test_extend_f
    assert_equal( "NMp", E.f )
  end

  def test_extend_g
    assert_equal( "ENp", E.g )
  end

end

