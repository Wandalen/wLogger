
if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );
//require( 'wLogger' );

var _ = wTools;
var l1 = new wLogger();
l1.outputTo( console, { combining : 'append' } );
console.log( l1.outputs.length );
console.log( l1.outputs[ 0 ].output === l1.outputs[ 1 ].output  )
