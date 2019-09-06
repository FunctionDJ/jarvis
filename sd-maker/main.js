const cproc = require("child_process")

process.chdir("sd-maker")

const makeSDCard = (size, location) => {
  return new Promise((resolve, reject) => {
    const cmdProcess = cproc.spawn("mksdcard", [size, location])
    
    cmdProcess.stdout.on("data", data => {
      reject(data)
    })
    
    cmdProcess.stderr.on("data", err => reject(data))
    
    cmdProcess.on("close", code => {
      if (code != "0") reject(code)
      resolve(code)
    })
  })
}

makeSDCard("2048M", "sd.raw").then(code => {
  console.log("SD Card created successfully")
}).catch(err => {
  throw new Error("mkSDCard error: " + err)
})