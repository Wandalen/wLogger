
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/dwtools/abase/printer/printer/Logger.s' );
}

var _ = wTools;

var logger = new wLogger();

logger.logUp( 'up' );
logger.log( 'log' );
logger.log( 'log\nlog' );
logger.log( 'log','a','b' );
logger.log( 'log\nlog','a','b' );
logger.log( 'log\nlog','a\n','b\n' );
logger.logDown( 'down' );
