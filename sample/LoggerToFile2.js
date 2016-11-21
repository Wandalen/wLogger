
if( typeof module !== 'undefined' )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
  require('../../wTools/staging/abase/component/StringTools.s')
  require( '../staging/abase/object/printer/printer/LoggerToFile.s' );
}

var _ = wTools;

var logger = new wLogger();
var loggerToFile = new wLoggerToFile({ outputPath : __dirname +'/out.txt' });

logger.outputTo( loggerToFile, { combining : 'append' } );
logger.log( 'message' );
