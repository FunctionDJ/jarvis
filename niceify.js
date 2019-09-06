const titleParse = title => {
  const r = {title}

  if (r.title.startsWith("[")) {
    const i = r.title.indexOf("]")

    r.game = r.title.substring(1, i)

    r.title = r.title.slice(i + 1).trim()
  }

  if (r.title.endsWith("]")) {
    const i = r.title.indexOf("[")

    r.authors = r.title
      .slice(i + 1, -1)
      .split(", ")

    r.title = r.title.slice(0, i).trim()
  }

  return r
}


const rsbe = require("./RSBE01.json")

const newCode = rsbe
  .map(c => {
    const infoObject = titleParse(c.title)

    return {
      ...c,
      ...infoObject
    }
  })


require("fs").writeFileSync("./RSBE01.json",
  JSON.stringify(newCode, null, 2)
)