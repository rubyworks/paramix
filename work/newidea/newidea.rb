require 'ae'
require 'ae/should'

# After all what is a "mixin"?

class ParametricMixin < Module

  def self.[](*args)
    new(*args)
  end

  def initialize(*args, &block)
    initialize_parameters(*args, &block)
  end

end


  # example

  class M < ParametricMixin

    def initialize_parameters(params)
      define_method :f do
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

  #it "should" do
    c = C1.new
    c.f.should == "c1"
  #end

  #it "should" do
    c = C2.new
    c.f.should == "c2"
  #end

  #it "should" do
    c = C1.new
    c.c1 = :yes1
    c.c1.should == :yes1
  #end

  #it "should" do
    c = C2.new
    c.c2 = :yes2
    c.c2.should == :yes2
  #end

