
if( typeof module !== 'undefined' )
require( 'wLogger' );

var _ = wTools;
var logger = new wLoggerToFile();

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.up( 2 );
logger.log( 'a2\nb2' );

// --aaa
// --bbb
// ---ccc
// ---ddd
