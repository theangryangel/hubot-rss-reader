# detect charset from "encoding" attribute of XML
# convert using iconv

'use strict'

stream = require 'stream'
iconv  = require('iconv-lite')
debug  = require('debug')('hubot-rss-reader:charset-convert-stream')

module.exports = ->

  charset = null

  charsetConvertStream = stream.Transform()

  charsetConvertStream._transform = (chunk, enc, next) ->
    if charset is null and
       m = chunk.toString().match /<\?xml[^>]* encoding=['"]([^'"]+)['"]/
      charset = m[1]
      debug "charset: #{charset}"
    if charset?
      @push iconv.decode(chunk)
    else
      @push chunk
    next()

  return charsetConvertStream

