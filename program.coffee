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

###HTML Stream###
###
trumpet = require 'trumpet'
through = require 'through'

tt = trumpet()

stream = tt.select('.loud').createStream()
stream.pipe(through (buf) ->
    this.queue( buf.toString().toUpperCase())
  ).pipe(stream)

process.stdin.pipe(tt).pipe(process.stdout)
###

###Duplexer###
###
spawn = require('child_process').spawn
duplex = require 'duplexer'

module.exports = (cmd, args) ->
  ps = spawn(cmd,args)
  duplex(ps.stdin, ps.stdout)
###

###Duplexer Redux###
###
duplex = require 'duplexer'
through = require 'through'

module.exports = (counter) ->
  counts = {}

  write = (row) ->
    counts[row.country] = (counts[row.country] || 0) + 1
    true

  end = ->
    counter.setCounts(counts)
    true

  input = through(write, end)
  
  return duplex(input, counter)
###

###Combiner###
combine = require 'stream-combiner'
split = require 'split'
through = require 'through'
zlib = require 'zlib'

module.exports = ->

  grouper = through(write, end)
  current = null
  write = (line) ->
    return if line.length == 0
    row = JSON.parse line

    if row.type == 'genre'
      this.queue(JSON.stringify(current) + '\n') if current
      current = { name:row.name, books: [] }

    else if row.type == 'book'
      current.books.push(row.name)

    return

  end = ->
    this.queue(JSON.stringify(current) + '\n') if current
    this.queue(null)
    return



  combine(split(), grouper, zlib.createGzip())