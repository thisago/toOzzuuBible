# from std/dom import document, querySelector
import std/dom except find
from std/base64 import decode

from pkg/util/forStr import getAllEnclosedText
from pkg/bibleTools import parseBibleVerse, inOzzuuBible, `$`

proc find(w: Window, text: cstring, caseSensitive = false,
           backwards = false): bool {.importCpp.}
  ## Waiting merging of https://github.com/nim-lang/Nim/pull/21621
proc deleteContents(r: Range) {.importCpp.}

proc main =
  ## Main function
  for enclosed in getAllEnclosedText($document.body.innerText):
    for text in enclosed.data.texts:
      let verse = parseBibleVerse text
      if verse.error:
        continue
      while window.find cstring text:
        let rng = document.getSelection.getRangeAt 0
        rng.deleteContents
        var link = document.createElement "a"
        link.innerText = `$`(verse, hebrewTransliteration = true, shortBook = false)
        link.setAttribute("href", verse.inOzzuuBible)
        rng.insertNode link
        echo text


document.addEventListener("DOMContentLoaded", proc (ev: Event) =
  # Styling
  var style = document.createElement("style")
  style.innerHTML = "CSSCODEHERE".decode.cstring
  document.head.appendChild style
  
  main()
)
