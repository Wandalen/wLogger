( function _LoggerToJsStructure_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/LoggerToJstructure.test.s

*/

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  require( '../object/printer/printer/Logger.s' );
  require( '../../../../wTools/staging/abase/component/StringTools.s' );
  require( '../object/printer/printer/LoggerToJstructure.s' );

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
var Self = {};

//

var toJsStructure = function( test )
{
  test.description = 'case1';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite' } );
  l.log( 'msg' );
  var got = loggerToJstructure.structure;
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.description = 'case2';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite' } );
  l._dprefix = '*';
  l.up( 2 );
  l.log( 'msg' );
  var got = loggerToJstructure.structure;
  var expected = [ '**msg' ];
  test.identical( got, expected );

  test.description = 'case3';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite', leveling : 'delta' } );
  l._dprefix = '*';
  l.up( 2 );
  l.log( 'msg' );
  l.down( 1 );
  l.log( 'msg' );
  var got = loggerToJstructure.structure;
  var expected =
  [
    [
       [ '**msg' ],
       '*msg'
    ]
  ];
  test.identical( got, expected );
}
//

var Proto =
{

  name : 'LoggerToJstructure test',

  tests :
  {

   toJsStructure : toJsStructure

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
