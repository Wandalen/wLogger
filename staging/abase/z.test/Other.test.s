( function _Other_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Other.test.s

*/
var isBrowser = true;
if( typeof module !== 'undefined' )
{
  isBrowser = false;

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../include/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wLogger' );
  _.include( 'wTesting' );

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
  if( isBrowser )
  var expected = [ 1, 0, 0, 1 ];
  else
  var expected = [ 1, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.description = 'case2 : next line color must be red too';
  logger.log( 'line' );
  if( isBrowser )
  var expected = [1, 0, 0, 1 ];
  else
  var expected = [ 1, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.description = 'case3 : setting color to default';
  logger.log( '#foreground : default#' );
  test.identical( logger.foregroundColor, null );

  test.description = 'case4 : setting two styles';
  logger.log( '#foreground : red##background : black#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 0, 0, 0, 1 ]
  ]
  else
  var expected =
  [
    [ 1, 0, 0  ],
    [ 0, 0, 0  ]
  ]

  test.identical( got, expected  );

  test.description = 'case5 : setting foreground to default, bg still black';
  logger.log( '#foreground : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    null,
    [ 0, 0, 0, 1 ]
  ]
  else
  var expected =
  [
    null,
    [ 0, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.description = 'case6 : setting background to default';
  logger.log( '#background : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.description = 'case7 : setting colors to default#2';
  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.description = 'case8 : setting colors to default#3';
  logger.foregroundColor = null;
  logger.backgroundColor = null;
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.description = 'case9 : setting colors from setter';
  logger.foregroundColor = 'red';
  logger.backgroundColor = 'white';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'case10 : setting colors from setter, hex';
  logger.foregroundColor = 'ff0000';
  logger.backgroundColor = 'ffffff';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'case11 : setting colors from setter, unknown';
  logger.foregroundColor = 'd';
  logger.backgroundColor = 'd';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null,
  ]

  test.identical( got, expected  );
  test.description = 'case12 : setting colors from setter, arrays';
  logger.foregroundColor = [ 255, 0 , 0 ];
  logger.backgroundColor = [ 255, 255, 255 ];
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 255, 0, 0, 1 ],
    [ 255, 255, 255, 1 ]
  ]
  else
  var expected =
  [
    [ 255, 0, 0 ],
    [ 255, 255, 255 ]
  ]
  test.identical( got, expected  );

  test.description = 'case13 : setting colors from setter, arrays#2';
  logger.foregroundColor = [ 1, 0, 0 ];
  logger.backgroundColor = [ 1, 1, 1 ];
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'case13 : setting colors from setter, bitmask';
  logger.foregroundColor = 0xff0000;
  logger.backgroundColor = 0xffffff;
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );
}

//

var colorsStack = function( test )
{
  var logger = new wLogger({ output : null });

  test.description = 'push foreground';
  logger.foregroundColor = 0xff0000;
  logger.foregroundColor = 0xffffff;
  var got = [ logger.colorsStack[ 'foreground' ], logger.foregroundColor ];
  if( isBrowser )
  var expected =
  [
    [ [ 1, 0, 0, 1 ] ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ [ 1, 0, 0 ] ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'push background';
  logger.backgroundColor = 0xff0000;
  logger.backgroundColor = 0xffffff;
  var got = [ logger.colorsStack[ 'background' ], logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ [ 1, 0, 0, 1 ] ],
    [ 1, 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ [ 1, 0, 0 ] ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'pop foreground';
  logger.foregroundColor = null;
  var got = [ logger.colorsStack[ 'foreground' ], logger.foregroundColor ];
  if( isBrowser )
  var expected =
  [
    [ ],
    [ 1, 0, 0, 1 ]
  ]
  else
  var expected =
  [
    [ ],
    [ 1, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.description = 'pop background';
  logger.backgroundColor = null;
  var got = [ logger.colorsStack[ 'background' ], logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ ],
    [ 1, 0, 0, 1 ]
  ]
  else
  var expected =
  [
    [ ],
    [ 1, 0, 0 ]
  ]
  test.identical( got, expected  );

}

var Proto =
{

  name : 'Other test',

  tests :
  {

    currentColor : currentColor,
    colorsStack : colorsStack

  },

  /* verbose : 1, */

}

//

_.mapExtend( Self,Proto );
_.Testing.register( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
