# Name

NBT to JSON Perl - Command line tools to convert NBT and JSON written in Perl

# Synopsis

When `nbt2json` caught NBT binary data from stdin, outputs the JSON string expression.

- $ `cat sample/1.nbt | ./nbt2json`

```
{"key":"","type":10,"value":[{"key":"list","type":9,"value":{"type":1,"values":[1,2]}},{"key":"double","type":6,"value":"0x3fd0000000000000=0.25"},{"key":"int","type":3,"value":-1}]}
```

----

Add `-cp` to `nbt2json` to print useful and formatted JSON string.

- $ `cat sample/1.nbt | ./nbt2json -cp`

```
{
   "C": {
      "Alist": {
         "type": "byte",
         "values": [
            1,
            2
         ]
      },
      "Ddouble": "0x3fd0000000000000=0.25",
      "Iint": -1
   }
}
```

---

`json2nbt -c` is the inverse function of `nbt2json -cp`.
So you can convert NBT binary to JSON string and modify the JSON string and convert it to NBT binary again.

- $ `cat sample/1.nbt | ./nbt2json -cp | ./json2nbt -c | ./nbt2json -cp`

```
{
   "C": {
      "Alist": {
         "type": "byte",
         "values": [
            1,
            2
         ]
      },
      "Ddouble": "0x3fd0000000000000=0.25",
      "Iint": -1
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

Read uncompressed NBT binary data from stdin and print JSON string to stdout.

### Usage

- $ `./nbt2json --help`

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
                --hex-float
                --bin-integer
                --bin-float
        -e,     --eval PROGRAM
        -r,     --readable
        -H,     --hex
        -B,     --bin
        -c,     --readable-compound
```

#### `--help`

Print help message.

- $ `./nbt2json --help`

#### `-p`, `--pretty`

Format JSON string.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json`

```
{"key":"","type":10,"value":[{"key":"list","type":9,"value":{"type":1,"values":[1,2]}},{"key":"double","type":6,"value":"0x3fd0000000000000=0.25"},{"key":"int","type":3,"value":-1}]}
```

↓

- $ `cat sample/1.nbt | ./nbt2json -p`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--root-name`

Force root tag name to be `root`.

**Note: This option makes the reverse conversion of the output data impossible.**

----

- $ `cat sample/1.nbt | ./nbt2json -p --root-name`

```
{
   "key": "root",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--type-name`

Type is represented by name, not type ID.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -p --type-name`

```
{
   "key": "",
   "type": "compound",
   "value": [
      {
         "key": "list",
         "type": "list",
         "value": {
            "type": "byte",
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": "double",
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": "int",
         "value": -1
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

This option can be used without making the reverse conversion of the output data impossible.

**Note: Output data printed with this option must be reverse-converted with the same option.**

----

- $ `cat sample/1.nbt | ./nbt2json -p --type-key`

```
{
   "key": "C",
   "type": 10,
   "value": [
      {
         "key": "Alist",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "Ddouble",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "Iint",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--flat-compound`

The content of a compound tag is a JSON object instead of a list of tag structures.

**Note: Without `--type-key` option, this option makes the reverse conversion of the output data impossible.**

**Note: Because the order of the tags is not preserved, the reverse conversion generally does not produce the same data.**

----

- $ `cat sample/1.nbt | ./nbt2json -p --flat-compound`

```
{
   "key": "",
   "type": 10,
   "value": {
      "double": "0x3fd0000000000000=0.25",
      "int": -1,
      "list": {
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

**Note: Without `--type-key` option, this option makes the reverse conversion of the output data impossible.**

**Note: Because the order of the tags is not preserved, the reverse conversion generally does not produce the same data.**

----

- $ `cat sample/1.nbt | ./nbt2json -p --flat-root`

```
{
   "": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--flat-list`

The content of a list tag is a JSON array instead of a structure containing type and values.

**Note: This option makes the reverse conversion of the output data impossible.**

----

- $ `cat sample/1.nbt | ./nbt2json -p --flat-list`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": [
            1,
            2
         ]
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--hex-integer`

Print a byte, short, int, and long value as a hex string.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -p --hex-integer`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               "0x01",
               "0x02"
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": "0xffffffff"
      }
   ]
}
```

#### `--hex-float`

Print a float and double value as a hex string.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -p --hex-float`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `--bin-integer`

Print a byte, short, int, and long value as a binary string.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -p --bin-integer`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               "0b00000001",
               "0b00000010"
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000=0.25"
      },
      {
         "key": "int",
         "type": 3,
         "value": "0b11111111111111111111111111111111"
      }
   ]
}
```

#### `--bin-float`

Print a float and double value as a binary string.

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -p --bin-float`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               1,
               2
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0b0011111111010000000000000000000000000000000000000000000000000000"
      },
      {
         "key": "int",
         "type": 3,
         "value": -1
      }
   ]
}
```

#### `-e PROGRAM`, `--eval PROGRAM`

Process the perl program before printing the JSON string.
You can process data using `$_`.

**Note: This option can make the reverse conversion of the output data impossible.**

----

- $ `cat sample/1.nbt | ./nbt2json -pc -e '$_ = $_->{C}->{Alist}'`

```
{
   "type": "byte",
   "values": [
      1,
      2
   ]
}
```

#### `-r`, `--readable`

Same as `--root-name --flat-compound --flat-root --flat-list`

**Note: This option makes the reverse conversion of the output data impossible.**

----

- $ `cat sample/1.nbt | ./nbt2json -pr`

```
{
   "root": {
      "double": "0x3fd0000000000000=0.25",
      "int": -1,
      "list": [
         1,
         2
      ]
   }
}
```

#### `-H`, `--hex`

Same as `--hex-integer --hex-float`

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -pH`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               "0x01",
               "0x02"
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0x3fd0000000000000"
      },
      {
         "key": "int",
         "type": 3,
         "value": "0xffffffff"
      }
   ]
}
```

#### `-B`, `--bin`

Same as `--bin-integer --bin-float`

This option can be used without making the reverse conversion of the output data impossible.

----

- $ `cat sample/1.nbt | ./nbt2json -pB`

```
{
   "key": "",
   "type": 10,
   "value": [
      {
         "key": "list",
         "type": 9,
         "value": {
            "type": 1,
            "values": [
               "0b00000001",
               "0b00000010"
            ]
         }
      },
      {
         "key": "double",
         "type": 6,
         "value": "0b0011111111010000000000000000000000000000000000000000000000000000"
      },
      {
         "key": "int",
         "type": 3,
         "value": "0b11111111111111111111111111111111"
      }
   ]
}
```

#### `-c`, `--readable-compound`

Same as `--type-name --type-key --flat-compound --flat-root`

This option makes safely the output data useful and breaks the order of compound keys.

----

- $ `cat sample/1.nbt | ./nbt2json -pc`

```
{
   "C": {
      "Alist": {
         "type": "byte",
         "values": [
            1,
            2
         ]
      },
      "Ddouble": "0x3fd0000000000000=0.25",
      "Iint": -1
   }
}
```

----

This option is useful for using with one-liner such as jq.

- $ `cat sample/1.nbt | ./nbt2json -c | jq '.C.Alist.values | add'`

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

- $ `cat level.dat | ./inflate-gzip | ./nbt2json -pc`

## `json2nbt`

Read JSON string from stdin and output uncompressed NBT binary data to stdout.

```
Usage: ./json2nbt [OPTIONS...]
OPTION:
                --help
                --type-key
        -c,     --readable-compound
```

The `--type-key` and `--readable-compound` options supports to reverse-convert the data printed with the same options of `nbt2json`.

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
