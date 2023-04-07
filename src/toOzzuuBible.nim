import std/dom except find
from std/strutils import strip, replace
from std/base64 import decode
from std/strformat import fmt

from pkg/util/forStr import getAllEnclosedText
from pkg/bibleTools import parseBibleVerses, inOzzuuBible, `$`

proc find(w: Window, text: cstring, caseSensitive = false,
           backwards = false): bool {.importCpp.}
  ## Waiting merging of https://github.com/nim-lang/Nim/pull/21621
proc deleteContents(r: Range) {.importCpp.}
proc empty(r: Selection) {.importCpp.}

proc main =
  ## Main function
  for enclosed in getAllEnclosedText($document.body.innerText):
    for text in enclosed.data.texts:
      for verse in text.parseBibleVerses:
        if verse.parsed.error:
          continue
        echo verse.raw
        while window.find cstring verse.raw:
          let
            selection = document.getSelection
            rng = selection.getRangeAt 0
          empty selection
          rng.deleteContents
          var link = document.createElement "a"
          link.innerText = `$`(verse.parsed, hebrewTransliteration = true, shortBook = false)
          link.setAttribute("href", verse.parsed.inOzzuuBible)
          link.setAttribute("target", "_blank")
          link.setAttribute("rel", "noopener noreferrer")
          link.setAttribute("title", verse.raw)
          link.setAttribute("class", "toOzzuuBible")
          rng.insertNode link
          echo "matched: ", verse.raw

document.addEventListener("DOMContentLoaded", proc (ev: Event) =
  # Styling
  var style = document.createElement("style")
  let css = cstring "CSSCODEHERE"
  style.innerHTML = css.`$`.decode.cstring
  document.head.appendChild style
  
  discard setTimeout(main, 500)
)
