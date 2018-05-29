
if( typeof module !== 'undefined' )
require( '..' );

var _ = wTools;

var logger = new _.Logger();

logger.logUp( 'up' );
logger.log( 'log' );
logger.log( 'log\nlog' );
logger.log( 'log','a','b' );
logger.log( 'log\nlog','a','b' );
logger.log( 'log\nlog','a\n','b\n' );
logger.logDown( 'down' );
