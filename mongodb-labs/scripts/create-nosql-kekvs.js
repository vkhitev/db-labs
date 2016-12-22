const fs = require('fs')
const path = require('path')

const kekvs = require(path.join(process.cwd(), process.argv[2], 'kekvs'))

const nosqlData = kekvs.map(kekv => ({
  code: kekv.code,
  description: kekv.description
}))

fs.writeFileSync(
  path.resolve(process.cwd(), process.argv[3]),
  JSON.stringify(nosqlData, null, 2)
)
