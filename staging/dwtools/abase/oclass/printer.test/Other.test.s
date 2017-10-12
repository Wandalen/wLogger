( function _Other_test_s_( ) {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{
  isBrowser = false;

  require( '../printer/top/Logger.s' );

  var _ = wTools;

  _.include( 'wTesting' );

}

//

var _ = wTools;
var Parent = wTools.Tester;

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
  var expected = [ 1, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.description = 'case2 : next line color must be red too';
  logger.log( 'line' );
  var expected = [ 1, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.description = 'case3 : setting color to default';
  logger.log( '#foreground : default#' );
  test.identical( logger.foregroundColor, null );

  test.description = 'case4 : setting two styles';
  logger.log( '#foreground : red##background : black#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0  ],
    [ 0, 0, 0  ]
  ]

  test.identical( got, expected  );

  test.description = 'case5 : setting foreground to default, bg still black';
  logger.log( '#foreground : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
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
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'case11 : setting colors from setter, unknown';
  var logger = new wLogger( { output : fakeConsole } );
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
  var expected =
  [
    [ [ 1, 0, 0 ] ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.description = 'pop foreground';
  logger.foregroundColor = null;
  var got = [ logger.colorsStack[ 'foreground' ], logger.foregroundColor ];
  var expected =
  [
    [ ],
    [ 1, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.description = 'pop background';
  logger.backgroundColor = null;
  var got = [ logger.colorsStack[ 'background' ], logger.backgroundColor ];
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
  test.shouldThrowError( function()
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
  test.shouldThrowError( function()
  {
    logger.downAct();
  })

  test.description = 'cant go below zero level';
  test.shouldThrowError( function()
  {
    var logger = new wLogger();
    logger.logDown();
  })

}

//

function coloredToHtml( test )
{

  var fg = _.color.strFormatForeground;
  var bg = _.color.strFormatBackground;

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

  var src = [ 'some text',_.color.strFormatForeground( 'text','red' ),_.color.strFormatBackground( 'text','yellow' ),'some text' ];
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

  var src = _.color.strFormatBackground( 'red' + _.color.strFormatBackground( 'blue','blue' ) + 'red','red' );
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

  var src = [ 'some text',_.color.strFormatForeground( 'text','red' ),_.color.strFormatBackground( 'text','yellow' ),'some text' ];
  var got = wLogger.coloredToHtml({ src : src, compact : false });
  var expected = "<span>some text</span><span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>text</span><span style='color:transparent;background:rgba( 255, 255, 0, 1 );'>text</span><span>some text</span>";
  test.identical( got, expected );
}

//

function coloring( test )
{
  var got;
  var fg = _.color.strFormatForeground;
  var bg = _.color.strFormatBackground;

  function onWrite( args ){ got = args.outputForTerminal };

  var l = new wLogger({ output : null, coloring : true, onWrite : onWrite });

  test.description = "wColor, coloring : 1";
  l.log( _.color.strFormatForeground( 'text', 'red') );
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

function emptyLines( test )
{
  test.description = 'logger is not skipping empty lines'

  var got;
  var onWrite = function( args ){ got = args.outputForTerminal[ 0 ]; };

  var logger = new wLogger({ output : null, onWrite : onWrite });


  /* on directive#1 */

  logger.log( '#coloring : 1#' );
  var expected = '';
  test.identical( got, expected );

  /* on directive#2 */

  logger.log( '#foreground : red##foreground : default#' );
  var expected = '';
  test.identical( got, expected );

  /* on empty log */

  logger.log();
  var expected = '';
  test.identical( got, expected );

  /* on empty line */

  logger.log( '' );
  var expected = '';
  test.identical( got, expected );
}

//

function diagnostic( test )
{
  if( isBrowser )
  {
    test.identical( 1, 1 );
    return;
  }

  var l = new wLogger();

  //

  wLogger.diagnosticColor = 0;
  wLogger.diagnosticColorCollapse = 0;
  var got = l._diagnosticColorCheck();
  test.identical( got, undefined );

  //

  wLogger.diagnosticColor = 1;
  wLogger.diagnosticColorCollapse = 1;

  /**/

  var got = l._diagnosticColorCheck();
  test.identical( got, undefined );

  /**/

  l.foregroundColor = 'red';
  l.backgroundColor = 'default';
  var got = l._diagnosticColorCheck();
  test.identical( got, undefined );

  /**/

  l.foregroundColor = 'default';
  l.backgroundColor = 'red';
  var got = l._diagnosticColorCheck();
  test.identical( got, undefined );

  //

  test.description = 'ill color combinations test';

  /* IllColorCombination diagnostic off */

  wLogger.diagnosticColor = 0;

  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, undefined  );

  /* IllColorCombination diagnostic on */

  wLogger.diagnosticColor = 1;

  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, true );

  /* after warning diagnostic is disabled */

  test.identical( wLogger.diagnosticColor, 0 );
  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, undefined );

  wLogger.diagnosticColor = 1;

  l.foregroundColor = 'yellow';
  l.backgroundColor = 'blue';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, false );

  //

  test.description = 'color collapse test';

  /* ColorCollapse off */

  wLogger.diagnosticColorCollapse = 0;

  l.foregroundColor = 'yellowish pink';
  l.backgroundColor = 'magenta';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  wLogger.diagnosticColorCollapse = 1;

  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'yellow';
  debugger
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, true  );

  /* ColorCollapse off after first warning */

  test.identical( wLogger.diagnosticColorCollapse, 0 );
  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  wLogger.diagnosticColorCollapse = 1;

  l.foregroundColor = 'red';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, false  );
}

//

function coloringNoColor( test )
{
  var color = _.color;
  _.color = null;

  var got;
  var fg = _.color.strFormatForeground;
  var bg = _.color.strFormatBackground;

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
  silencing : 1,
  /* verbosity : 1, */

  tests :
  {
    currentColor : currentColor,
    colorsStack : colorsStack,
    logUp : logUp,
    logDown : logDown,
    coloredToHtml : coloredToHtml,
    coloring : coloring,
    emptyLines : emptyLines,
    diagnostic : diagnostic,
    coloringNoColor : coloringNoColor,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

// if( typeof module !== 'undefined' && !module.parent )
// _.timeReady( function()
// {
//
//   if( typeof module !== 'undefined' )
//   _.include( 'wLoggerToJstructure' );
//
//   // debugger;
//   Self = wTestSuite( Self.name );
//   Self.logger = wLoggerToJstructure({ coloring : 0 });
//
//   _.Tester.test( Self.name )
//   .doThen( function()
//   {
//     debugger;
//     logger.log( _.toStr( Self.logger.outputData,{ levels : 5 } ) );
//     debugger;
//   });
//
// });

})();
