### Next Release
* Your contribution here.
* Refactor request processing to use `Miron::RequestFetcher`, and not
  `Miron::Request` directly - [@maclover7](https://github.com/maclover7).

### 0.0.3 - (10/14/2015)
* Pass paramters to middleware and app - [@maclover7](https://github.com/maclover7).
* Redo Miron::Auth::Basic to accept params via Mironfile. Closes #15. - [@maclover7](https://github.com/maclover7).
* Put all Miron middleware under the `Miron::Middleware` module. - [@maclover7](https://github.com/maclover7).
* Add `Miron::Middleware::Static` to serve static files. Closes #16. - [@maclover7](https://github.com/maclover7).
* Allow specification of a custom file (not just Mironfile.rb) in `miron
  server` command - [@maclover7](https://github.com/maclover7).

### 0.0.2 - (10/8/2015)
* Add `Miron::Auth::Basic` middleware to allow HTTP Basic authentication - [@maclover7](https://github.com/maclover7).
* Add `use` to Mironfile.rb to allow adding of middleware - [@maclover7](https://github.com/maclover7).
* Add Puma HTTP handler - [@maclover7](https://github.com/maclover7).
* Add Unicorn HTTP handler - [@maclover7](https://github.com/maclover7).
* Add Thin HTTP handler - [@maclover7](https://github.com/maclover7).

### 0.0.1 (9/21/2015)
* Initial public release - [@maclover7](https://github.com/maclover7).
* Add WEBrick HTTP Handler - [@maclover7](https://github.com/maclover7).
