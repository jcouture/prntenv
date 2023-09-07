# prntenv

Utility to print out the names and values of the variables in the environment.

**⚠️ Warning**

Environment variables are case sensitive.

## Installation

### macOS and Linux

`prntenv` is available via [Homebrew](#homebrew) and as a downloadable binary from the [releases page](https://github.com/jcouture/prntenv/releases).

#### Homebrew

| Install                                 | Upgrade                |
| --------------------------------------- | ---------------------- |
| `brew install jcouture/prntenv/prntenv` | `brew upgrade prntenv` |

### Windows

`prntenv` is available as a downloadable binary from the [releases page](https://github.com/jcouture/prntenv/releases).

### Build from source

Alternatively, you can build it from source.

1. Verify you have Go 1.20+ installed

```sh
~> go version
```

If `Go` is not installed, follow the instructions on the [Go website](https://golang.org/doc/install)

2. Clone this repository

```sh
~> git clone https://github.com/jcouture/prntenv.git
~> cd prntenv
```

3. Build
   `prntenv` uses [just](https://just.systems) as command runner for a few handy commands shortcut.

```sh
~> just build
```

While the development version is a good way to take a peek at `prntenv`’s latest features before they get released, be aware that it may contains bugs. Officially released versions will generally be more stable.

# Usage

Print the entire environment out:

```sh
~> prntenv
```

Without colorized output:

```sh
~> prntenv -no-color
```

Alphabetically sorted, by variable name:

```sh
~> prntenv -sort
```

Search for variables (default is case sensitive):

```sh
~> prntenv HOM
```

Search for variables (ignoring case):

```sh
~> prntenv -ignore-case Pat
```

# License

`prntenv` is released under the MIT license. See [LICENSE](./LICENSE) for details.
