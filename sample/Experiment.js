
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
require('../../wTools/staging/abase/component/StringTools.s')

var _ = wTools;

var logger = new wLogger();

logger.log('some #text',_.strColorForeground( 'text','red' ),_.strColorBackground( 'text','yellow' ) )
