( function _Chaining_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Chaining.test.s

*/

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  require( '../object/printer/printer/Logger.s' );
  require( '../../../../wTools/staging/abase/component/StringTools.s' );

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

var _escaping = function ( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

var log = function()
{
  return arguments;
}

var fakeConsole =
{
  log : _.routineJoin( console,log ),
  error : _.routineJoin( console,console.error ),
  info : _.routineJoin( console,console.info ),
  warn : _.routineJoin( console,console.warn ),
}

var levelsTest = function( test )
{
  var logger = new wLogger( { output : fakeConsole });

  var l = new wLogger( { output : logger } );

  logger._dprefix = '-';
  l._dprefix = '-';

  test.description = 'case1 : ';
  logger.up( 2 );
  var got = l.log( 'abc' );
  var expected = [ '--abc' ]
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2 : add 2 levels, first logger level must be  2';
  l.up( 2 );
  var got = logger.log( 'abc' );
  var expected = [ '--abc' ]
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3 : current levels of loggers must be equal';
  var got = l.level;
  var expected = logger.level;
  test.identical( got, expected );

  test.description = 'case4 : logger level - 2, l level - 4, text must have level 6 ';
  l.up( 2 );
  var got = l.log( 'abc' );
  var expected = [ '------abc' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5 : zero level';
  l.down( 4 );
  logger.down( 2 );
  var got = l.log( 'abc' );
  var expected = [ "abc" ];
  test.identical( _escaping( got ), _escaping( expected ) );


  if( Config.debug )
  {
    test.description = 'level cant be less then zero';
    test.shouldThrowError( function( )
    {
      l.down( 10 );
    })
  }

}

//

var chaining = function( test )
{
  var _onWrite = function( args ) { got.push( args[ 0 ] ) };

  test.description = 'case1: l1 must get two messages';
  var got = [];
  var l1 = new wLogger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new wLogger( { output : l1 } );
  l2.log( '1' );
  l2.log( '2' );
  var expected = [ '1', '2' ];
  test.identical( got, expected );

  test.description = 'case2: multiple loggers';
  var got = [];
  var l1 = new wLogger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new wLogger( { output : l1, onWrite : _onWrite } );
  var l3 = new wLogger( { output : l2 } );
  l2.log( 'l2' );
  l3.log( 'l3' );
  var expected = [ 'l2', 'l2', 'l3', 'l3' ];
  test.identical( got, expected );

  test.description = 'case3: multiple loggers';
  var got = [];
  var l1 = new wLogger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new wLogger( { output : l1, onWrite : _onWrite } );
  var l3 = new wLogger( { output : l2, onWrite : _onWrite } );
  var l4 = new wLogger( { output : l3, onWrite : _onWrite } );
  l4.log( 'l4' );
  l3.log( 'l3' );
  l2.log( 'l2' );
  var expected =
  [
    'l4', 'l4', 'l4', 'l4',
    'l3', 'l3', 'l3',
    'l2', 'l2',
  ];
  test.identical( got, expected );
}

//

var chainingParallel = function( test )
{
  var _onWrite = function( args ) { got.push( args[ 0 ] ) };

  test.description = 'case1: 1 -> *';
  var got = [];
  var l1 = new wLogger( { onWrite : _onWrite  } );
  var l2 = new wLogger( { onWrite : _onWrite  } );
  var l3 = new wLogger( { onWrite : _onWrite  } );
  var l4 = new wLogger();
  l4.outputTo( l3, { combining : 'append' } );
  l4.outputTo( l2, { combining : 'append' } );
  l4.outputTo( l1, { combining : 'append' } );

  l4.log( 'msg' );
  var expected = [ 'msg','msg','msg' ];
  test.identical( got, expected );

  test.description = 'case2: * -> 1';
  var got = [];
  var l1 = new wLogger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new wLogger();
  var l3 = new wLogger();
  var l4 = new wLogger();
  l2.outputTo( l1, { combining : 'rewrite' } );
  l3.outputTo( l1, { combining : 'rewrite' } );
  l4.outputTo( l1, { combining : 'rewrite' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );


}

//

var outputTo = function( test )
{

  test.description = 'output already exist';
  var l = new wLogger();
  l.outputTo( logger, { combining : 'append' } );
  var got = l.outputTo( logger, { combining : 'append' } );
  var expected = false;
  test.identical( got, expected );

  test.description = 'output already exist, combining : rewrite';
  var l = new wLogger();
  l.outputTo( logger, { combining : 'append' } );
  var got = l.outputTo( logger, { combining : 'rewrite' } );
  var expected = true;
  test.identical( got, expected );


  if( Config.debug )
  {
    test.description = 'no args';
    test.shouldThrowError( function()
    {
      logger.outputTo();
    });

    test.description = 'output is not a Object';
    test.shouldThrowError( function()
    {
      logger.outputTo( 'output', { combining : 'rewrite' } );
    });

    test.description = 'not allowed combining mode';
    test.shouldThrowError( function()
    {
      logger.outputTo( console, { combining : 'mode' } );
    });

    test.description = 'not allowed leveling mode';
    test.shouldThrowError( function()
    {
      logger.outputTo( console, { combining : 'rewrite', leveling : 'mode' } );
    });
  }
}

//

var unOutputTo = function( test )
{
  var _onWrite = function( args ) { got.push( args[ 0 ] ) };

  test.description = 'case1 delete l1 from l2 outputs, l2 still have one output';
  var got = [];
  var l1 = new wLogger( { onWrite : _onWrite  } );
  var l2 = new wLogger( { onWrite : _onWrite  } );
  l2.outputTo( l1, { combining : 'append' } );
  l2.unOutputTo( l1 )
  l2.log( 'msg' );
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.description = 'case2 delete l1 from l2 outputs, no msg transfered';
  var got = [];
  var l1 = new wLogger( { onWrite : _onWrite  } );
  var l2 = new wLogger();
  l2.outputTo( l1, { combining : 'rewrite' } );
  l2.unOutputTo( l1 );
  l2.log( 'msg' )
  var expected = [];
  test.identical( got, expected );

  test.description = 'case3: delete l1 from l2 outputs';
  var got = [];
  var l1 = new wLogger( { onWrite : _onWrite  } );
  var l2 = new wLogger( { onWrite : _onWrite  } );
  var l3 = new wLogger();
  l2.outputTo( l1, { combining : 'append' } );
  l3.outputTo( l2, { combining : 'append' } );
  l2.unOutputTo( l1 );
  l3.log( 'msg' )
  var expected = [ 'msg' ];
  test.identical( got, expected );
}

var Proto =
{

  name : 'Chaining test',

  tests :
  {

    levelsTest : levelsTest,
    chaining : chaining,
    chainingParallel : chainingParallel,
    outputTo : outputTo,
    unOutputTo : unOutputTo

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
