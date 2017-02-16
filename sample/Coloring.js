
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
}

var _ = wTools;

var logger = new wLogger();

var fg = _.strColor.fg;
var bg = _.strColor.bg;

logger.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
logger.log( fg( 'red text', 'ff0000' ), bg( 'yellow background', 'ffff00' ) );

logger.log( fg( '\nred text' + fg( 'yellow text', 'yellow' ) + 'red text', 'red' ) );
logger.log( bg( '\nred background' + bg( 'yellow background', 'yellow' ) + 'red background', 'red' ) );

logger.log( 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ) );
logger.log( _.strColor.bg( 'red' + _.strColor.bg( 'blue','blue' ) + 'red','red' ) );
logger.log( '#background : red#red#background : blue#blue#background : default#red#background : default#' );

logger.log( '#background : red#' );
logger.log( 'red' );
logger.log( '#background : default#' );
logger.log( 'default' );

logger.log( '#foreground : yellow##background : red#' );
logger.log( 'yellow on red' );
logger.log( '#foreground : default##background : default#' );
logger.log( 'default text' );

logger.log( '#foreground : red#this is red text' );
logger.log( 'this is too#foreground : default#' );
logger.log( '#background : green#green background' );
logger.log( 'this is too#background : default#' );
