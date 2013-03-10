# Paramix

[![Gem Version](https://badge.fury.io/rb/paramix.png)](http://badge.fury.io/rb/paramix)
[![Build Status](https://secure.travis-ci.org/rubyworks/paramix.png)](http://travis-ci.org/rubyworks/paramix) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)

[Website](http://rubyworks.github.com/paramix) &middot;
[YARD API](http://rubydoc.info/gems/paramix) &middot;
[Report Issue](http://github.com/rubyworks/paramix/issues) &middot;
[Source Code](http://github.com/rubyworks/paramix)


## About

Parametric Mixins provides an easy means to "functionalize" modules.
The module can then be differentiated upon usage according to the
parameters provided.


## Usage

Here is the most basic example. It simply makes the parametric module's
parameters available at the instance level.

    module M
      include Paramix::Parametric

      paramaterized do |params|
        define_method :params do
          params
        end
      end

      def hello
        "Hello, %s!" % [params[:name]]
      end
    end

    class X
      include M[:name=>'Charlie']
    end

    X.new.hello  #=> 'Hello, Charlie!'

Because the +parameterized+ method defines a block that is evaluated in the
context of a new Parametric::Mixin, it is possible to work with the parameters
in more versitle ways. Here is a simple example that uses a parameter to
define a method and another parameter to define it's return value.

    module M
      include Paramix::Parametric

      paramaterized do |params|
        define_method params[:name] do
          params[:value]
        end
      end
    end

    class X
      include M[:name=>'foo', :value='bar']
    end

    X.new.foo  #=> 'bar'


## Copyrights

Copyright (c) 2006 Rubyworks

This program is ditributed unser the terms of the BSD-2-Clause license.

See COPYING.rdoc file for details.

