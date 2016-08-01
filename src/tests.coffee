


############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'NCR/tests'
log                       = CND.get_logger 'plain',     badge
info                      = CND.get_logger 'info',      badge
whisper                   = CND.get_logger 'whisper',   badge
alert                     = CND.get_logger 'alert',     badge
debug                     = CND.get_logger 'debug',     badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
echo                      = CND.echo.bind CND
test                      = require 'guy-test'
NCR                       = require './main'


#===========================================================================================================
# HELPERS
#-----------------------------------------------------------------------------------------------------------
@_prune = ->
  for name, value of @
    continue if name.startsWith '_'
    delete @[ name ] unless name in include
  return null

#-----------------------------------------------------------------------------------------------------------
@_main = ->
  test @, 'timeout': 3000

#-----------------------------------------------------------------------------------------------------------
hex = ( n ) -> '0x' + n.toString 16


#===========================================================================================================
# TESTS
#-----------------------------------------------------------------------------------------------------------
@[ 'test # 1' ] = ( T ) ->
  T.eq ( ( '&#123;helo'.match     NCR._first_chr_matcher_ncr )[ 1 .. 3 ] ), [ '', undefined, '123' ]

@[ 'test # 2' ] = ( T ) ->
  T.eq ( ( '&#x123;helo'.match    NCR._first_chr_matcher_ncr )[ 1 .. 3 ] ), [ '', '123', undefined ]

@[ 'test # 3' ] = ( T ) ->
  T.eq ( ( '&#x123;helo'.match    NCR._first_chr_matcher_xncr )[ 1 .. 3 ] ),[ '', '123', undefined ]

@[ 'test # 4' ] = ( T ) ->
  T.eq ( ( '&jzr#123;helo'.match  NCR._first_chr_matcher_xncr )[ 1 .. 3 ] ),[ 'jzr', undefined, '123' ]

@[ 'test # 5' ] = ( T ) ->
  T.eq ( ( '&jzr#x123;helo'.match NCR._first_chr_matcher_xncr )[ 1 .. 3 ] ),[ 'jzr', '123', undefined ]

@[ 'test # 6' ] = ( T ) ->
  T.eq ( ( '𤕣'[ 0 ] + 'x' ).match NCR._first_chr_matcher_plain ), null

