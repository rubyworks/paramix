require 'paramix'

describe "dynamic methods using paramtric mixins" do

  module M
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

      attr_accessor params[:p]
    end
  end

  class C1
    include M[:p => "c1"]
  end

  class C2
    include M[:p => "c2"]
  end

  it "should" do
    c = C1.new
    c.f.should == "c1"
  end

  it "should" do
    c = C2.new
    c.f.should == "c2"
  end

  it "should" do
    c = C1.new
    c.c1 = :yes1
    c.c1.should == :yes1
  end

  it "should" do
    c = C2.new
    c.c2 = :yes2
    c.c2.should == :yes2
  end

end
