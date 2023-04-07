import std/dom except find
from std/jsre import match, newRegExp, exec
import std/jsconsole
from std/strutils import strip, replace
from std/base64 import decode

from pkg/util/forStr import getAllEnclosedText
from pkg/bibleTools import parseBibleVerse, inOzzuuBible, `$`

proc find(w: Window, text: cstring, caseSensitive = false,
           backwards = false): bool {.importCpp.}
  ## Waiting merging of https://github.com/nim-lang/Nim/pull/21621
proc deleteContents(r: Range) {.importCpp.}
proc toString[T](x: T): cstring {.importCpp.}

let verseRegex = newRegExp(`$`(bibleTools.verseRegex.toString)[1..^2], "g")

proc main =
  ## Main function
  for enclosed in getAllEnclosedText($document.body.innerText):
    for text in enclosed.data.texts:
      let text = text.replace(".", "")
      for singleVerse in text.strip.match verseRegex:
        let verse = parseBibleVerse $singleVerse
        if verse.error:
          continue
        while window.find cstring text:
          let rng = document.getSelection.getRangeAt 0
          rng.deleteContents
          var link = document.createElement "a"
          link.innerText = `$`(verse, hebrewTransliteration = true, shortBook = false)
          link.setAttribute("href", verse.inOzzuuBible)
          link.setAttribute("target", "_blank")
          link.setAttribute("rel", "noopener noreferrer")
          link.setAttribute("class", "toOzzuuBible")
          rng.insertNode link
          echo text


document.addEventListener("DOMContentLoaded", proc (ev: Event) =
  # Styling
  var style = document.createElement("style")
  let css = cstring "CSSCODEHERE"
  style.innerHTML = css.`$`.decode.cstring
  document.head.appendChild style
  
  main()
)
