
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
var logger = new wLoggerToFile();

console.log( 'outputPath',logger.outputPath );

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.up( 2 );
logger.log( 'a2\nb2' );

// --aaa
// --bbb
// ---ccc
// ---ddd
