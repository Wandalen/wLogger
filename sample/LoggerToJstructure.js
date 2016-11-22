
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
var logger = new wLoggerToJstructure({ output : null });

console.log( 'outputData',logger.outputData );

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.log( 'c1' );
logger.up( 2 );
logger.log( 'a2\nb2' );
logger.log( 'c2' );

console.log( 'outputData',logger.outputData );
console.log( logger.toJson() );

// [
//   [
//     [ "a2\nb2", "c2" ]
//   ],
//   "a1\nb1",
//   "c1"
// ]
