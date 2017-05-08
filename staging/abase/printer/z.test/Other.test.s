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

  require( '../printer/Logger.s' );

  var _ = wTools;

  _.include( 'wTesting' );

}

//

var _ = wTools;
var Parent = wTools.Testing;
var sourceFilePath = typeof module !== 'undefined' ? __filename : document.scripts[ document.scripts.length-1 ].src;

//

function currentColor( test )
{
  function fakelog()
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
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
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

function colorsStack( test )
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

//

function logUp( test )
{
  var got;
  function _onWrite( args ) { got = args.output[ 0 ] };

  var logger = new wLogger({ output : null, onWrite : _onWrite,coloring : 0 });

  test.description = 'case1';
  var msg = "Up";
  logger.logUp( msg );
  test.identical( got.length - msg.length, 2 )

  test.description = 'case2';
  var msg = "Up";
  logger.logUp( msg );
  logger.logUp( msg );
  test.identical( got.length - msg.length, 6 );

  test.description = 'case3';
  test.shouldThrowError( function ()
  {
    logger.upAct();
  })

}

//

function logDown( test )
{
  var got;
  function _onWrite( args ) { got = args.output[ 0 ] };

  var logger = new wLogger({ output : null, onWrite : _onWrite,coloring : 0 });

  test.description = 'case1';
  logger.up( 2 );
  var msg = "Down";
  logger.logDown( msg );
  test.identical( got.length - msg.length, 4 );

  test.description = 'case2';
  test.shouldThrowError( function ()
  {
    logger.downAct();
  })

  test.description = 'cant go below zero level';
  test.shouldThrowError( function ()
  {
    var logger = new wLogger();
    logger.logDown();
  })

}

//

var fg = _.strColor.fg;
var bg = _.strColor.bg;

function coloredToHtml( test )
{
  test.description = 'default settings';

  var src = 'simple text';
  var got = wLogger.coloredToHtml( src );
  var expected = 'simple text';
  test.identical( got, expected );

  var src = fg( 'red text', 'red' );
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'>red text</span>";
  test.identical( got, expected );

  var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'>red text</span><span style='background:rgba( 255, 0, 0, 1 );'>red background</span>";
  test.identical( got, expected );

  var src = [ 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ),'some text' ];
  var got = wLogger.coloredToHtml( src );
  var expected = "some text<span style='color:rgba( 255, 0, 0, 1 );'>text</span><span style='background:rgba( 255, 255, 0, 1 );'>text</span>some text";
  test.identical( got, expected );

  var src = fg( '\nred text' + fg( 'yellow text', 'yellow' ) + 'red text', 'red' );
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'><br>red text<span style='color:rgba( 255, 255, 0, 1 );'>yellow text</span>red text</span>";
  test.identical( got, expected );

  var src = bg( '\nred background' + bg( 'yellow background', 'yellow' ) + 'red background', 'red' );
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'><br>red background<span style='background:rgba( 255, 255, 0, 1 );'>yellow background</span>red background</span>";
  test.identical( got, expected );

  var src = '#background : red#red#background : blue#blue#background : default#red#background : default#';
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>";
  test.identical( got, expected );

  var src = _.strColor.bg( 'red' + _.strColor.bg( 'blue','blue' ) + 'red','red' );
  var got = wLogger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>";
  test.identical( got, expected );

  test.description = 'compact mode disabled';

  var src = 'simple text';
  var got = wLogger.coloredToHtml({ src : src, compact : false });
  var expected = '<span>simple text</span>';
  test.identical( got, expected );

  var src = fg( 'red text', 'red' );
  var got = wLogger.coloredToHtml({ src : src, compact : false });
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span>";
  test.identical( got, expected );

  var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
  var got = wLogger.coloredToHtml({ src : src, compact : false });
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span><span style='color:transparent;background:rgba( 255, 0, 0, 1 );'>red background</span>";
  test.identical( got, expected );

  var src = [ 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ),'some text' ];
  var got = wLogger.coloredToHtml({ src : src, compact : false });
  var expected = "<span>some text</span><span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>text</span><span style='color:transparent;background:rgba( 255, 255, 0, 1 );'>text</span><span>some text</span>";
  test.identical( got, expected );
}

//

function coloring( test )
{
  var got;
  function onWrite( args ){ got = args.outputForTerminal };

  var l = new wLogger({ output : null, coloring : true, onWrite : onWrite });

  test.description = "wColor, coloring : 1";
  l.log( _.strColor.fg( 'text', 'red') );
  if( isBrowser )
  test.identical( got, [ '%ctext', 'color:rgba( 255, 0, 0, 1 );background:none;' ] );
  else
  test.identical( got[ 0 ], '\u001b[31mtext\u001b[39m' );


  test.description =  "wColor, coloring : 0";
  l.coloring = false;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got[ 0 ], 'red text red background' );

}

//

function coloringNoColor( test )
{
  var color = _.color;
  _.color = null;
  var got;
  function onWrite( args ){ got = args.outputForTerminal[ 0 ] };

  var l = new wLogger({ output : null, coloring : true, onWrite : onWrite });

  test.description = "No wColor, coloring : 1";
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );

  test.description =  "No wColor, coloring : 0";
  l.coloring = false;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );
  _.color = color;
}

//

var Self =
{

  name : 'Logger other test',
  sourceFilePath : sourceFilePath,
  /* verbosity : 1, */

  tests :
  {
    currentColor : currentColor,
    colorsStack : colorsStack,
    logUp : logUp,
    logDown : logDown,
    coloredToHtml : coloredToHtml,
    coloring : coloring,
    coloringNoColor : coloringNoColor,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

// if( typeof module !== 'undefined' && !module.parent )
// _.timeReady( function()
// {
//
//   if( typeof module !== 'undefined' )
//   _.include( 'wPrinterToJstructure' );
//
//   // debugger;
//   Self = wTestSuite( Self.name );
//   Self.logger = wPrinterToJstructure({ coloring : 0 });
//
//   _.Testing.test( Self.name )
//   .doThen( function()
//   {
//     debugger;
//     logger.log( _.toStr( Self.logger.outputData,{ levels : 5 } ) );
//     debugger;
//   });
//
// });

})();
