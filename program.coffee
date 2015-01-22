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

###Lines###

###
split = require 'split'
through = require 'through'
lineCount = 0

tr = through( (buf) ->
    line = buf.toString()

    if(lineCount % 2 == 0)
      this.queue(line.toLowerCase() + '\n')
    else
      this.queue(line.toUpperCase() + '\n')

    lineCount++
    true
  )

process.stdin.pipe(split()).pipe(tr).pipe(process.stdout)
###

###Concat###
concat = require 'concat-stream'

reverse = (body) ->
	obj = JS

