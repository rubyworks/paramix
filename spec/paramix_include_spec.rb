require 'paramix'

describe "include with parametric mixins" do

  module M
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end

  class I1
    include M[:p => "mosh"]
  end

  class I2
    include M[:p => "many"]
  end

  class E1
    extend M[:p => "mosh"]
  end

  class E2
    extend M[:p => "many"]
  end

  it "should vary the return value of the instance methods" do
    I1.new.f.should == "mosh"
    I2.new.f.should == "many"
  end

  it "should vary the return value of the class methods " do
    E1.f.should == "mosh"
    E2.f.should == "many"
  end

end