@[ 'test # 7' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#97;abc', 'ncr' ),                    [ '&#97;', 'u', 97 ]

@[ 'test # 8' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#97;abc', 'plain' ),                  [ '&', 'u', 38 ]

@[ 'test # 9' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#97;abc', 'xncr' ),                   [ '&#97;', 'u', 97 ]

@[ 'test # 10' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#x61;abc' ),                          [ '&', 'u', 38 ]

@[ 'test # 11' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#x61;abc', 'ncr' ),                   [ '&#x61;', 'u', 97 ]

@[ 'test # 12' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#x61;abc', 'plain' ),                 [ '&', 'u', 38 ]

@[ 'test # 13' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr '&#x61;abc', 'xncr' ),                  [ '&#x61;', 'u', 97 ]

@[ 'test # 14' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr 'abc', 'ncr' ),                         [ 'a', 'u', 97 ]

@[ 'test # 15' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr 'abc', 'plain' ),                       [ 'a', 'u', 97 ]

@[ 'test # 16' ] = ( T ) ->
  T.eq ( NCR._chr_csg_cid_from_chr 'abc', 'xncr' ),                        [ 'a', 'u', 97 ]

@[ 'test # 17' ] = ( T ) ->
  T.eq ( NCR.analyze '&#x24563;'                   ), {'~isa':     'NCR/info',"uchr":"&","chr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}

@[ 'test # 18' ] = ( T ) ->
  T.eq ( NCR.analyze '&#x24563;', input: 'ncr'      ), {'~isa':     'NCR/info',"uchr":"𤕣","chr":"𤕣","csg":"u","cid":148835,"fncr":"u-cjk-xb-24563","sfncr":"u-24563","ncr":"&#x24563;","xncr":"&#x24563;","rsg":"u-cjk-xb"}

@[ 'test # 19' ] = ( T ) ->
  T.eq ( NCR.analyze '&#x24563;', input: 'xncr'     ), {'~isa':     'NCR/info',"uchr":"𤕣","chr":"𤕣","csg":"u","cid":148835,"fncr":"u-cjk-xb-24563","sfncr":"u-24563","ncr":"&#x24563;","xncr":"&#x24563;","rsg":"u-cjk-xb"}

@[ 'test # 20' ] = ( T ) ->
  T.eq ( NCR.analyze '&jzr#x24563;'                ), {'~isa':     'NCR/info',"uchr":"&","chr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}

@[ 'test # 21' ] = ( T ) ->
  T.eq ( NCR.analyze '&jzr#x24563;', input: 'ncr'   ), {'~isa':     'NCR/info',"uchr":"&","chr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}

@[ 'test # 22' ] = ( T ) ->
  # debug '©BY7x6', JSON.stringify ( NCR.analyze '&jzr#x24563;', input: 'xncr'  )
  T.eq ( NCR.analyze '&jzr#x24563;', input: 'xncr'  ), {'~isa':     'NCR/info',"uchr":"𤕣","chr":"&jzr#x24563;","csg":"jzr","cid":148835,"fncr":"jzr-24563","sfncr":"jzr-24563","ncr":"&#x24563;","xncr":"&jzr#x24563;","rsg":null}

@[ 'test # 22a' ] = ( T ) ->
  debug '©BY7x6', JSON.stringify ( NCR.analyze '&jzr#xe101;', input: 'xncr'  )
  T.eq ( NCR.analyze '&jzr#xe101;', input: 'xncr'  ), {"~isa":"NCR/info","chr":"&jzr#xe101;","uchr":"","csg":"jzr","cid":57601,"fncr":"jzr-fig-e101","sfncr":"jzr-e101","ncr":"&#xe101;","xncr":"&jzr#xe101;","rsg":"jzr-fig"}

@[ 'test # 22b' ] = ( T ) ->
  T.eq ( NCR.analyze '&jzr#e101;', input: 'xncr'  ), {"~isa":"NCR/info","chr":"&","uchr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}

@[ 'test # 23' ] = ( T ) ->
  T.eq ( NCR.analyze 'helo world' ), {'~isa':     'NCR/info',"uchr":"h","chr":"h","csg":"u","cid":104,"fncr":"u-latn-68","sfncr":"u-68","ncr":"&#x68;","xncr":"&#x68;","rsg":"u-latn"}

@[ 'test # 24' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text ''                   ), []

@[ 'test # 25' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '',                  input: 'ncr'  ), []

@[ 'test # 26' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '',                  input: 'xncr' ), []

@[ 'test # 27' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text 'abc'                ), [ 'a', 'b', 'c' ]

@[ 'test # 28' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text 'abc',               input: 'ncr'  ), [ 'a', 'b', 'c' ]

@[ 'test # 29' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text 'abc',               input: 'xncr' ), [ 'a', 'b', 'c' ]

@[ 'test # 30' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#123;b𤕣c'        ), [ '𤕣', 'a', '&', '#', '1', '2', '3', ';', 'b', '𤕣', 'c' ]

@[ 'test # 31' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#123;b𤕣c',       input: 'ncr'  ), [ '𤕣', 'a', '&#123;', 'b', '𤕣', 'c' ]

@[ 'test # 32' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#123;b𤕣c',       input: 'xncr' ), [ '𤕣', 'a', '&#123;', 'b', '𤕣', 'c' ]

@[ 'test # 33' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#x123ab;b𤕣c'     ), [ '𤕣', 'a', '&', '#', 'x', '1', '2', '3', 'a', 'b', ';', 'b', '𤕣', 'c' ]

@[ 'test # 34' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#x123ab;b𤕣c',    input: 'ncr'  ), [ '𤕣', 'a', '&#x123ab;', 'b', '𤕣', 'c' ]

@[ 'test # 35' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&#x123ab;b𤕣c',    input: 'xncr' ), [ '𤕣', 'a', '&#x123ab;', 'b', '𤕣', 'c' ]

@[ 'test # 36' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&jzr#123;b𤕣c'     ), [ '𤕣', 'a', '&', 'j', 'z', 'r', '#', '1', '2', '3', ';', 'b', '𤕣', 'c' ]

@[ 'test # 37' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&jzr#x123ab;b𤕣c'  ), [ '𤕣', 'a', '&', 'j', 'z', 'r', '#', 'x', '1', '2', '3', 'a', 'b', ';', 'b', '𤕣', 'c' ]

@[ 'test # 38' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&jzr#x123ab;b𤕣c', input: 'ncr'  ), [ '𤕣', 'a', '&', 'j', 'z', 'r', '#', 'x', '1', '2', '3', 'a', 'b', ';', 'b', '𤕣', 'c' ]

@[ 'test # 39' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣a&jzr#x123ab;b𤕣c', input: 'xncr' ), [ '𤕣', 'a', '&jzr#x123ab;', 'b', '𤕣', 'c' ]

@[ 'test # 40' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣abc'               ), [ '𤕣', 'a', 'b', 'c' ]

@[ 'test # 41' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣abc',              input: 'ncr'  ), [ '𤕣', 'a', 'b', 'c' ]

@[ 'test # 42' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣abc',              input: 'xncr' ), [ '𤕣', 'a', 'b', 'c' ]

@[ 'test # 43' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣ab𤕣c'              ), [ '𤕣', 'a', 'b', '𤕣', 'c' ]

@[ 'test # 44' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣ab𤕣c',             input: 'ncr'  ), [ '𤕣', 'a', 'b', '𤕣', 'c' ]

@[ 'test # 45' ] = ( T ) ->
  T.eq ( NCR.chrs_from_text '𤕣ab𤕣c',             input: 'xncr' ), [ '𤕣', 'a', 'b', '𤕣', 'c' ]

@[ 'test # 46' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text '1 < 2', output: 'html'                          ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"1 &lt; 2"}]

@[ 'test # 47' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text '2 > 1', output: 'html'                          ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"2 &gt; 1"}]

@[ 'test # 48' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&#x63;d'                                      ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"ab&#x63;d"}]

@[ 'test # 49' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&#x63;d', input: 'ncr'                        ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"abcd"}]

@[ 'test # 50' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&#x63;d', input: 'xncr'                       ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"abcd"}]

@[ 'test # 51' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&jzr#xe063;d'                                 ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"ab&jzr#xe063;d"}]

@[ 'test # 52' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&jzr#xe063;d', input: 'ncr'                   ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"ab&jzr#xe063;d"}]

@[ 'test # 53' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&jzr#xe063;d', input: 'xncr'                  ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"ab"},{"~isa":"NCR/chunk","csg":"jzr","rsg":"jzr-fig","text":"&#xe063;"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"d"}]

@[ 'test # 54' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'ab&jzr#xe063;d', input: 'xncr', output: 'html'  ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"ab"},{"~isa":"NCR/chunk","csg":"jzr","rsg":"jzr-fig","text":"&#xe063;"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"d"}]

@[ 'test # 55' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'helo wörld'                                     ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"helo w"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn-1","text":"ö"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"rld"}]

@[ 'test # 56' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'helo wörld', output: 'html'                     ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"helo w"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn-1","text":"ö"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"rld"}]

@[ 'test # 57' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'me & you', output: 'html'                       ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"me &amp; you"}]

@[ 'test # 58' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text 'me &amp; you', output: 'html'                   ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-latn","text":"me &amp;amp; you"}]

@[ 'test # 59' ] = ( T ) ->
  T.eq ( NCR.chunks_from_text '種果〇𤕣カタカナ'                                       ), [{"~isa":"NCR/chunk","csg":"u","rsg":"u-cjk","text":"種果"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-cjk-sym","text":"〇"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-cjk-xb","text":"𤕣"},{"~isa":"NCR/chunk","csg":"u","rsg":"u-cjk-kata","text":"カタカナ"}]

@[ 'test # 60' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '&#x24563;' ),                               [ 'u', 38 ]

@[ 'test # 61' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '&#x24563;', input: 'ncr' ),                        [ 'u', 148835 ]

@[ 'test # 62' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '&#x24563;', input: 'plain' ),                      [ 'u', 38 ]

@[ 'test # 63' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '&#x24563;', input: 'xncr' ),                       [ 'u', 148835 ]

@[ 'test # 64' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '𤕣' ),                                       [ 'u', 148835 ]

@[ 'test # 65' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '𤕣', input: 'ncr' ),                                [ 'u', 148835 ]

@[ 'test # 66' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '𤕣', input: 'plain' ),                              [ 'u', 148835 ]

@[ 'test # 67' ] = ( T ) ->
  T.eq ( NCR.csg_cid_from_chr '𤕣', input: 'xncr' ),                               [ 'u', 148835 ]

@[ 'test # 68' ] = ( T ) ->
  T.eq ( NCR._as_sfncr 'jzr', 0x12abc ), 'jzr-12abc'

@[ 'test # 69' ] = ( T ) ->
  T.eq ( NCR._as_sfncr 'u', 0x12abc   ), 'u-12abc'

@[ 'test # 70' ] = ( T ) ->
  T.eq ( NCR._as_xncr 'jzr', 0x12abc ), '&jzr#x12abc;'

@[ 'test # 71' ] = ( T ) ->
  T.eq ( NCR._as_xncr 'u', 0x12abc     ), '&#x12abc;'

@[ 'test # 72' ] = ( T ) ->
  T.eq ( NCR._as_xncr 'u', 0x12abc   ), '&#x12abc;'

@[ 'test # 73' ] = ( T ) ->
  T.eq ( NCR.as_cid      '&jzr#xe100;',  input:  'xncr', csg: 'u'   ), 0xe100

@[ 'test # 74' ] = ( T ) ->
  T.eq ( NCR.as_cid      '&jzr#xe100;',  input: 'xncr'              ), 0xe100

@[ 'test # 75' ] = ( T ) ->
  T.eq ( NCR.as_cid      '𤕣',           input:  'xncr'              ), 0x24563

@[ 'test # 76' ] = ( T ) ->
  T.eq ( NCR.as_csg      '&jzr#xe100;',  input:  'xncr', csg: 'u'   ), 'u'

@[ 'test # 77' ] = ( T ) ->
  T.eq ( NCR.as_csg      '&jzr#xe100;',  input: 'xncr'              ), 'jzr'

@[ 'test # 78' ] = ( T ) ->
  T.eq ( NCR.as_csg      '𤕣',           input:  'xncr'              ), 'u'

@[ 'test # 79' ] = ( T ) ->
  T.eq ( NCR.as_fncr     '&#x1;',        input:  'xncr', csg: 'jzr' ), 'jzr-1'

@[ 'test # 80' ] = ( T ) ->
  T.eq ( NCR.as_fncr     '&#xe123;',     input:  'xncr', csg: 'jzr' ), 'jzr-fig-e123'

@[ 'test # 81' ] = ( T ) ->
  T.eq ( NCR.as_fncr     '𤕣',           input:  'xncr'             ), 'u-cjk-xb-24563'

@[ 'test # 82' ] = ( T ) ->
  T.eq ( NCR.as_ncr 0x12abc        ), '&#x12abc;'

@[ 'test # 83' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&#xe100;',     input: 'ncr' ), 'Private Use Area'

@[ 'test # 84' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&#xe100;',     input: 'plain' ), 'Basic Latin'

@[ 'test # 85' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&#xe100;',     input: 'xncr' ), 'Private Use Area'

@[ 'test # 86' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&jzr#xe100;',  input: 'ncr' ), 'Basic Latin'

@[ 'test # 87' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&jzr#xe100;',  input: 'plain' ), 'Basic Latin'

@[ 'test # 88' ] = ( T ) ->
  T.eq ( NCR.as_range_name '&jzr#xe100;',  input: 'xncr' ), 'Jizura Character Components'

@[ 'test # 89' ] = ( T ) ->
  T.eq ( NCR.as_range_name 'a' ), 'Basic Latin'

@[ 'test # 90' ] = ( T ) ->
  T.eq ( NCR.as_range_name '𤕣' ), 'CJK Unified Ideographs Extension B'

@[ 'test # 91' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&#xe100;',     input: 'ncr' ), 'u-pua'

@[ 'test # 92' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&#xe100;',     input: 'plain' ), 'u-latn'

@[ 'test # 93' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&#xe100;',     input: 'xncr' ), 'u-pua'

@[ 'test # 94' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&jzr#xe100;',  input: 'ncr' ), 'u-latn'

@[ 'test # 95' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&jzr#xe100;',  input: 'plain' ), 'u-latn'

@[ 'test # 96' ] = ( T ) ->
  T.eq ( NCR.as_rsg        '&jzr#xe100;',  input: 'xncr' ), 'jzr-fig'

@[ 'test # 97' ] = ( T ) ->
  T.eq ( NCR.as_rsg      '&#x1;',        input:  'xncr', csg: 'jzr' ), null

@[ 'test # 98' ] = ( T ) ->
  T.eq ( NCR.as_rsg      '&#xe100;',     input:  'xncr', csg: 'jzr' ), 'jzr-fig'

@[ 'test # 99' ] = ( T ) ->
  T.eq ( NCR.as_rsg      '&#xe100;',     input:  'xncr', csg: 'u'   ), 'u-pua'

@[ 'test # 100' ] = ( T ) ->
  T.eq ( NCR.as_rsg      '&jzr#xe100;',  input:  'xncr', csg: 'u'   ), 'u-pua'

@[ 'test # 101' ] = ( T ) ->
  T.eq ( NCR.as_rsg 'a'        ), 'u-latn'

@[ 'test # 102' ] = ( T ) ->
  T.eq ( NCR.as_rsg '𤕣'        ), 'u-cjk-xb'

@[ 'test # 103' ] = ( T ) ->
  T.eq ( NCR.as_sfncr 'a'      ), 'u-61'

@[ 'test # 104' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#678;'            ), 38

@[ 'test # 105' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#678;',     input: 'ncr', ), 678

@[ 'test # 106' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#678;',     input: 'xncr', ), 678

@[ 'test # 107' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#x678;'           ), 38

@[ 'test # 108' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#x678;',    input: 'ncr', ), 0x678

@[ 'test # 109' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&#x678;',    input: 'xncr', ), 0x678

@[ 'test # 110' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#678;'         ), 38

@[ 'test # 111' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#678;',  input: 'ncr', ), 38

@[ 'test # 112' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#678;',  input: 'xncr', ), 678

@[ 'test # 113' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#x678;'        ), 38

@[ 'test # 114' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#x678;', input: 'ncr', ), 38

@[ 'test # 115' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr '&jzr#x678;', input: 'xncr', ), 0x678

@[ 'test # 116' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'a'                 ), 97

@[ 'test # 117' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'a',          input: 'ncr', ), 97

@[ 'test # 118' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'a',          input: 'xncr', ), 97

@[ 'test # 119' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'x'                 ), 120

@[ 'test # 120' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'x',          input: 'ncr', ), 120

@[ 'test # 121' ] = ( T ) ->
  T.eq ( NCR.cid_from_chr 'x',          input: 'xncr', ), 120

@[ 'test # 122' ] = ( T ) ->
  T.eq ( NCR.html_from_text '&jzr#xe101; & you', input: 'xncr'   ), """<span class="jzr-fig">&#xe101;</span><span class="u-latn"> &amp; you</span>"""

@[ 'test # 123' ] = ( T ) ->
  T.eq ( NCR.html_from_text 'helo &#x24563; wörld'               ), """<span class="u-latn">helo &amp;#x24563; w</span><span class="u-latn-1">ö</span><span class="u-latn">rld</span>"""

@[ 'test # 124' ] = ( T ) ->
  T.eq ( NCR.html_from_text 'helo &#x24563; wörld', input: 'xncr'), """<span class="u-latn">helo </span><span class="u-cjk-xb">𤕣</span><span class="u-latn"> w</span><span class="u-latn-1">ö</span><span class="u-latn">rld</span>"""

@[ 'test # 125' ] = ( T ) ->
  T.eq ( NCR.html_from_text 'helo wörld'                         ), """<span class="u-latn">helo w</span><span class="u-latn-1">ö</span><span class="u-latn">rld</span>"""

@[ 'test Unicode 8 / CJK Extension E' ] = ( T ) ->
  T.eq ( NCR.as_csg '𫠠' ), 'u'
  T.eq ( NCR.as_rsg '𫠠' ), 'u-cjk-xe'
  T.eq ( NCR.as_fncr '𫠠' ), 'u-cjk-xe-2b820'

@[ 'test # 200' ] = ( T ) ->
  XNCR = Object.assign {}, NCR, { _input_default: 'xncr', }
  XNCR._names_and_ranges_by_csg[ 'foo' ] = [ [ '(Glyphs)', 'foo', 0x0000, 0xffffffff, ] ]
  # debug '6651', XNCR._names_and_ranges_by_csg is NCR._names_and_ranges_by_csg
  # debug '8090', JSON.stringify (  NCR.analyze '&foo#x24563;' )
  # debug '8090', JSON.stringify ( XNCR.analyze '&foo#x24563;' )
  # debug '8090', JSON.stringify (  NCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' )
  # debug '8090', JSON.stringify ( XNCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' )
  T.eq (  NCR.analyze '&foo#x24563;' ), {"~isa":"NCR/info","chr":"&","uchr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}
  T.eq ( XNCR.analyze '&foo#x24563;' ), {"~isa":"NCR/info","chr":"&foo#x24563;","uchr":"𤕣","csg":"foo","cid":148835,"fncr":"foo-24563","sfncr":"foo-24563","ncr":"&#x24563;","xncr":"&foo#x24563;","rsg":null}
  T.eq (  NCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' ), "<span class=\"u-latn\">abc&amp;foo#x24563;xyz</span><span class=\"u-latn-1\">äöü</span><span class=\"u-cjk\">丁三夫國形丁三夫國形丁三夫國形</span><span class=\"u-cjk-xe\">𫠠</span><span class=\"u-cjk-xb\">𧑴𨒡</span>"
  T.eq ( XNCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' ), "<span class=\"u-latn\">abc</span><span class=\"foo\">&#x24563;</span><span class=\"u-latn\">xyz</span><span class=\"u-latn-1\">äöü</span><span class=\"u-cjk\">丁三夫國形丁三夫國形丁三夫國形</span><span class=\"u-cjk-xe\">𫠠</span><span class=\"u-cjk-xb\">𧑴𨒡</span>"

@[ 'test # 201' ] = ( T ) ->
  # debug '4432', NCR
  ### TAINT poor man's deep copy: ###
  XNCR = Object.assign {}, NCR
  XNCR._names_and_ranges_by_csg = Object.assign {}, XNCR._names_and_ranges_by_csg
  XNCR._input_default = 'xncr'
  XNCR._names_and_ranges_by_csg[ 'foo' ] = [ [ '(Glyphs)', 'foo', 0x0000, 0xffffffff, ] ]
  T.eq ( XNCR._names_and_ranges_by_csg is NCR._names_and_ranges_by_csg ), false
  # debug '8090', JSON.stringify (  NCR.analyze '&foo#x24563;' )
  # debug '8090', JSON.stringify ( XNCR.analyze '&foo#x24563;' )
  # debug '8090', JSON.stringify (  NCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' )
  # debug '8090', JSON.stringify ( XNCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' )
  T.eq (  NCR.analyze '&foo#x24563;' ), {"~isa":"NCR/info","chr":"&","uchr":"&","csg":"u","cid":38,"fncr":"u-latn-26","sfncr":"u-26","ncr":"&#x26;","xncr":"&#x26;","rsg":"u-latn"}
  T.eq ( XNCR.analyze '&foo#x24563;' ), {"~isa":"NCR/info","chr":"&foo#x24563;","uchr":"𤕣","csg":"foo","cid":148835,"fncr":"foo-24563","sfncr":"foo-24563","ncr":"&#x24563;","xncr":"&foo#x24563;","rsg":null}
  T.eq (  NCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' ), "<span class=\"u-latn\">abc&amp;foo#x24563;xyz</span><span class=\"u-latn-1\">äöü</span><span class=\"u-cjk\">丁三夫國形丁三夫國形丁三夫國形</span><span class=\"u-cjk-xe\">𫠠</span><span class=\"u-cjk-xb\">𧑴𨒡</span>"
  T.eq ( XNCR.html_from_text 'abc&foo#x24563;xyzäöü丁三夫國形丁三夫國形丁三夫國形𫠠𧑴𨒡' ), "<span class=\"u-latn\">abc</span><span class=\"foo\">&#x24563;</span><span class=\"u-latn\">xyz</span><span class=\"u-latn-1\">äöü</span><span class=\"u-cjk\">丁三夫國形丁三夫國形丁三夫國形</span><span class=\"u-cjk-xe\">𫠠</span><span class=\"u-cjk-xb\">𧑴𨒡</span>"


###
  'so|glyph:劬|cp/fncr:u-cjk/52ac|0'
  'so|glyph:邭|cp/fncr:u-cjk/90ad|0'
  'so|glyph:𠴦|cp/fncr:u-cjk-xb/20d26|0'
  'so|glyph:𤿯|cp/fncr:u-cjk-xb/24fef|0'
  'so|glyph:𧑴|cp/fncr:u-cjk-xb/27474|0'
  'so|glyph:𨒡|cp/fncr:u-cjk-xb/284a1|0'
  'so|glyph:𪚧|cp/fncr:u-cjk-xb/2a6a7|0'
  'so|glyph:𪚫|cp/fncr:u-cjk-xb/2a6ab|0'
  '丁三夫國形丁三夫國形丁三夫國形'
###


#-----------------------------------------------------------------------------------------------------------
@[ "negative tags (demo: how to tag Unicode unassigned codepoints)" ] = ( T ) ->
  probes_and_matchers = [
    [ 0x375, 'u9.0.0 assigned' ]
    [ 0x376, 'u9.0.0 assigned' ]
    [ 0x377, 'u9.0.0 assigned' ]
    [ 0x378, 'unassigned u9.0.0' ]
    [ 0x379, 'unassigned u9.0.0' ]
    [ 0x37a, 'u9.0.0 assigned' ]
    [ 0x37b, 'u9.0.0 assigned' ]
    [ 0x37c, 'u9.0.0 assigned' ]
    [ 0x37d, 'u9.0.0 assigned' ]
    [ 0x37e, 'u9.0.0 assigned' ]
    [ 0x37f, 'u9.0.0 assigned' ]
    [ 0x380, 'unassigned u9.0.0' ]
    [ 0x381, 'unassigned u9.0.0' ]
    [ 0x382, 'unassigned u9.0.0' ]
    [ 0x383, 'unassigned u9.0.0' ]
    [ 0x384, 'u9.0.0 assigned' ]
    [ 0x385, 'u9.0.0 assigned' ]
    [ 0x386, 'u9.0.0 assigned' ]
    [ 0x387, 'u9.0.0 assigned' ]
    [ 0x388, 'u9.0.0 assigned' ]
    [ 0x389, 'u9.0.0 assigned' ]
    [ 0x38a, 'u9.0.0 assigned' ]
    [ 0x38b, 'unassigned u9.0.0' ]
    [ 0x38c, 'u9.0.0 assigned' ]
    [ 0x38d, 'unassigned u9.0.0' ]
    [ 0x38e, 'u9.0.0 assigned' ]
    [ 0x38f, 'u9.0.0 assigned' ]
    [ 0x390, 'u9.0.0 assigned' ]
    [ 0x391, 'u9.0.0 assigned' ]
    [ 0x392, 'u9.0.0 assigned' ]
    [ 0x393, 'u9.0.0 assigned' ]
    ]
  XNCR          = require './xncr'
  ISL           = require 'interskiplist'
  first_cid     = 0x0
  last_cid      = 0x10ffff
  ucps          = require '../data/unicode-9.0.0-codepoints.js'
  cp_intervals  = ISL.intervals_from_points null, ucps.codepoints, ucps.ranges...
  u             = ISL.new()
  ISL.add u, { lo: first_cid, hi: last_cid, tag: 'unassigned u9.0.0', }
  #.........................................................................................................
  for cp_interval in cp_intervals
    { lo, hi, } = cp_interval
    ISL.add u, { lo, hi, tag: '-unassigned assigned', }
  #.........................................................................................................
  for [ probe, matcher, ] in probes_and_matchers
    result  = ( ISL.aggregate u, probe )[ 'tag' ].join ' '
    # chr     = String.fromCodePoint probe
    # debug [ ( hex probe ), result, ]
    T.eq result, matcher
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_base = ( isl ) ->
  ISL           = require 'interskiplist'
  first_cid     = 0x0
  last_cid      = 0x10ffff
  ucps          = require '../data/unicode-9.0.0-codepoints.js'
  cp_intervals  = ISL.intervals_from_points null, ucps.codepoints, ucps.ranges...
  type          = 'layer'
  name          = "#{type}:base-u9.0.0"
  ISL.add isl, { lo: first_cid, hi: last_cid, name, tag: 'unassigned', }
  #.........................................................................................................
  for cp_interval in cp_intervals
    { lo, hi, }   = cp_interval
    type          = 'layer'
    name          = "#{type}:assigned-cps"
    ISL.add isl, { lo, hi, name, tag: '-unassigned assigned', }
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_planes = ( isl ) ->
  ISL           = require 'interskiplist'
  #.........................................................................................................
  add_plane = ( isl, lo, hi, name ) ->
    type        = 'plane'
    name        = "#{type}:#{name}"
    ISL.add isl, { name, lo, hi, }
  #.........................................................................................................
  add_plane isl,   0x0000,   0xffff, 'Basic Multilingual Plane (BMP)'
  add_plane isl,  0x10000,  0x1ffff, 'Supplementary Multilingual Plane (SMP)'
  add_plane isl,  0x20000,  0x2ffff, 'Supplementary Ideographic Plane (SIP)'
  add_plane isl,  0x30000,  0x3ffff, 'Tertiary Ideographic Plane (TIP)'
  add_plane isl,  0xe0000,  0xefffd, 'Supplementary Special-purpose Plane (SSP)'
  add_plane isl,  0xf0000,  0xffffd, 'Private Use Area (PUA)'
  add_plane isl, 0x100000, 0x10fffd, 'Private Use Area (PUA)'
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_planes = ( isl ) ->
  ISL           = require 'interskiplist'
  rsg_registry  = require './character-sets-and-ranges'
  #.........................................................................................................
  for csg, ranges of rsg_registry[ 'names-and-ranges-by-csg' ]
    continue unless csg in [ 'u', 'jzr', ]
    for range in ranges
      short_name              = range[ 'range-name' ]
      rsg                     = range[ 'rsg'        ]
      lo                      = range[ 'first-cid'  ]
      hi                      = range[ 'last-cid'   ]
      type                    = 'plane'
      name                    = "#{type}:#{short_name}"
      ISL.add isl, { lo, hi, name, type, block: short_name, rsg, }
      # # is_cjk                  = is_cjk_rsg rsg
      # tex                     = tex_command_by_rsgs[ rsg ] ? null
      # name                    = "block:#{name}"
      # interval                = { name, lo, hi, rsg, }
      # interval[ 'tex' ]       = tex if tex?
      # intervals_by_rsg[ rsg ] = interval
      # ISL.add u, interval
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_areas = ( isl ) ->
  ISL           = require 'interskiplist'
  #.........................................................................................................
  ### TAINT externalize data ###
  source = """
  # The Unicode Standard, V9.0.0, p49
  # Figure 2-14. Allocation on the BMP
  0000-00FF ASCII & Latin-1 Compatibility Area
  0100-058F General Scripts Area
  0590-08FF General Scripts Area (RTL)
  0900-1FFF General Scripts Area
  2000-2BFF Punctuation and Symbols Area
  2C00-2DFF General Scripts Area
  2E00-2E7F Supplemental Punctuation Area
  2E80-33FF CJK Miscellaneous Area
  3400-9FFF CJKV Unified Ideographs Area
  A000-ABFF General Scripts Area (Asia & Africa)
  AC00-D7FF Hangul Syllables Area
  D800-DFFF Surrogate Codes
  E000-F8FF Private Use Area (PUA)
  F900-FFFF Compatibility and Specials Area
  # The Unicode Standard, V9.0.0, p51
  # Figure 2-15. Allocation on Plane 1
  10000-107FF General Scripts Area
  10800-10FFF General Scripts Area (RTL)
  11000-11FFF General Scripts Area
  12000-15FFF Cuneiform & Hieroglyphic Area
  16000-16FFF General Scripts Area
  17000-1BBFF Ideographic Scripts Area
  1BC00-1CFFF General Scripts Area
  1D000-1E7FF Symbols Area
  1E800-1EFFF General Scripts Area (RTL)
  1F000-1FFFF Symbols Area
  """
  #.........................................................................................................
  for line in source.split '\n'
    line = line.trim()
    continue if line.startsWith '#'
    [ _, lo, hi, short_name, ]  = line.match /^([0-9a-fA-F]{4,5})-([0-9a-fA-F]{4,5}) (.+)$/
    lo                          = parseInt lo, 16
    hi                          = parseInt hi, 16
    type                        = 'area'
    name                        = "#{type}:#{short_name}"
    ISL.add isl, { lo, hi, name, type, area: short_name, }
    # ISL.add_range u, lo, hi, { type, name, lo, hi, }
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_styles = ( isl ) ->
  ISL                 = require 'interskiplist'
  XNCR                = require './xncr'
  mkts_options        = require '../../mingkwai-typesetter/options'
  tex_command_by_rsgs = mkts_options[ 'tex' ][ 'tex-command-by-rsgs' ]
  #.........................................................................................................
  lo          = 0x000000
  hi          = 0x10ffff
  tex         = tex_command_by_rsgs[ 'fallback' ]
  name        = "style:fallback"
  ISL.add isl, { name, lo, hi, tex, }
  #.........................................................................................................
  for glyph, style of mkts_options[ 'tex' ][ 'glyph-styles' ]
    glyph       = XNCR.normalize_glyph  glyph
    rsg         = XNCR.as_rsg           glyph
    cid         = XNCR.as_cid           glyph
    lo = hi     = cid
    cid_hex     = hex cid
    name        = "glyph-#{cid_hex}"
    name        = "style:#{name}"
    ISL.add isl, { name, lo, hi, rsg, style, }
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_cjk_tags = ( isl ) ->
  ISL = require 'interskiplist'
  #.........................................................................................................
  tag_by_rsgs =
    'u-cjk':          [ 'cjk', ]
    'u-halfull':      [ 'cjk', ]
    'u-cjk-xa':       [ 'cjk', ]
    'u-cjk-xb':       [ 'cjk', ]
    'u-cjk-xc':       [ 'cjk', ]
    'u-cjk-xd':       [ 'cjk', ]
    'u-cjk-xe':       [ 'cjk', ]
    'u-cjk-xf':       [ 'cjk', ]
    'u-cjk-cmpi1':    [ 'cjk', ]
    'u-cjk-cmpi2':    [ 'cjk', ]
    'u-cjk-rad1':     [ 'cjk', ]
    'u-cjk-rad2':     [ 'cjk', ]
    'u-cjk-sym':      [ 'cjk', ]
    'u-cjk-strk':     [ 'cjk', 'stroke', ]
    'u-cjk-kata':     [ 'cjk', 'kana', 'katakana', ]
    'u-cjk-hira':     [ 'cjk', 'kana', 'hiragana', ]
    'u-hang-syl':     [ 'cjk', 'hangeul', ]
    'u-cjk-enclett':  [ 'cjk', 'enclosed', ]
  #.........................................................................................................
  rsg_registry  = require './character-sets-and-ranges'
  ranges        = rsg_registry[ 'names-and-ranges-by-csg' ][ 'u' ]
  for rsg, tag of tag_by_rsgs
    continue unless ( range = ranges[ rsg ] )?
    lo  = range[ 'first-cid'  ]
    hi  = range[ 'last-cid'   ]
    ISL.add isl, { lo, hi, tag, }
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_add_sims = ( isl ) ->
  ISL                 = require 'interskiplist'
  #.........................................................................................................
  return isl

#-----------------------------------------------------------------------------------------------------------
@[ "Unicode demo" ] = ( T ) ->
  ISL           = require 'interskiplist'
  u             = ISL.new()
  #.........................................................................................................
  ### General data ###
  @_Unicode_demo_add_base       u
  @_Unicode_demo_add_planes     u
  @_Unicode_demo_add_areas      u
  #.........................................................................................................
  ### CJK-specific data ###
  @_Unicode_demo_add_cjk_tags   u
  #.........................................................................................................
  ### Jizura-specific data ###
  @_Unicode_demo_add_sims       u
  #.........................................................................................................
  ### Mingkwai-specific data ###
  @_Unicode_demo_add_styles     u
  #.........................................................................................................
  info ISL.aggregate u, '《'
  help ISL.aggregate u, '《', { name: 'list', tex: 'list', style: 'list', type: 'skip', }
  #.........................................................................................................
  return null

#-----------------------------------------------------------------------------------------------------------
@_Unicode_demo_show_sample = ( isl ) ->
  XNCR = require './xncr'
  #.........................................................................................................
  # is_cjk_rsg    = (   rsg ) -> rsg in mkts_options[ 'tex' ][ 'cjk-rsgs' ]
  # is_cjk_glyph  = ( glyph ) -> is_cjk_rsg XNCR.as_rsg glyph
  #.........................................................................................................
  for glyph in XNCR.chrs_from_text "helo äöü你好𢕒𡕴𡕨𠤇𫠠𧑴𨒡《》【】&jzr#xe100;🖹"
    cid     = XNCR.as_cid glyph
    cid_hex = hex cid
    # debug glyph, cid_hex, find_id_text u, cid
    descriptions = ISL.find_entries_with_all_points u, cid
    urge glyph, cid_hex
    for description in descriptions
      [ type, _, ] = ( description[ 'name' ] ? '???/' ).split ':'
      help ( CND.grey type + '/' ) + ( CND.steel 'interval' ) + ': ' + ( CND.yellow "#{hex description[ 'lo' ]}-#{hex description[ 'hi' ]}" )
      for key, value of description
        continue if key in [ 'lo', 'hi', 'id', ]
        help ( CND.grey type + '/' ) + ( CND.steel key ) + ': ' + ( CND.yellow value )
    # urge glyph, cid_hex, JSON.stringify ISL.find_all_ids    u, cid
    # info glyph, cid_hex, JSON.stringify ISL.find_any_ids    u, cid
  #.........................................................................................................
  return null


############################################################################################################
unless module.parent?
  # debug '0980', JSON.stringify ( Object.keys @ ), null, '  '
  include = [
    # "test # 1"
    # "test # 2"
    # "test # 3"
    # "test # 4"
    # "test # 5"
    # "test # 6"
    # "test # 7"
    # "test # 8"
    # "test # 9"
    # "test # 10"
    # "test # 11"
    # "test # 12"
    # "test # 13"
    # "test # 14"
    # "test # 15"
    # "test # 16"
    # "test # 17"
    # "test # 18"
    # "test # 19"
    # "test # 20"
    # "test # 21"
    # "test # 22"
    # "test # 22a"
    # "test # 22b"
    # "test # 23"
    # "test # 24"
    # "test # 25"
    # "test # 26"
    # "test # 27"
    # "test # 28"
    # "test # 29"
    # "test # 30"
    # "test # 31"
    # "test # 32"
    # "test # 33"
    # "test # 34"
    # "test # 35"
    # "test # 36"
    # "test # 37"
    # "test # 38"
    # "test # 39"
    # "test # 40"
    # "test # 41"
    # "test # 42"
    # "test # 43"
    # "test # 44"
    # "test # 45"
    # "test # 46"
    # "test # 47"
    # "test # 48"
    # "test # 49"
    # "test # 50"
    # "test # 51"
    # "test # 52"
    # "test # 53"
    # "test # 54"
    # "test # 55"
    # "test # 56"
    # "test # 57"
    # "test # 58"
    # "test # 59"
    # "test # 60"
    # "test # 61"
    # "test # 62"
    # "test # 63"
    # "test # 64"
    # "test # 65"
    # "test # 66"
    # "test # 67"
    # "test # 68"
    # "test # 69"
    # "test # 70"
    # "test # 71"
    # "test # 72"
    # "test # 73"
    # "test # 74"
    # "test # 75"
    # "test # 76"
    # "test # 77"
    # "test # 78"
    # "test # 79"
    # "test # 80"
    # "test # 81"
    # "test # 82"
    # "test # 83"
    # "test # 84"
    # "test # 85"
    # "test # 86"
    # "test # 87"
    # "test # 88"
    # "test # 89"
    # "test # 90"
    # "test # 91"
    # "test # 92"
    # "test # 93"
    # "test # 94"
    # "test # 95"
    # "test # 96"
    # "test # 97"
    # "test # 98"
    # "test # 99"
    # "test # 100"
    # "test # 101"
    # "test # 102"
    # "test # 103"
    # "test # 104"
    # "test # 105"
    # "test # 106"
    # "test # 107"
    # "test # 108"
    # "test # 109"
    # "test # 110"
    # "test # 111"
    # "test # 112"
    # "test # 113"
    # "test # 114"
    # "test # 115"
    # "test # 116"
    # "test # 117"
    # "test # 118"
    # "test # 119"
    # "test # 120"
    # "test # 121"
    # "test # 122"
    # "test # 123"
    # "test # 124"
    # "test # 125"
    # "test Unicode 8 / CJK Extension E"
    # "test # 200"
    # "test # 201"
    # "negative tags (demo: how to tag Unicode unassigned codepoints)"
    "Unicode demo"
    ]
  # @_prune()
  # @_main()

  # XNCR = require './xncr'
  # text = 'A-&#x3004;-&jzr#xe100;-&morohashi#x56;-Z'
  # debug rpr ( XNCR.jzr_as_uchr chr for chr in XNCR.chrs_from_text text ).join ''
  # debug rpr XNCR.normalize_text text
  # debug JSON.stringify Object.keys @

  @[ "Unicode demo" ]()




