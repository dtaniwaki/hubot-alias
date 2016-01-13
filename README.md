# Hubot Alias

[![NPM Version][npm-image]][npm-link]
[![Dependency Status][deps-image]][deps-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]

Action alias for hubot.

## Installation

* install this npm package to your hubot repo
    * `npm i --save hubot-alias`
* add `"hubot-alias"` to your `external-scripts.json`

## Usage

### Add Alias

* `hubot alias xxx=yyy`

Make alias xxx for yyy

### Remove Alias

* `hubot alias xxx=`

Remove alias xxx for yyy

### Alias List

* `hubot alias`

Show alias list

### Clear Alias List

* `hubot alias clear`

Clear alias list

## Alias Matching Rule

Say, we have the following aliases.

```
foo=goo
ring=goo --name=$1 --message=$2
wow=super useful
```

`hubot foo` => `hubot goo`

`hubot foos` => `hubot foos`

`hubot foo 1 2 3` => `hubot goo 1 2 3`

`hubot ring john hello` => `hubot goo --name=john --message=hello`

`hubot ring john hello test` => `hubot goo --name=john --message=hello test`

`hubot bar foo` => `hubot bar foo`

`hubot wow` => `hubot super useful`

`hubot wow hubot-alias` => `hubot super useful hubot-alias`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.



[npm-image]:   https://badge.fury.io/js/hubot-alias.svg
[npm-link]:    http://badge.fury.io/js/hubot-alias
[build-image]: https://secure.travis-ci.org/dtaniwaki/hubot-alias.png
[build-link]:  http://travis-ci.org/dtaniwaki/hubot-alias
[deps-image]:  https://david-dm.org/dtaniwaki/hubot-alias.svg
[deps-link]:   https://david-dm.org/dtaniwaki/hubot-alias
[cov-image]:   https://coveralls.io/repos/dtaniwaki/hubot-alias/badge.png
[cov-link]:    https://coveralls.io/r/dtaniwaki/hubot-alias
