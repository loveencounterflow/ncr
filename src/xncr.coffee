

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr.bind CND
badge                     = 'CHR/XNCR'
log                       = CND.get_logger 'plain',   badge
info                      = CND.get_logger 'info',    badge
alert                     = CND.get_logger 'alert',   badge
debug                     = CND.get_logger 'debug',   badge
warn                      = CND.get_logger 'warn',    badge
whisper                   = CND.get_logger 'whisper', badge
help                      = CND.get_logger 'help',    badge
echo                      = CND.echo.bind CND
#...........................................................................................................
CHR                       = require './main'


### TAINT there should be a unified way to obtain copies of libraries with certain settings that
  differ from that library's default options. Interface could maybe sth like this:
  ```
  settings              = _.deep_copy CHR.options
  settings[ 'input' ]   = 'xncr'
  XNCR_CHR              = OPTIONS.new_library CHR, settings
  ```
###

### TAINT additional settings silently ignored ###

#-----------------------------------------------------------------------------------------------------------
settings              = { input: 'xncr' }
#...........................................................................................................
@analyze              = ( glyph     ) -> CHR.analyze          glyph, settings
@as_csg               = ( glyph     ) -> CHR.as_csg           glyph, settings
@as_chr               = ( glyph     ) -> CHR.as_chr           glyph, settings
@as_uchr              = ( glyph     ) -> CHR.as_uchr          glyph, settings
@as_cid               = ( glyph     ) -> CHR.as_cid           glyph, settings
@as_rsg               = ( glyph     ) -> CHR.as_rsg           glyph, settings
@as_sfncr             = ( glyph     ) -> CHR.as_sfncr         glyph, settings
@as_fncr              = ( glyph     ) -> CHR.as_fncr          glyph, settings
# @_as_xncr             = ( csg, cid  ) -> CHR._as_xncr         csg, cid
@chrs_from_text       = ( text      ) -> CHR.chrs_from_text    text, settings
@is_inner_glyph       = ( glyph     ) -> ( @as_csg glyph ) in [ 'u', 'jzr', ]
@chr_from_cid_and_csg = ( cid, csg  ) -> CHR.as_chr cid, { csg: csg }
@cid_range_from_rsg   = ( rsg       ) -> CHR.cid_range_from_rsg rsg
@html_from_text       = ( glyph     ) -> CHR.html_from_text   glyph, settings

#-----------------------------------------------------------------------------------------------------------
@jzr_as_uchr = ( glyph ) ->
  return @as_uchr glyph if ( @as_csg glyph ) is 'jzr'
  return glyph

#-----------------------------------------------------------------------------------------------------------
@normalize_text = ( text ) -> ( @normalize_glyph g for g in @chrs_from_text text ).join ''

#-----------------------------------------------------------------------------------------------------------
@normalize_glyph = ( glyph ) ->
  # alert "XNCR.normalize is deprecated"
  rsg = @as_rsg glyph
  cid = @as_cid glyph
  csg = @as_csg glyph
  return @chr_from_cid_and_csg cid, 'u' if ( rsg is 'u-pua' ) or ( csg in [ 'u', 'jzr', ] )
  return glyph

#-----------------------------------------------------------------------------------------------------------
@normalize_to_xncr = ( glyph ) ->
  cid = @as_cid glyph
  csg = if ( @as_rsg glyph ) is 'u-pua' then 'jzr' else @as_csg glyph
  return @chr_from_cid_and_csg cid, csg

#-----------------------------------------------------------------------------------------------------------
@normalize_to_pua = ( glyph ) ->
  cid = @as_cid glyph
  csg = @as_csg glyph
  csg = 'u' if csg is 'jzr'
  return @chr_from_cid_and_csg cid, csg





