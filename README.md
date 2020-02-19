# Name

NBT to JSON Perl - A command line tool to convert NBT and JSON written in Perl

# Synopsis

- $ `cat sample.nbt | ./nbt2json -p -r`

```
{
   "root": {
      "L": [
         1,
         2
      ]
   }
}
```

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

## `inflate-zlib`

Decompress the zlib data.

## `inflate-gzip`

Decompress the gzip data.

## `nbt2json`

Read uncompressed NBT binary from stdin and print JSON string to stdout.

### Usage

```
Usage: ./nbt2json [OPTIONS...]
OPTION:
                --help
        -p,     --pretty
                --root-name
                --type-name
                --type-key
                --flat-compound
                --flat-root
                --flat-list
                --hex-integer
        -r,     --readable
```

#### `--help`

Print help message.

- $ `./nbt2json --help`

#### `-p`, `--pretty`

Format JSON string.

----

- $ `cat sample.nbt | ./nbt2json`

```
{"key":"","type":10,"value":[{"key":"L","type":9,"value":{"type":1,"values":[1,2]}}]}
```

↓

- $ `cat sample.nbt | ./nbt2json -p`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "L",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      }
   ]
}
```

#### `--root-name`

Force root tag name to be `root`.

----

- $ `cat sample.nbt | ./nbt2json -p --root-name`

```
{
   "key": "root",
   "type": 10,
   "value": [
      {
         "key": "L",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      }
   ]
}
```

#### `--type-name`

Type is represented by name, not type ID.

----

- $ `cat sample.nbt | ./nbt2json -p --type-name`

```
{
   "key": "",
   "type": "compound",
   "value": [
      {
         "key": "L",
         "type": "list",
         "value": {
            "type": "byte",
            "values": [
               1,
               2
            ]
         }
      }
   ]
}
```

#### `--type-key`

Tag key starts with a character representing the type.

|Type ID|Type|Character|
|:-:|:-:|:-:|
|0|end|N|
|1|byte|B|
|2|short|S|
|3|int|I|
|4|long|L|
|5|float|F|
|6|double|D|
|7|byte_array|b|
|8|string|T|
|9|list|A|
|10|compound|C|
|11|int_array|i|
|12|long_array|l|

----

- $ `cat sample.nbt | ./nbt2json -p --type-key`

```
{
   "key": "C",
   "type": 10,
   "value": [
      {
         "key": "AL",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      }
   ]
}
```

#### `--flat-compound`

The content of a compound tag is a JSON object instead of a list of tag structures.

----

- $ `cat sample.nbt | ./nbt2json -p --flat-compound`

```
{
   "key": "",
   "type": 10,
   "value": {
      "L": {
         "type": 1,
         "values": [
            1,
            2
         ]
      }
   }
}
```

#### `--flat-root`

The root tag is a JSON object instead of a tag structure.

----

- $ `cat sample.nbt | ./nbt2json -p --flat-root`

```
{
   "": [
      {
         "key": "L",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      }
   ]
}
```

#### `--flat-list`

The content of a list tag is a JSON array instead of a structure containing type and values.

----

- $ `cat sample.nbt | ./nbt2json -p --flat-list`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "L",
         "type": 9,
         "value": [
            1,
            2
         ]
      }
   ]
}
```

#### `--hex-integer`

Print a byte, short, int, and long value as a hex string.

----

- $ `cat sample.nbt | ./nbt2json -p --hex-integer`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "L",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               "0x01",
               "0x02"
            ]
         }
      }
   ]
}
```

#### `-r`, `--readable`

Same as `--root-name --flat-compound --flat-root --flat-list`

----

- $ `cat sample.nbt | ./nbt2json -p -r`

```
{
   "root": {
      "L": [
         1,
         2
      ]
   }
}
```

----

This option is useful with one-liner such as jq.

- $ `cat sample.nbt | ./nbt2json -r | jq '.root.L | add'`

```
3
```

### Warnings

It has to noted that JSON often has strange behaviours when processing extremely large 64 bit integers.

- $ `perl -MJSON -E 'say to_json [18446744073709551615,18446744073709551616,-9223372036854775808,-922337203685
4775809]'`
  - ```
    [18446744073709551615,1.84467440737096e+19,-9223372036854775808,-9.22337203685478e+18]
    ```
- $ `jq -n '[18446744073709551615,18446744073709551616,-9223372036854775808,-9223372036854775809]'`
  - ```
    [
      18446744073709552000,
      18446744073709552000,
      -9223372036854776000,
      -9223372036854776000
    ]
    ```

### Example

- $ `cat level.dat | ./inflate-gzip | ./nbt2json -r -p`

## `region-format`

Returns the existence and the compression format of a chunk as return code.

### Usage

- $ `./region-format REGION_FILENAME X Z`

### Return code

- 0: No chunk data
- 1: Compression format = zlib
- 2: Compression format = gzip

### Example

- $ `./region-format world/region/r.4.48.mca 1 12; echo $?`
  - `0`

## `region`

Prints compressed chunk data to stdout.
It is necessary to check the compression format with `region-format` beforehand.

### Usage

- $ `./region REGION_FILENAME X Z`

### Example

- $ `./region world/region/r.4.48.mca 1 12 | ./inflate-zlib | ./nbt2json`

# Data

To convert the Minecraft save data into JSON strings, apply the tools in order according to the type of data.

![](https://github.com/MirrgieRiana/nbt_to_json_perl/blob/master/1.png?raw=true)
