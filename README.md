Linear TSV is a line-oriented, portable tabular data format. Tabular data --
rows of tuples, each of the same length -- is commonly stored as CSV and is
the lingua franca of spreadsheets, databases and analysis tools.

In advocating a shift to a line-oriented, tab-separated serialization format,
we are endorsing an existing format: the default serialization format of both
Postgres and MySQL. We propose to standardize a subset of the format common to
both database systems.

A truly line-oriented format for tabular data, where newline, carriage return
and the separator are always represented by escape sequences, offers many
practical advantages, among them:

* The parsers are simple and efficient.

* First pass filtering and sorting for line-oriented formats is easy to
  implement efficiently in high-level languages, like Python and Java.

* Analysis and transformation of line-oriented data with command line tools is
  simple, dependable and often surprisingly efficient.

* By requiring escape sequences when newlines and tabs are in field text, the
  format allows parsers to naively and efficiently split data on raw byte
  values: `0x09` for fields and `0x0A` for records.

CSV is almost right and it's worth talking about the disadvantages of CSV that
motivate the author to promote another tabular data format:

* In some locales, `,` is the decimal separator; whereas the ASCII tab never
  collides with the decimal separator. More generally, the tab is not a
  centuries old glyph that one encounters in natural language.

* CSV is not truly line-oriented -- newlines are quoted, not escaped. A single
  record can span multiple physical lines. In consequence, line-oriented
  processing almost works until it doesn't, and then simple tricks -- sorting
  on the first column to optimize insertion order or batching records in to
  groups of a few thousand to get better insert performance -- require
  relatively complicated code to get right.

* CSV's quoting style requires one to mingle field data parsing and record
  splitting. Taking every third record still requires one to parse the prior
  two, since a newline inside quotes is not a record separator.

* CSV is ambiguous in many small areas -- the presence or absence of a header
  line, the choice of quote character (single or double?) and even the choice
  of separator character are all axes of variability.


# Sample Parsers and Serializers

## Bash

    TODO

## Python

    TODO

## Scala

    TODO

## Haskell

    TODO

## Julia

    TODO

# A Grammar

This grammar is presented in the W3C EBNF format.

    TSV        ::= Row (NL Row)*

    Row        ::= Field (Tab Field)*
    Field      ::= ( Escape | NoOpEscape | Char - (NL|Tab|'\') )*

    Char       ::= [http://www.w3.org/TR/xml#NT-Char]
    NL         ::= #x0A
    Tab        ::= #x09

    Escape     ::= '\n' | '\r' | '\t'
    NoOpEscape ::= '\' (Char - ('n'|'r'|'t'))

A nice diagram of the grammar can be generated online with the
[Bottlecaps Railroad Diagram generator][http://bottlecaps.de/rr/ui].


# Ambiguities & Empty Lines


