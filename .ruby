--- 
name: paramix
title: Paramix
contact: trans <transfire@gmail.com>
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
resources: 
  repo: git://github.com/rubyworks/paramix.git
  code: http://github.com/rubyworks/paramix
  home: http://rubyworks.github.com/paramix
pom_verison: 1.0.0
manifest: 
- .ruby
- lib/paramix/version.rb
- lib/paramix.rb
- qed/01_basic.rdoc
- qed/02_general.rdoc
- qed/03_battery.rdoc
- spec/nested_spec.rb
- spec/paramix_dynamic_spec.rb
- spec/paramix_extend_spec.rb
- spec/paramix_include_spec.rb
- spec/paramix_namespace_spec.rb
- HISTORY.rdoc
- LICENSE
- README.rdoc
- VERSION
version: 2.0.0
copyright: Copyright (c) 2006 Thomas Sawyer
licenses: 
- Apache 2.0
description: Parametric Mixins provides parameters for mixin modules.
organization: RubyWorks
summary: Parametric Mixins
authors: 
- Thomas Sawyer
created: 2006-01-01
