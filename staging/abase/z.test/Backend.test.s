( function _Backend_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Backend.test.s

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

var simplest = function( test )
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

var colorConsole = function( test )
{

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

  var logger = new wLogger({ console : fakeConsole });


  test.description = 'case1: red text';
  var got = logger.log( _.strColor.fg( 'text', 'red') )[ 0 ];
  var expected = '\u001b[31mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2: yellow background';
  var got = logger.log( _.strColor.bg( 'text', 'yellow') )[ 0 ];
  var expected = '\u001b[43mtext\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3: red text on yellow background';
  var got = logger.log( _.strColor.bg( _.strColor.fg( 'text', 'red'), 'yellow') )[ 0 ];
  var expected = '\u001b[43m\u001b[31mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case4: yellow text on red background ';
  var got = logger.log( 'text' + _.strColor.fg( _.strColor.bg( 'text', 'red'), 'yellow') + 'text' )[ 0 ];
  var expected = 'text\u001b[33m\u001b[41mtext\u001b[49m\u001b[39mtext';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5: unknown color ';
  var got = logger.log( _.strColor.fg( 'text', 'xxx') )[ 0 ];
  var expected = '\u001b[39mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case6: text without styles  ';
  var got = logger.log( 'text' )[ 0 ];
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

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
