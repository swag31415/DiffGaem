## Name Generator
import strutils

proc namegen(dst: cstring; len: culong; pattern: cstring; seed: ptr culong): cint {.
    importc: "namegen", header: "name_generator/namegen.h".}

# Generates a name based of length `len` or less based on the input
# pattern. The letters s, v, V, c, B, C, i, m, M, D, and d represent
# different types of random replacements. Everything else is emitted
# literally.

#   s - generic syllable
#   v - vowel
#   V - vowel or vowel combination
#   c - consonant
#   B - consonant or consonant combination suitable for beginning a word
#   C - consonant or consonant combination suitable anywhere in a word
#   i - insult
#   m - mushy name
#   M - mushy name ending
#   D - consonant suited for a stupid person's name
#   d - syllable suited for a stupid person's name (begins with a vowel)

# All characters between parenthesis () are emitted literally. For
# example, the pattern "s(dim)", emits a random generic syllable
# followed by "dim".

# Characters between angle brackets <> emit patterns from the table
# above. Imagine the entire pattern is wrapped in one of these.

# In both types of groupings, a vertical bar | denotes a random choice.
# Empty groups are allowed. For example, "(foo|bar)" emits either "foo"
# or "bar". The pattern "<c|v|>" emits a constant, vowel, or nothing at
# all.

# An exclamation point ! means to capitalize the component that follows
# it. For example, "!(foo)" will emit "Foo" and "v!s" will emit a
# lowercase vowel followed by a capitalized syllable, like "eRod"
proc namegen*(pattern: string; len, seed: int): string =
  var dst: cstring = spaces(len)
  var cseed = (culong) seed
  case namegen(dst, (culong) len, pattern, addr(cseed)):
    of 0, 1: return ($dst).strip()
    of 2: stderr.write("Invalid Pattern for namegen: \"", pattern, "\"")
    of 3: stderr.write("Pattern exceeds maximum nesting depth: \"", pattern, "\"")
    else: stderr.write("Unknown response from namegen")
  return "namegen failed"