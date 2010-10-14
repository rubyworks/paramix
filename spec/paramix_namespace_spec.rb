require 'paramix'

describe "namespace depth does not adversly effect parametric mixins" do

  module N
    module M
      include Paramix::Parametric
      parameterized do |params|
        public :f do
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


  it "should" do
     Q::I.new.f == "mosh"
  end

  it "should" do
    Q::E.f.should == "many"
  end

end

