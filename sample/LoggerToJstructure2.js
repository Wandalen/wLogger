
if( typeof module !== 'undefined' )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
  require('../../wTools/staging/abase/component/StringTools.s')
  require( '../staging/abase/object/printer/printer/LoggerToJstructure.s' );
}

var _ = wTools;

var logger = new wLogger();

var loggerToJstructure = new wLoggerToJstructure();
logger.outputTo( loggerToJstructure, { combining : 'rewrite', leveling : 'delta' } );
logger._dprefix = '*'
logger.up( 2 );
logger.log( 'message' );

console.log( loggerToJstructure.toJson() );
