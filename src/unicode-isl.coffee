


############################################################################################################
# CND                       = require 'cnd'
# rpr                       = CND.rpr
# badge                     = 'NCR/UNICODE-ISL'
# debug                     = CND.get_logger 'debug',     badge
ISL                       = require 'interskiplist'

u = ISL.new()
ISL.add u, interval for interval in require '../data/unicode-9.0.0-intervals.json'
module.exports = u

