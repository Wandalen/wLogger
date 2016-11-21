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
  var loggerToJstructure  = new wLoggerToJstructure();
  loggerToJstructure.log( '123' );
  var got = loggerToJstructure.outputData;
  var expected = [ '123' ];
  test.identical( got, expected );

  test.description = 'case2';
  var loggerToJstructure  = new wLoggerToJstructure();
  loggerToJstructure.up( 2 );
  loggerToJstructure.log( '123' );
  var got = loggerToJstructure.outputData;
  var expected =
  [
    [
      [ '123' ]
    ]
  ];
  test.identical( got, expected );

  test.description = 'case3';
  var loggerToJstructure  = new wLoggerToJstructure();
  loggerToJstructure.log();
  var got = loggerToJstructure.outputData;
  var expected = [];
  test.identical( got, expected );

  test.description = 'case4';
  var loggerToJstructure  = new wLoggerToJstructure();
  loggerToJstructure.log( '321');
  var got = loggerToJstructure.toJson();
  var expected = '[ "321" ]';
  test.identical( got, expected );

}

//

var chaining = function( test )
{
  test.description = 'case1';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite' } );
  l.log( 'msg' );
  var got = loggerToJstructure.outputData;
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.description = 'case2';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite' } );
  l.up( 2 );
  l.log( 'msg' );
  var got = loggerToJstructure.outputData;
  var expected = [ '    msg' ];
  test.identical( got, expected );

  test.description = 'case3';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite' } );
  loggerToJstructure.up( 2 );
  l.log( 'msg' );
  var got = loggerToJstructure.outputData;
  var expected =
  [
    [
      [ 'msg' ]
    ]
  ];
  test.identical( got, expected );

  test.description = 'case4: Logger->LoggerToJstructure, leveling on';
  var loggerToJstructure = new wLoggerToJstructure();
  var l = new wLogger();
  l.outputTo( loggerToJstructure, { combining : 'rewrite', leveling : 'delta' } );
  l.log( 'msg' );
  l.up( 2 );
  l.log( 'msg2' );
  var got = loggerToJstructure.outputData;
  var expected =
  [
    [
       [ '    msg2' ],
    ],
    'msg'
  ];
  test.identical( got, expected );

  test.description = 'case5 LoggerToJstructure->LoggerToJstructure';
  var loggerToJstructure = new wLoggerToJstructure();
  var loggerToJstructure2 = new wLoggerToJstructure();
  loggerToJstructure.outputTo( loggerToJstructure2, { combining : 'rewrite' } );
  loggerToJstructure.log( '1' );
  loggerToJstructure2.log( '2' );
  var got =
  [
    loggerToJstructure.outputData,
    loggerToJstructure2.outputData
  ];

  var expected =
  [
    [ '1' ],
    [ '1', '2' ]
  ];
  test.identical( got, expected );

  test.description = 'case6: LoggerToJstructure->Logger->LoggerToJstructure';
  var loggerToJstructure = new wLoggerToJstructure();
  var loggerToJstructure2 = new wLoggerToJstructure();
  var l = new wLogger();
  loggerToJstructure.outputTo( l, { combining : 'rewrite' } );
  l.outputTo( loggerToJstructure2, { combining : 'rewrite' } );
  l._prefix = '*';
  loggerToJstructure.log( '1' );
  var got =
  [
    loggerToJstructure.outputData,
    loggerToJstructure2.outputData
  ];

  var expected =
  [
    [ '1' ],
    [ '*1' ]
  ];
  test.identical( got, expected );

}

//

var Proto =
{

  name : 'LoggerToJstructure test',

  tests :
  {

   toJsStructure : toJsStructure,
   chaining : chaining

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
