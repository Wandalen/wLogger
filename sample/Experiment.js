
if( typeof module !== 'undefined' )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
  require('../../wTools/staging/abase/component/StringTools.s')
}

var _ = wTools;

var logger = new wLogger();

// logger.log( 'no color text',_.strColor.fg( 'red text','red' ),_.strColor.bg( 'yellow background','yellow' ) );
//
// logger.log( '#foreground : red#this is red text' );
// logger.log( 'this is too#foreground : default#' );
// logger.log( '#background : green#green background' );
// logger.log( 'this is too#background : default#' );
// logger.log( 'no color text' );
logger.log( _.strColor.bg('yellow bg'+ _.strColor.bg( 'green bg' ,'green') + 'yellow bg', 'yellow' ) );
