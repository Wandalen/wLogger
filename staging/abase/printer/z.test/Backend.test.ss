( function _Backend_test_ss_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Backend.test.s

*/

if( typeof module !== 'undefined' )
{

  require( '../printer/Logger.s' );

  var _ = wTools;

  _.include( 'wTesting' );

}

var _ = wTools;
var Parent = wTools.Testing;
var Self = {};

//

function simplest( test )
{

  test.description = 'simple1';

  var logger = new wLogger();

  logger.logUp( 'up' );
  logger.log( 'log' );
  logger.log( 'log\nlog' );
  logger.log( 'log','a','b' );
  logger.log( 'log\nlog','a','b' );
  logger.log( 'log\nlog','a\n','b\n' );
  logger.logDown( 'down' );

  test.identical( 1,1 );

}

//

var _escaping = function ( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function colorConsole( test )
{

  // function log()
  // {
  //   return arguments;
  // }
  //
  // var fakeConsole =
  // {
  //   log : _.routineJoin( console,log ),
  //   error : _.routineJoin( console,console.error ),
  //   info : _.routineJoin( console,console.info ),
  //   warn : _.routineJoin( console,console.warn ),
  // }

  var got;

  var onWrite = function ( args ){ got = args  };

  var logger = new wLogger({ output : null, onWrite : onWrite });


  test.description = 'case1: red text';
  logger.log( _.strColor.fg( 'text', 'red') );
  var expected = '\u001b[31mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2: yellow background';
  logger.log( _.strColor.bg( 'text', 'yellow') );
  var expected = '\u001b[43mtext\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3: red text on yellow background';
  logger.log( _.strColor.bg( _.strColor.fg( 'text', 'red'), 'yellow') );
  var expected = '\u001b[43m\u001b[31mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case4: yellow text on red background  + not styled text';
  logger.log( 'text' + _.strColor.fg( _.strColor.bg( 'text', 'red'), 'yellow') + 'text' );
  var expected = 'text\u001b[33m\u001b[41mtext\u001b[49m\u001b[39mtext';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5: unknown color ';
  logger.log( _.strColor.fg( 'text', 'xxx') );
  var expected = '\u001b[39mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case6: text without styles  ';
  logger.log( 'text' );
  var expected = 'text';
  test.identical( got, expected );

}

//

var Proto =
{

  name : 'Backend test',

  tests :
  {

    simplest : simplest,
    colorConsole : colorConsole

  },

  /* verbosity : 1, */

}

//

_.mapExtend( Self,Proto );
Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

} )( );
