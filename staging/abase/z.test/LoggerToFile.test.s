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

var _deleteFile = function( pathFile )
{
  try
  {
    File.fileDeleteAct
    ({
      pathFile : pathFile,
      sync : 1
    });
  } catch( err) {}
}

//

var _readFromFile = function( pathFile )
{
  return File.fileReadAct
  ({
    pathFile : pathFile,
    sync : 1
  });
}

var toFile = function( test )
{
  File.directoryMake({ pathFile : __dirname + '/tmp', sync : 1 });

  test.description = 'case1';
  _deleteFile( __dirname +'/tmp/out.txt' );
  var fl = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger();
  l.outputTo( fl, { combining : 'rewrite' } );
  l.log( '123' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = '123\n';
  test.identical( got, expected );

  test.description = 'case2';
  _deleteFile( __dirname +'/tmp/out.txt' );
  var fl = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger();
  l.outputTo( fl, { combining : 'rewrite' } );
  l._dprefix = '*';
  l.up( 2 );
  l.log( 'msg' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = '**msg\n';
  test.identical( got, expected );
}

//

var chaining = function( test )
{
  var _onWrite = function( args ) { got.push( args[ 0 ] ) };

  test.description = 'case1: Logger->LoggerToFile';
  var loggerToFile = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger({ output : loggerToFile });
  _deleteFile( __dirname +'/tmp/out.txt' );
  l.log( 'msg' );
  var got = _readFromFile( __dirname +'/tmp/out.txt' );
  var expected = 'msg\n';
  test.identical( got, expected );

  test.description = 'case2: Logger->LoggerToFile->Logger';
  var got = [];
  var loggerToFile = new wLoggerToFile({ outputPath : __dirname +'/tmp/out.txt' });
  var l = new wLogger({ output : loggerToFile });
  var l2 = new wLogger({ onWrite : _onWrite });
  loggerToFile.outputTo( l2, { combining : 'rewrite' } );
  l.log( 'msg' );
  var expected = [ 'msg' ]
  test.identical( got, expected );

  test.description = 'case3: LoggerToFile->LoggerToFile';
  var path1 = __dirname +'/tmp/out.txt';
  var path2 = __dirname +'/tmp/out2.txt';
  _deleteFile( path1 );
  _deleteFile( path2 );
  var loggerToFile = new wLoggerToFile({ outputPath : path1 });
  var loggerToFile2 = new wLoggerToFile({ outputPath : path2 });
  loggerToFile.outputTo( loggerToFile2, { combining : 'rewrite' } );
  loggerToFile.log( 'msg' );
  var got = [ _readFromFile( path1 ), _readFromFile( path2 ) ];
  var expected = [ 'msg\n', 'msg\n' ]
  test.identical( got, expected );
}

var Proto =
{

  name : 'LoggerToFile test',

  tests :
  {

   toFile : toFile,
   chaining : chaining

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
