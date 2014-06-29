# Hubot Alias

[![NPM version](https://badge.fury.io/js/hubot-alias.svg)](http://badge.fury.io/js/hubot-alias) [![Build Status](https://travis-ci.org/dtaniwaki/hubot-alias.svg)](https://travis-ci.org/dtaniwaki/hubot-alias)

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
a=a b c d
ab=a b c d e
b=b c d
```

`hubot a` => `hubot a b c d`

`hubot ab` => `hubot a b c d e`

`hubot b` => `hubot b c d`

`hubot b e` => `hubot b c d e`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.
