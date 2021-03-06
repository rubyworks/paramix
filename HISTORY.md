# RELEASE HISTORY

## 2.0.1 // 2011-10-22

This release simply brings the project uptodate with the latest
build tools, and switches the license to BSD-2-Clause.

Changes:

* Modernize build configuration.
* Switch to FreeBSD license.


## 2.0.0 // 2010-04-06

Thanks to a conversation with Jonathan Rochkind, Paramix has
been completely rewritten.  Whereas anonymous modules were
avoided in prior versions, it has become clear that the worries
of memory consumption that would accompany them were largely 
unfounded. This new version therefore makes use of them.
The new code is refreshingly concise, and the design fully
comforming to POLS.

Changes:

* Use anonymous modules instead of global parameter stores.
* Use paramterized block for dynamic definitions.


## 1.1.0 // 2010-04-05

The previous versions did not properly support nested parametric
includes, i.e. including one parametirc mixin into another. This
release fixed this issue. However, to do so provided difficult
and required some changes to the API. In particular, instead
of +mixin_params[M][:p]+ one must now use +mixin_param(M,:p)+.
It was not longer possible to simply return a hash, since special
lookup logic is required to handle nested mixins. It should also
be noted that +Module#mixin_parameters+, which stores the actual
parameters is no longer accessible at the instance level, just
as +mixin_param()+ is soley an instance method (at the class level
it is used to access the singleton parameters).

Changes:

* Proper support for nested parametric mixins.
* Provide #mixin_param method to lookup parameters.
* The mixin_parameters method is class-level only.


## 1.0.1 // 2010-04-03

This release simply removed dependencies on Facets.

Changes:

* Removed dependencies on Facets module/basename and module/modspace.
* Divided tests into separate files.


## 1.0.0 // 2009-06-29

This is the initial stand-alone release of Paramix spun-off
from Ruby Facets (and is actually he second major version, the
original being spun of from the Nitro/Og Glue library).

Changes:

* Happy Birthday!

