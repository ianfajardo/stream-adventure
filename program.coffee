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
###
concat = require 'concat-stream'

process.stdin.pipe(concat (src) ->
    s = src.toString().split('').reverse().join('')
    console.log s 
    true
  )
###

###HTTP SERVER###
###
http = require 'http'
through = require 'through'
port = process.argv[2]

server = http.createServer (req,res) ->
  if(req.method == 'POST')
    req.pipe(through (buf)-> 
        this.queue(buf.toString().toUpperCase())
      ).pipe(res) 
  else
    res.end();

server.listen Number port
###

###HTTP Client###
###
request = require 'request'

process.stdin.pipe(request.post('http://localhost:8000')).pipe(process.stdout)
###

###WebSockets###
###
ws = require 'websocket-stream'
stream = ws 'ws://localhost:8000'
stream.write("hello\n")
stream.end()
###