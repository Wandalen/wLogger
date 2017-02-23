
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/abase/printer/printer/Logger.s' );
}

var _ = wTools;

var l = new wLogger({ output : null });
l.inputFrom( console );
console.log( l.hasInput( console ) ); //returns true

var l1 = new wLogger();
var l2 = new wLogger();
var l3 = new wLogger();
l3.inputFrom( l2 );
l2.inputFrom( l1 );
console.log( l3._hasInput( l1 ) );//returns true

var l1 = new wLogger({ output : null });
var l2 = new wLogger();
l1.outputTo( l2 );
console.log( l1.hasOutput( l2 ) ); //returns true

var l1 = new wLogger({ output : null });
var l2 = new wLogger({ output : null });
var l3 = new wLogger();
l1.outputTo( l2 );
l2.outputTo( l3 );
console.log( l1._hasOutput( l3 ) );//returns true
