---
title: "Working with Lists and Tables"
subtitle: "For reference"
author: "Oskar Wickström"
date: 2024-01-15
---

# Working with Lists and Tables

## Lists

This is a plain old bulleted list:

* Banana
* Paper boat
* Cucumber
* Rocket

Ordered lists look pretty much as you'd expect:

1. Goals
1. Motivations
   1. Intrinsic
   1. Extrinsic
1. Second-order effects

It's nice to visualize trees. This is a regular unordered list with a `tree` class:

<ul class="tree"><li><p style="margin: 0;"><strong>/dev/nvme0n1p2</strong></p>

* usr
    * local
    * share
    * libexec
    * include
    * sbin
    * src
    * lib64
    * lib
    * bin
    * games
        * solitaire
        * snake
        * tic-tac-toe
    * media
* media
* run
* tmp

</li></ul>

## Tables

We can use regular tables that automatically adjust to the monospace grid. They're responsive.

<table>
<thead>
  <tr>
    <th class="width-min">Name</th>
    <th class="width-auto">Dimensions</th>
    <th class="width-min">Position</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Boboli Obelisk</td>
    <td>1.41m &times; 1.41m &times; 4.87m</td>
    <td>43°45'50.78"N 11°15'3.34"E</td>
  </tr>
  <tr>
    <td>Pyramid of Khafre</td>
    <td>215.25m &times; 215.25m &times; 136.4m</td>
    <td>29°58'34"N 31°07'51"E</td>
  </tr>
</tbody>
</table>

Note that only one column is allowed to grow.

[← Back to home](../index.html)