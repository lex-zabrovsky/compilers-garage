# The Compiler's Garage

A personal blog by Lex Zabrovsky exploring quantum physics, and building reliable systems. 

https://lex-zabrovsky.github.io/compilers-garage/

## Overview

I'm a DevOps engineer and former quantum physics researcher. This blog shares my journey through technology's frontiers.

### Latest Posts

- [Deployment of HAProxy on Bare-Metal Kubernetes](https://lex-zabrovsky.github.io/compilers-garage/2025-07-21-setup-haproxy-ingress.html)
- [OpenSearch Node Deployment Manual](https://lex-zabrovsky.github.io/compilers-garage/2025-07-01-opensearch-deployment.html)
- And more...

## Install

The blog's styling is available as a reusable CSS library:

```
npm install @owickstrom/the-monospace-web
```

## Usage

Link the CSS in your HTML for monospace styling:

```html
<link rel="stylesheet" href="node_modules/@owickstrom/the-monospace-web/dist/reset.css">
<link rel="stylesheet" href="node_modules/@owickstrom/the-monospace-web/dist/index.css">
```

## Build

To generate the blog's HTML from Markdown:

```
nix develop -extra-experimental-features nix-command --extra-experimental-features flakes
make
```

## Run

```
live-server --host 127.0.0.1 --port 8081
```

## License

[MIT](LICENSE.md)
