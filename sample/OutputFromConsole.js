
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/dwtools/abase/printer/top/Logger.s' );
}

var _ = wTools;
var l1 = new wLogger({ output : null });
var l2 = new wLogger({ output : null });

l1.inputFrom( console );
l2.inputFrom( console );

l1._dprefix = '+';
l2._dprefix = '-';

l1.up( 2 );
l2.up( 3 );

console.log( 'aa\nbb' );
l1.log( 'cc\ndd' );
l2.log( 'ee\nff' );
