
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
var l1 = new wLoggerToFile({ outputPath : 'out1.log' });
var l2 = new wLoggerToFile({ outputPath : 'out2.log' });

console.log( 'l1.outputPath',l1.outputPath );
console.log( 'l2.outputPath',l2.outputPath );

logger.outputTo( l1,{ combining : 'append' } );
logger.outputTo( l2,{ combining : 'append' } ); 

logger._dprefix = '~';
l1._dprefix = '+';
l2._dprefix = '-';

logger.up( 1 );
l1.up( 2 );
l2.up( 3 );

logger.log( 'aa\nbb' );
l1.log( 'cc\ndd' );
l2.log( 'ee\nff' );
