
if( typeof module !== 'undefined' )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
  require('../../wTools/staging/abase/component/StringTools.s')
}

var _ = wTools;

var logger = new wLogger();

logger.log( 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ) );
logger.log( _.strColor.bg( 'red' + _.strColor.bg( 'blue','blue' ) + 'red','red' ) );
logger.log( '#background : red#red#background : blue#blue#background : default#red#background : default#' );

logger.log( '#background : red#' );
logger.log( 'red' );
logger.log( '#background : default#' );
logger.log( 'default' );

// logger.log( '#foreground : red#this is red text' );
// logger.log( 'this is too#foreground : default#' );
// logger.log( '#background : green#green background' );
// logger.log( 'this is too#background : default#' );
