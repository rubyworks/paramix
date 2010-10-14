require 'paramix'

describe "nested modules where inner most module is parametric" do

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include m[:p=>"NMp"]
  end

  i = Class.new do
    include n
  end

  e = Class.new do
    extend  n
  end


  it "should" do
    i.new.f.should == "NMp"
  end

  it "should" do
    e.f.should == "NMp"
  end

end

describe "nested parametric mixins with parameters" do

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"NMp"]

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[:p => "INp"]
  end

  e = Class.new do
    extend n[:p => "ENp"]
  end


  it "should" do
    i.new.f.should == "NMp"
  end

  it "should" do
    i.new.g.should == "INp"
  end

  it "should" do
    e.f.should == "NMp"
  end

  it "should" do
    e.g.should == "ENp"
  end

end

describe "nested parametric mixins without parameters" do

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include m

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[:p => "INp"]
  end

  e = Class.new do
    extend n[:p => "ENp"]
  end


  it "should" do
    i.new.f.should == "INp"
  end

  it "should" do
    i.new.g.should == "INp"
  end

  it "should" do
    e.f.should == "ENp"
  end

  it "should" do
    e.g.should == "ENp"
  end

end

describe "nested parametric mixins where the outer is not parameterized" do

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"NMp"]
  end

  i = Class.new do ; include n[] ; end
  e = Class.new do ; extend  n[] ; end

  ix = Class.new do ; include n[:p=>"IxNp"] ; end
  ex = Class.new do ; extend  n[:p=>"ExNp"] ; end


  it "should" do
    i.new.f.should == "NMp"
  end

  it "should" do
    e.f.should == "NMp"
  end

  it "should" do
    i.new.f.should == "NMp"
  end

  it "should" do
    e.f.should == "NMp"
  end

end


describe "nested parametric mixins both parameterized" do

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"mood"]

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[]
  end

  e = Class.new do
    extend n[]
  end


  it "should" do
    i.new.f.should == "mood"
  end

  it "should" do
    i.new.g.should == nil  # TODO: or error ?
  end

  it "should" do
    e.f.should == "mood"
  end

  it "should" do
    e.g.should == nil
  end

end

