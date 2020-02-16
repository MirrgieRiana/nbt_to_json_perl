# NBT to JSON Perl

A tool to convert NBT and JSON written in Perl

# Installation

## 1. Prepare the environment

This library depends on the following programs.

- perl
- gzip
- perl module: `JSON`
- perl module: `Compress::Zlib`

----

Example of the command to install all the necessary perl modules using apt.

- $ `sudo apt install libjson-perl`
- $ `sudo apt install libcompress-raw-zlib-perl`

## 2. Clone this repository

Execute the following command in any directory.

- $ `git clone https://github.com/MirrgieRiana/nbt_to_json_perl.git`

# Tools

## `inflate_zlib`

Decompress the zlib data.

## `inflate_gzip`

Decompress the gzip data.

## `nbt2json`

Read uncompressed NBT binary from stdin and print JSON string to stdout.

### Example

- $ `cat level.dat | ./inflate_gzip | ./nbt2json`

## `region_format`

Returns the existence and the compression format of a chunk as return code.

### Return code

- 0: No chunk data
- 1: Compression format = zlib
- 2: Compression format = gzip

### Usage

- $ `./region_format REGION_FILENAME X Z`

### Example

- $ `./region_format world/region/r.4.48.mca 1 12; echo $?`
  - `0`

## `region`

Prints compressed chunk data to stdout.
It is necessary to check the compression format with region_format beforehand.

### Usage

- $ `./region REGION_FILENAME X Z`

### Example

- $ `./region world/region/r.4.48.mca 1 12 | ./inflate_zlib | ./nbt2json`
