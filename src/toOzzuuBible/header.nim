import pkg/gm_api/metadata

const userscriptHeader* = genMetadataBlock(
  name = "To Ozzuu Bible",
  author = "Thiago Navarro",
  match = [
    "*://*/*",
  ],
  version = "0.1.0",
  runAt = GmRunAt.docStart,
  downloadUrl = "https://git.ozzuu.com/thisago/toOzzuuBible/raw/branch/master/build/toOzzuuBible.user.js",
  description = "A userscript that allows you go to the Ozzuu Bible in any biblical reference in any site!",
  homepageUrl = "https://git.ozzuu.com/thisago/toOzzuuBible",
)
