### Beep Boop ###
###
console.log "beep boop"
###

###Meet Pipe###
###
fs = require 'fs'

file = process.argv[2]

fs.createReadStream(file).pipe(process.stdout)
###

###Input Output###
###
process.stdin.pipe(process.stdout)
###

###Transform###
###
through = require 'through'
tr = through (buf) -> 
  this.queue(buf.toString().toUpperCase())

process.stdin.pipe(tr).pipe(process.stdout)
###

