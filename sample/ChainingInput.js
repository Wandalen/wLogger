
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
}

var _ = wTools;
var l1 = new wLogger();
var l2 = new wLogger();

l1.inputFrom( logger );
l2.inputFrom( logger );

logger._dprefix = '~';
l1._dprefix = '+';
l2._dprefix = '-';

logger.up( 1 );
l1.up( 2 );
l2.up( 3 );

logger.log( 'aa\nbb' );
l1.log( 'cc\ndd' );
l2.log( 'ee\nff' );

// ~aa
// ~bb
// ++~aa
// ++~bb
// ---~aa
// ---~bb
// ++cc
// ++dd
// ---ee
// ---ff
