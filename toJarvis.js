"use strict"

const fs = require("fs")

const fileContents = fs.readFileSync("RSBE01.txt")
  //.slice(0,1000)

// remove "/r"
const filtered = fileContents
  .toString()
  .split("")
  .filter(c => c !== "\r")
  .join("")

const lines = filtered.split("\n")

if (lines[0].length !== 6) throw new Error(`GameID length invalid, GameID found: "${lines[0]}", length: ${lines[0].length} instead of 6`)

const gameId = lines.shift() // remove game id line
lines.shift() // remove empty line

const isCodeLine = line => {
  if (!line) return false

  if (line.startsWith("* ")) return true

  const hexRegEx = /[0-9,A-F]+/

  const parts = line.split(" ")

  for (const part of parts) { // if any part is not hex
    if (part.length !== 8) return false

    const match = hexRegEx.exec(part)

    if (match === null) return false

    if (match.index !== 0) return false
  }

  return true
}

const blocks = lines.join("\n").split("\n\n")

const codes = []

for (const block of blocks) {
  const blockLines = block.split("\n")

  if (!isCodeLine(blockLines[0])) { // first line is a title
    const title = blockLines[0]

    codes.push({
      title: blockLines[0],
      parts: [
        blockLines.slice(1).filter(l => isCodeLine(l)).map(l => (
          l.startsWith("* ") ? l.slice(2) : l
        ))
      ]
    })

    const curCode = codes[codes.length - 1]

    if (blockLines.slice(1).find(l => isCodeLine(l) && !l.startsWith("* "))) {
      curCode.disabled = true
    }

    const commentsList = blockLines.slice(1).filter(l => !isCodeLine(l))

    if (commentsList.length !== 0) {
      if (curCode.comments === undefined) curCode.comments = []
      curCode.comments.push(...commentsList)
    }

  } else { // first line is not a title
    const lastCode = codes[codes.length - 1]
    lastCode.parts.push([])

    for (const blockLine of blockLines) {
      if (isCodeLine(blockLine)) {
        const lastParts = lastCode.parts[lastCode.parts.length - 1]

        if (!blockLine.startsWith("* ")) {
          lastCode.disabled = true
          lastParts.push(blockLine)
        } else {
          lastParts.push(blockLine.slice(2))
        }
      } else {
        if (lastCode.comments === undefined) lastCode.comments = []
        lastCode.comments.push(blockLine)
      }
    }
  }
}

fs.writeFileSync("./RSBE01.json", JSON.stringify(codes, null, 2))