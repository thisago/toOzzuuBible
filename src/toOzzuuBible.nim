import std/asyncjs
import std/with
import std/dom except find
from std/strutils import strip, replace
from std/base64 import decode
from std/strformat import fmt

from pkg/util/forStr import getAllEnclosedText
from pkg/bibleTools import parseBibleVerses, inOzzuuBible, `$`
from pkg/gm_api import Gm, registerMenuCommand, setValue, getValue, notification

proc find(w: Window, text: cstring, caseSensitive = false,
           backwards = false): bool {.importCpp.}
  ## Waiting merging of https://github.com/nim-lang/Nim/pull/21621
proc deleteContents(r: Range) {.importCpp.}
proc empty(r: Selection) {.importCpp.}
proc scroll(r: Window; x, y: int) {.importCpp.}

const title = "To Ozzuu Bible"
var processedVerses = 0

proc main =
  ## Main function
  let currScroll = int window.scrollY
  for enclosed in getAllEnclosedText($document.body.innerText):
    for text in enclosed.data.texts:
      for verse in text.parseBibleVerses:
        if verse.parsed.error:
          continue
        while window.find cstring verse.raw:
          let
            selection = document.getSelection
            rng = selection.getRangeAt 0
          empty selection
          rng.deleteContents
          var link = document.createElement "a"
          with link:
            innerText = `$`(verse.parsed, hebrewTransliteration = true, shortBook = false)
            setAttribute("href", verse.parsed.inOzzuuBible)
            setAttribute("target", "_blank")
            setAttribute("rel", "noopener noreferrer")
            setAttribute("title", verse.raw)
            setAttribute("class", "toOzzuuBible")
          rng.insertNode link
          inc processedVerses
  window.scroll(0, currScroll)

const autorunKey = cstring "autorun"
proc isAutorunOn: Future[bool] {.async, inline.} =
  result = (await Gm.getValue autorunKey) == cstring "true"

proc setup {.async.} =
  ## Async setup
  var autorunOn = await isAutorunOn()

  Gm.registerMenuCommand(
    (if autorunOn: "Disable" else: "Enable") & " autorun",
    proc = 
      autorunOn = not autorunOn
      discard Gm.setValue(autorunKey, cstring $autorunOn)
      Gm.notification("Please reload the page.", title)
  , "a")
  Gm.registerMenuCommand(
    "Get found verses count",
    proc = 
      var msg = fmt"Processed {processedVerses} verses!"
      if processedVerses == 0:
        msg = "There's no processed verses. Check if the autorun is on or press `F4` to run."
      Gm.notification(msg, title)
  , "a")

  document.addEventListener("DOMContentLoaded", proc (ev: Event) =
    # Styling
    var style = document.createElement("style")
    let css = cstring "CSSCODEHERE"
    style.innerHTML = css.`$`.decode.cstring
    document.head.appendChild style
    
    if autorunOn:
      discard setTimeout(main, 0)
    document.addEventListener("keydown", proc (event: Event) =
      if KeyboardEvent(event).key == "F4":
        main()
        preventDefault ev
    )
  )

discard setup()
