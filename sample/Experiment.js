
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
require('../../wTools/staging/abase/component/StringTools.s')

var _ = wTools;

var logger = new wLogger();

logger.log( 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ) )
logger.log( '#foreground : red#this is red text' );
logger.log( 'this is too' );
