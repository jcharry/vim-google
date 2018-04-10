# vim-google
Quickly perform a google search through vim:

## Usage
Default mappings provided are:

1. `go` in normal mode, followed by a text object
    - `goiw` will google for the `inner word`
    - `goib` will google for whatever is inside parens
    - etc
2. `go` in visual mode will perform a search for the highlighted phrase
3. a command mapping:
```
:Google do a search for this string
```
