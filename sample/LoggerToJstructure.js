
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
//var logger = new wLoggerToJstructure({ output : null });
var logger = new wLoggerToJstructure();

console.log( 'outputData',logger.outputData );

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.up( 2 );
logger.log( 'a2\nb2' );

console.log( 'outputData',logger.outputData );

// a1
// b1
// a2
// b2
