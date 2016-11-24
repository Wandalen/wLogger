( function _Other_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Other.test.s

*/

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  require( '../../../../wTools/staging/abase/component/StringTools.s' );
  require( '../object/printer/printer/Logger.s' );

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
var Parent = wTools.Testing;
var Self = {};

//

var currentColor = function( test )
{
  var fakelog = function()
  {
    return arguments;
  }

  var fakeConsole =
  {
    log : _.routineJoin( console,fakelog ),
    error : _.routineJoin( console,console.error ),
    info : _.routineJoin( console,console.info ),
    warn : _.routineJoin( console,console.warn ),
  }

  var logger = new wLogger( { output : fakeConsole } );

  test.description = 'case1 : setting foreground to red';
  logger.log( '#foreground : default##foreground : red#' );
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );

  test.description = 'case2 : next line color must be red too';
  logger.log( 'line' );
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );

  test.description = 'case3 : setting color to default';
  logger.log( '#foreground : default#' );
  test.identical( logger.foregroundColor, null );

  test.description = 'case4 : setting two styles';
  logger.log( '#foreground : red##background : black#' );
  var got = [ logger.foregroundColor,logger.backgroundColor]
  var expected =
  [
    [ 1, 0, 0 ],
    [ 0, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.description = 'case5 : setting foreground to default, bg still black';
  logger.log( '#foreground : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor]
  var expected =
  [
    null,
    [ 0, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.description = 'case6 : setting background to default';
  logger.log( '#background : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor]
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

}


//

var Proto =
{

  name : 'Other test',

  tests :
  {

    currentColor : currentColor,

  },

  /* verbose : 1, */

}

//

_.mapExtend( Self,Proto );
_.Testing.register( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
