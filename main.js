const fs = require("fs")
const path = require("path")

const filePath = process.argv[2]

const hex2bin = hex => {
  return new Buffer.from(hex, "hex")
}

const write2file = (file, data) => {
  return new Promise((resolve, reject) => {

    fs.open(file, "w", (err, fd) => {
      if (err) reject(err)
      const toWrite = hex2bin(data)
  
      fs.write(fd, toWrite, 0, toWrite.length, 0, (err, bW, buf) => {
        if (err) reject(err)
  
        fs.close(fd, err => {
          if (err) reject(err)
          resolve()
        })
      })
    })

  })
}

if (!filePath) throw new Error("No file specified")

const filePathParsed = path.parse(process.argv[2])

fs.readFile(filePath, "utf-8", (err, data) => {
  if (err) {
    if (err.code == "ENOENT") {
      console.error("No such file or directory")
    } else {
      console.error(err)
    }

    return
  }

  const lines = data.split("\r\n")

  const gameID = lines.shift().trim()

  if (!gameID) throw new Error("No game ID found in first line of file")
  console.log(`Converting codeset for game with ID ${gameID}...`)

  let outArr = ["00D0C0DE00D0C0DE"]

  lines.forEach(line => {
    if (line.startsWith("* ")) {
      const content = line.substr(2).trim().replace(" ", "")
      outArr.push(content)
    }
  })

  outArr.push("F000000000000000")

  console.log(outArr)

  const asciiData = outArr.join("")

  console.log(asciiData)

  write2file(filePathParsed.name + ".gct", asciiData).then(() => {
    console.log("Converted file successfully")
  }).catch(err => {
    throw err
  })
})