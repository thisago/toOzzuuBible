import pkg/gm_api/metadata

const
  repo = "https://git.ozzuu.com/thisago/toOzzuuBible"
  scriptUrl = repo & "/raw/branch/master/build/toOzzuuBible.user.js"

const userscriptHeader* = genMetadataBlock(
  name = "To Ozzuu Bible",
  author = "Thiago Navarro",
  version = "0.4.1",
  runAt = GmRunAt.docStart,
  downloadUrl = scriptUrl,
  updateUrl = scriptUrl,
  description = "A userscript that allows you go to the Ozzuu Bible in any biblical reference in any site!",
  homepageUrl = repo,
  grant = [
    GmPermitions.getValue,
    GmPermitions.setValue,
    GmPermitions.registerMenuCommand,
    GmPermitions.notification
  ],

)
