


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'NCR/UNICODE-ISL'
# log                       = CND.get_logger 'plain',     badge
# info                      = CND.get_logger 'info',      badge
# whisper                   = CND.get_logger 'whisper',   badge
# alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
# warn                      = CND.get_logger 'warn',      badge
# help                      = CND.get_logger 'help',      badge
# urge                      = CND.get_logger 'urge',      badge
# echo                      = CND.echo.bind CND


#-----------------------------------------------------------------------------------------------------------
@_compile_base_intervals = ( intervals ) ->
  ### Assemble the ~650 intervals that descrive those parts of the Unicode code space that are assigned
  (over 100,000 codepoints); the rest is (roughly a million codepoints) unassigned. Returns a list of PODs
  with `lo`, `hi`, `tag` attributes. ###
  ISL           = require 'interskiplist'
  ucps          = require '../data/unicode-9.0.0-codepoints.js'
  cp_intervals  = ISL.intervals_from_points null, ucps.codepoints
  cp_intervals.push range for range in ucps.ranges
  #.........................................................................................................
  intervals.push { lo: 0x000000, hi: 0x10ffff, tag: 'unassigned', }
  for cp_interval in cp_intervals
    { lo, hi, }   = cp_interval
    intervals.push { lo, hi, tag: '-unassigned assigned', }
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_compile_planes = ( intervals ) ->
  rsg_registry  = require './character-sets-and-ranges'
  #.........................................................................................................
  for [ short_name, lo, hi ] in rsg_registry[ 'unicode-planes' ]
    type                        = 'plane'
    name                        = "#{type}:#{short_name}"
    intervals.push { lo, hi, name, type, plane: short_name, }
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_compile_areas = ( intervals ) ->
  rsg_registry  = require './character-sets-and-ranges'
  #.........................................................................................................
  for [ short_name, lo, hi ] in rsg_registry[ 'unicode-areas' ]
    type                        = 'area'
    name                        = "#{type}:#{short_name}"
    intervals.push { lo, hi, name, type, area: short_name, }
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_compile_blocks = ( intervals ) ->
  rsg_registry  = require './character-sets-and-ranges'
  #.........................................................................................................
  for csg, ranges of rsg_registry[ 'names-and-ranges-by-csg' ]
    continue unless csg is 'u'
    for range in ranges
      short_name              = range[ 'range-name' ]
      rsg                     = range[ 'rsg'        ]
      lo                      = range[ 'first-cid'  ]
      hi                      = range[ 'last-cid'   ]
      type                    = 'block'
      name                    = "#{type}:#{short_name}"
      intervals.push { lo, hi, name, type, block: short_name, rsg, }
      # # is_cjk                  = is_cjk_rsg rsg
      # tex                     = tex_command_by_rsgs[ rsg ] ? null
      # name                    = "block:#{name}"
      # interval                = { name, lo, hi, rsg, }
      # interval[ 'tex' ]       = tex if tex?
      # intervals_by_rsg[ rsg ] = interval
      # ISL.add u, interval
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_read_or_write_cache = ->
  ISL           = require 'interskiplist'
  FS            = require 'fs'
  cache_route   = ( require 'path' ).resolve __dirname, '../data/_cache-Unicode-V9.0.0-base-intervals.json'
  #.........................................................................................................
  if FS.existsSync cache_route
    intervals         = require cache_route
  #.........................................................................................................
  else
    intervals         = []
    @_compile_base_intervals intervals
    @_compile_planes         intervals
    @_compile_areas          intervals
    @_compile_blocks         intervals
    intervals_txt     = JSON.stringify intervals, null, '  '
    FS.writeFileSync cache_route, intervals_txt
  #.........................................................................................................
  R = ISL.new()
  ISL.add R, interval for interval in intervals
  #.........................................................................................................
  return R

############################################################################################################
module.exports = @_read_or_write_cache()

