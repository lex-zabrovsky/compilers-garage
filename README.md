# The Compiler's Garage

A personal blog by Lex Zabrovsky exploring DevOps, Kubernetes, quantum physics, and building reliable systems. Styled with a minimalist monospace theme for readability and focus.

https://lex-zabrovsky.github.io/compilers-garage/

## Overview

I'm a DevOps engineer and former quantum physics researcher passionate about creating "things that work." This blog shares my journey through technology's frontiers, from mathematical models to fault-tolerant clusters.

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
nix develop # or `direnv allow .`
make
```

## License

[MIT](LICENSE.md)
