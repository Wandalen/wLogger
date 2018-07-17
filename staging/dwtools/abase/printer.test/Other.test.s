( function _Other_test_s_( ) {

'use strict'; /**/

var isBrowser = true;
if( typeof module !== 'undefined' )
{
  isBrowser = false;

  require( '../printer/top/Logger.s' );

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

var _global = _global_; var _ = _global_.wTools;
var Parent = _.Tester;

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

  var logger = new _.Logger( { output : fakeConsole } );

  test.case = 'case1 : setting foreground to red';
  logger.log( '#foreground : default##foreground : red#' );
  if( isBrowser )
  var expected = [ 1, 0, 0 ];
  else
  var expected = [ 0.5, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.case = 'case2 : next line color must be red too';
  logger.log( 'line' );
  if( isBrowser )
  var expected = [ 1, 0, 0 ];
  else
  var expected = [ 0.5, 0, 0 ];
  test.identical( logger.foregroundColor, expected );

  test.case = 'case3 : setting color to default';
  logger.log( '#foreground : default#' );
  test.identical( logger.foregroundColor, null );

  test.case = 'case4 : setting two styles';
  logger.log( '#foreground : red##background : black#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0  ],
    [ 0, 0, 0  ]
  ]
  else
  var expected =
  [
    [ 0.5, 0, 0  ],
    [ 0, 0, 0  ]
  ]

  test.identical( got, expected  );

  test.case = 'case5 : setting foreground to default, bg still black';
  logger.log( '#foreground : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    [ 0, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.case = 'case6 : setting background to default';
  logger.log( '#background : default#' );
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.case = 'case7 : setting colors to default#2';
  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.case = 'case8 : setting colors to default#3';
  logger.foregroundColor = null;
  logger.backgroundColor = null;
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected  );

  test.case = 'case9 : setting colors from setter';
  logger.foregroundColor = 'red';
  logger.backgroundColor = 'white';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  if( isBrowser )
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  else
  var expected =
  [
    [ 0.5, 0, 0 ],
    [ 0.9, 0.9, 0.9 ]
  ]
  test.identical( got, expected  );

  test.case = 'case10 : setting colors from setter, hex';
  logger.foregroundColor = 'ff0000';
  logger.backgroundColor = 'ffffff';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'case11 : setting colors from setter, unknown';
  var logger = new _.Logger( { output : fakeConsole } );
  logger.foregroundColor = 'd';
  logger.backgroundColor = 'd';
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    null,
    null,
  ]

  test.identical( got, expected  );
  test.case = 'case12 : setting colors from setter, arrays';
  logger.foregroundColor = [ 255, 0 , 0 ];
  logger.backgroundColor = [ 255, 255, 255 ];
  var got = [ logger.foregroundColor,logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'case13 : setting colors from setter, arrays#2';
  logger.foregroundColor = [ 1, 0, 0 ];
  logger.backgroundColor = [ 1, 1, 1 ];
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'case13 : setting colors from setter, bitmask';
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
  var logger = new _.Logger({ output : null });

  test.case = 'push foreground';
  logger.foregroundColor = 0xff0000;
  logger.foregroundColor = 0xffffff;
  var got = [ logger.colorsStack[ 'foreground' ], logger.foregroundColor ];
  var expected =
  [
    [ [ 1, 0, 0 ] ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'push background';
  logger.backgroundColor = 0xff0000;
  logger.backgroundColor = 0xffffff;
  var got = [ logger.colorsStack[ 'background' ], logger.backgroundColor ];
  var expected =
  [
    [ [ 1, 0, 0 ] ],
    [ 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'pop foreground';
  logger.foregroundColor = null;
  var got = [ logger.colorsStack[ 'foreground' ], logger.foregroundColor ];
  var expected =
  [
    [ ],
    [ 1, 0, 0 ]
  ]
  test.identical( got, expected  );

  test.case = 'pop background';
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

  var logger = new _.Logger({ output : null, onWrite : _onWrite,coloring : 0 });

  test.case = 'case1';
  var msg = "Up";
  logger.logUp( msg );
  test.identical( got.length - msg.length, 2 )

  test.case = 'case2';
  var msg = "Up";
  logger.logUp( msg );
  logger.logUp( msg );
  test.identical( got.length - msg.length, 6 );

  test.case = 'case3';
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

  var logger = new _.Logger({ output : null, onWrite : _onWrite,coloring : 0 });

  test.case = 'case1';
  logger.up( 2 );
  var msg = "Down";
  logger.logDown( msg );
  test.identical( got.length - msg.length, 4 );

  test.case = 'case2';
  test.shouldThrowError( function()
  {
    logger.downAct();
  })

  test.case = 'cant go below zero level';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger();
    logger.logDown();
  })

}

//

function coloredToHtml( test )
{

  var fg = _.color.strFormatForeground;
  var bg = _.color.strFormatBackground;

  test.case = 'default settings';

  var src = 'simple text';
  var got = _.Logger.coloredToHtml( src );
  var expected = 'simple text';
  test.identical( got, expected );

  var src = fg( 'red text', 'red' );
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'>red text</span>";
  test.identical( got, expected );

  var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'>red text</span><span style='background:rgba( 255, 0, 0, 1 );'>red background</span>";
  test.identical( got, expected );

  var src = [ 'some text',_.color.strFormatForeground( 'text','red' ),_.color.strFormatBackground( 'text','yellow' ),'some text' ];
  var got = _.Logger.coloredToHtml( src );
  var expected = "some text<span style='color:rgba( 255, 0, 0, 1 );'>text</span><span style='background:rgba( 255, 255, 0, 1 );'>text</span>some text";
  test.identical( got, expected );

  var src = fg( '\nred text' + fg( 'yellow text', 'yellow' ) + 'red text', 'red' );
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );'><br>red text<span style='color:rgba( 255, 255, 0, 1 );'>yellow text</span>red text</span>";
  test.identical( got, expected );

  var src = bg( '\nred background' + bg( 'yellow background', 'yellow' ) + 'red background', 'red' );
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'><br>red background<span style='background:rgba( 255, 255, 0, 1 );'>yellow background</span>red background</span>";
  test.identical( got, expected );

  var src = '#background : red#red#background : blue#blue#background : default#red#background : default#';
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>";
  test.identical( got, expected );

  var src = _.color.strFormatBackground( 'red' + _.color.strFormatBackground( 'blue','blue' ) + 'red','red' );
  var got = _.Logger.coloredToHtml( src );
  var expected = "<span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>";
  test.identical( got, expected );

  test.case = 'compact mode disabled';

  var src = 'simple text';
  var got = _.Logger.coloredToHtml({ src : src, compact : false });
  var expected = '<span>simple text</span>';
  test.identical( got, expected );

  var src = fg( 'red text', 'red' );
  var got = _.Logger.coloredToHtml({ src : src, compact : false });
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span>";
  test.identical( got, expected );

  var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
  var got = _.Logger.coloredToHtml({ src : src, compact : false });
  var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span><span style='color:transparent;background:rgba( 255, 0, 0, 1 );'>red background</span>";
  test.identical( got, expected );

  var src = [ 'some text',_.color.strFormatForeground( 'text','red' ),_.color.strFormatBackground( 'text','yellow' ),'some text' ];
  var got = _.Logger.coloredToHtml({ src : src, compact : false });
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

  var l = new _.Logger({ output : null, coloring : true, onWrite : onWrite });

  test.case = "wColor, coloring : 1";
  l.log( _.color.strFormatForeground( 'text', 'red') );
  if( isBrowser )
  test.identical( got, [ '%ctext', 'color:rgba( 255, 0, 0, 1 );background:none;' ] );
  else
  test.identical( got[ 0 ], '\u001b[31mtext\u001b[39;0m' );


  test.case =  "wColor, coloring : 0";
  l.coloring = false;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got[ 0 ], 'red text red background' );

}

//

function emptyLines( test )
{
  test.case = 'logger is not skipping empty lines'

  var got;
  var onWrite = function( args ){ got = args.outputForTerminal[ 0 ]; };

  var logger = new _.Logger({ output : null, onWrite : onWrite });


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

  var l = new _.Logger();

  //

  _.Logger.diagnosticColor = 0;
  _.Logger.diagnosticColorCollapse = 0;
  var got = l._diagnosticColorCheck();
  test.identical( got, undefined );

  //

  _.Logger.diagnosticColor = 1;
  _.Logger.diagnosticColorCollapse = 1;

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

  test.case = 'ill color combinations test';

  /* IllColorCombination diagnostic off */

  _.Logger.diagnosticColor = 0;

  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, undefined  );

  /* IllColorCombination diagnostic on */

  _.Logger.diagnosticColor = 1;

  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, true );

  /* after warning diagnostic is disabled */

  test.identical( _.Logger.diagnosticColor, 0 );
  l.foregroundColor = 'black';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, undefined );

  _.Logger.diagnosticColor = 1;

  l.foregroundColor = 'yellow';
  l.backgroundColor = 'blue';
  var got = l._diagnosticColorCheck();
  test.identical( got.ill, false );

  //

  test.case = 'color collapse test';

  /* ColorCollapse off */

  _.Logger.diagnosticColorCollapse = 0;

  l.foregroundColor = 'yellowish pink';
  l.backgroundColor = 'magenta';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  _.Logger.diagnosticColorCollapse = 1;

  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'yellow';
  debugger
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, false  );

  /* ColorCollapse off after first warning */

  _.Logger.diagnosticColorCollapse = 0;
  test.identical( _.Logger.diagnosticColorCollapse, 0 );
  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  _.Logger.diagnosticColorCollapse = 1;

  l.foregroundColor = 'red';
  l.backgroundColor = 'yellow';
  var got = l._diagnosticColorCheck();
  test.identical( got.collapse, false  );
}

//

function coloringNoColor( test )
{
  var color = _.color;
  var fg = _.color.strFormatForeground;
  var bg = _.color.strFormatBackground;
  _.color = null;

  var got;

  function onWrite( args ){ got = args.outputForTerminal[ 0 ] };

  var l = new _.Logger({ output : null, coloring : true, onWrite : onWrite });

  test.case = "No wColor, coloring : 1";
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );

  test.case =  "No wColor, coloring : 0";
  l.coloring = false;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );
  _.color = color;
}

//

var Self =
{

  name : 'Tools/base/printer/Other',
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

})();
