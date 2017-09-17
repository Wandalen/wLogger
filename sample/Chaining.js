
if( typeof module !== 'undefined' )
require( 'wLogger' );

var _ = wTools;
var l = new wLogger({ output : logger });

logger._dprefix = '-';
l._dprefix = '-';

logger.up( 2 );
l.up( 1 );

logger.log( 'aaa\nbbb' );
l.log( 'ccc\nddd' );

// --aaa
// --bbb
// ---ccc
// ---ddd
