( function _LoggerToFile_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/LoggerToFile.test.s

*/

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  require( '../object/printer/printer/Logger.s' );
  require( '../../../../wTools/staging/abase/component/StringTools.s' );
  require( '../object/printer/printer/LoggerToFile.s' );

  try
  {
    require( '../../../../wTesting/staging/abase/object/Testing.debug.s' );
  }
  catch ( err )
  {
    require ( 'wTesting' );
  }

}

var _ = wTools;
var File = _.FileProvider.HardDrive();
var Self = {};

//

var toFile = function( test )
{
  File.directoryMake({ pathFile : __dirname + '/tmp', sync : 1 })
  test.description = 'case1';
  try
  {
    File.fileDeleteAct
    ({
      pathFile : __dirname +'/tmp/out.txt',
      sync : 1
    });
  } catch( err) {}

  var fl = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger();
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( '123' );
  var got = File.fileReadAct
  ({
    pathFile : __dirname +'/tmp/out.txt',
    sync : 1
  });
  var expected = '123';
  test.identical( got, expected );
}
//

var Proto =
{

  name : 'LoggerToFile test',

  tests :
  {

   toFile : toFile

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
