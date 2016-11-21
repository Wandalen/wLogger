
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
//var logger = new wLoggerToFile({ output : null });
var logger = new wLoggerToFile();
logger.output = null;

console.log( 'outputPath',logger.outputPath );

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.up( 2 );
logger.log( 'a2\nb2' );

// a1
// b1
// a2
// b2
