( function _Other_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../l9/logger/entry/Logger.s' );

  _.include( 'wTesting' );
  _.include( 'wConsequence' );

}

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTester;
let fileProvider = _testerGlobal_.wTools.fileProvider;
let path = fileProvider.path;

//

function onSuiteBegin()
{
  let self = this;
  self.suiteTempPath = path.tempOpen( path.join( __dirname, '../..'  ), 'PrinterOther' );
  self.assetsOriginalPath = path.join( __dirname, '_asset' );
}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, '/PrinterOther-' ) )
  path.tempClose( self.suiteTempPath );
}

//

function currentColor( test )
{

  var logger = new _.Logger();

  test.case = 'case1 : setting foreground to red';
  logger.log( '❮foreground : default❯❮foreground : dark red❯' );
  if( Config.interpreter === 'browser' )
  var expected = [ 1, 0, 0, 1 ];
  else
  var expected = [ 0.5, 0, 0, 1 ];
  test.identical( logger.foregroundColor, expected );

  test.case = 'case2 : next line color must be red too';
  logger.log( 'line' );
  if( Config.interpreter === 'browser' )
  var expected = [ 1, 0, 0, 1 ];
  else
  var expected = [ 0.5, 0, 0, 1 ];
  test.identical( logger.foregroundColor, expected );

  test.case = 'case3 : setting color to default';
  logger.log( '❮foreground : default❯' );
  test.identical( logger.foregroundColor, null );

  test.case = 'case4 : setting two styles';
  logger.log( '❮foreground : dark red❯❮background : dark black❯' );
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  if( Config.interpreter === 'browser' )
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 0, 0, 0, 1 ]
  ]
  else
  var expected =
  [
    [ 0.5, 0, 0, 1 ],
    [ 0, 0, 0, 1 ]
  ]

  test.identical( got, expected );

  test.case = 'case5 : setting foreground to default, bg still black';
  logger.log( '❮foreground : default❯' );
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    null,
    [ 0, 0, 0, 1 ]
  ]
  test.identical( got, expected );

  test.case = 'case6 : setting background to default';
  logger.log( '❮background : default❯' );
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected );

  test.case = 'case7 : setting colors to default#2';
  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected );

  test.case = 'case8 : setting colors to default#3';
  logger.foregroundColor = null;
  logger.backgroundColor = null;
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    null,
    null
  ]
  test.identical( got, expected );

  test.case = 'case9 : setting colors from setter';
  logger.foregroundColor = 'dark red';
  logger.backgroundColor = 'dark white';
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  if( Config.interpreter === 'browser' )
  var expected =
  [
    [ 1, 0, 0 ],
    [ 1, 1, 1 ],
  ]
  else
  var expected =
  [
    [ 0.5, 0, 0, 1 ],
    [ 0.75, 0.75, 0.75, 1 ],
  ]
  test.identical( got, expected );

  test.case = 'case10 : setting colors from setter, hex';
  logger.foregroundColor = 'ff0000';
  logger.backgroundColor = 'ffffff';
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  test.identical( got, expected );

  test.case = 'case11 : setting colors from setter, unknown';
  var logger = new _.Logger();
  test.shouldThrowErrorOfAnyKind( () =>
  {
    logger.foregroundColor = 'd';
  })
  test.shouldThrowErrorOfAnyKind( () =>
  {
    logger.backgroundColor = 'd';
  })
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    null,
    null,
  ]

  test.identical( got, expected );
  test.case = 'case12 : setting colors from rgb array';
  logger.foregroundColor = [ 1, 0, 0 ];
  logger.backgroundColor = [ 0, 1, 1 ];
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 0, 1, 1, 1 ]
  ]
  test.identical( got, expected );

  test.case = 'case13 : setting colors from rgba array';
  logger.foregroundColor = [ 1, 0, 0, 0.5 ];
  logger.backgroundColor = [ 1, 1, 1, 0.5 ];
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0, 0.5 ],
    [ 1, 1, 1, 0.5 ]
  ]
  test.identical( got, expected );

  test.case = 'case13 : setting colors from setter, bitmask';
  logger.foregroundColor = 0xff0000;
  logger.backgroundColor = 0xffffff;
  var got = [ logger.foregroundColor, logger.backgroundColor ];
  var expected =
  [
    [ 1, 0, 0, 1 ],
    [ 1, 1, 1, 1 ]
  ]
  test.identical( got, expected  );
}

//

function _colorsStack( test )
{
  var logger = new _.Logger({ output : null });

  test.case = 'push foreground';
  logger.foregroundColor = 0xff0000;
  logger.foregroundColor = 0xffffff;
  var got = [ logger._colorsStack[ 'foreground' ], logger.foregroundColor ];
  var expected =
  [
    [ [ 1, 0, 0, 1 ] ],
    [ 1, 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'push background';
  logger.backgroundColor = 0xff0000;
  logger.backgroundColor = 0xffffff;
  var got = [ logger._colorsStack[ 'background' ], logger.backgroundColor ];
  var expected =
  [
    [ [ 1, 0, 0, 1 ] ],
    [ 1, 1, 1, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'pop foreground';
  logger.foregroundColor = null;
  var got = [ logger._colorsStack[ 'foreground' ], logger.foregroundColor ];
  var expected =
  [
    [ ],
    [ 1, 0, 0, 1 ]
  ]
  test.identical( got, expected  );

  test.case = 'pop background';
  logger.backgroundColor = null;
  var got = [ logger._colorsStack[ 'background' ], logger.backgroundColor ];
  var expected =
  [
    [ ],
    [ 1, 0, 0, 1 ]
  ]
  test.identical( got, expected  );

}

//

function logUp( test )
{
  var got;
  function onTransformEnd( args ) { got = args.outputForPrinter[ 0 ] };

  var logger = new _.Logger({ output : null, onTransformEnd, outputGray : 1 });

  test.case = 'case1';
  var msg = 'Up';
  logger.logUp( msg );
  test.identical( got.length - msg.length, 2 )

  test.case = 'case2';
  var msg = 'Up';
  logger.logUp( msg );
  logger.logUp( msg );
  test.identical( got.length - msg.length, 6 );

  test.case = 'case3';
  test.shouldThrowErrorOfAnyKind( function()
  {
    logger.upAct();
  })

}

//

function logDown( test )
{
  var got;
  function onTransformEnd( args ) { got = args.outputForPrinter[ 0 ] };

  var logger = new _.Logger({ output : null, onTransformEnd, outputGray : 1 });

  test.case = 'case1';
  logger.up( 2 );
  var msg = 'Down';
  logger.logDown( msg );
  test.identical( got.length - msg.length, 4 );

  test.case = 'case2';
  test.shouldThrowErrorOfAnyKind( function()
  {
    logger.downAct();
  })

  test.case = 'cant go below zero level';
  test.shouldThrowErrorOfAnyKind( function()
  {
    var logger = new _.Logger({ output : console });
    logger.logDown();
  })

}

//

function coloredToHtml( test )
{

  var fg = _.ct.fg;
  var bg = _.ct.bg;

  var got;

  function onTransformEnd( o )
  {
    got = o.outputForTerminal[ 0 ];
  }

  var l = new _.Logger({ output : null, onTransformEnd, writingToHtml : 1 })

  test.case = 'default settings';

  var src = 'simple text';
  l.log( src );
  var expected = 'simple text';
  test.identical( got, expected );

  var src = fg( 'red text', 'red' );
  l.log( src );
  var expected = '<span style=\'color:rgba( 255, 0, 0, 1 );\'>red text</span>';
  test.identical( got, expected );

  var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ].join( '' );
  l.log( src );
  var expected = '<span style=\'color:rgba( 255, 0, 0, 1 );\'>red text</span><span style=\'background:rgba( 255, 0, 0, 1 );\'>red background</span>';
  test.identical( got, expected );

  var src = [ 'some text', _.ct.fg( 'text', 'red' ), _.ct.bg( 'text', 'yellow' ), 'some text' ].join( '' );
  l.log( src );
  var expected = 'some text<span style=\'color:rgba( 255, 0, 0, 1 );\'>text</span><span style=\'background:rgba( 255, 255, 0, 1 );\'>text</span>some text';
  test.identical( got, expected );

  var src = fg( '\nred text' + fg( 'yellow text', 'yellow' ) + 'red text', 'red' );
  l.log( src );
  var expected = '<span style=\'color:rgba( 255, 0, 0, 1 );\'><br>red text<span style=\'color:rgba( 255, 255, 0, 1 );\'>yellow text</span>red text</span>';
  test.identical( got, expected );

  var src = bg( '\nred background' + bg( 'yellow background', 'yellow' ) + 'red background', 'red' );
  l.log( src );
  var expected = '<span style=\'background:rgba( 255, 0, 0, 1 );\'><br>red background<span style=\'background:rgba( 255, 255, 0, 1 );\'>yellow background</span>red background</span>';
  test.identical( got, expected );

  var src = '❮background : red❯red❮background : blue❯blue❮background : default❯red❮background : default❯';
  l.log( src );
  var expected = '<span style=\'background:rgba( 255, 0, 0, 1 );\'>red<span style=\'background:rgba( 0, 0, 255, 1 );\'>blue</span>red</span>';
  test.identical( got, expected );

  var src = _.ct.bg( 'red' + _.ct.bg( 'blue', 'blue' ) + 'red', 'red' );
  l.log( src );
  var expected = '<span style=\'background:rgba( 255, 0, 0, 1 );\'>red<span style=\'background:rgba( 0, 0, 255, 1 );\'>blue</span>red</span>';
  test.identical( got, expected );

  // test.case = 'compact mode disabled';

  // var src = 'simple text';
  // l.log({ src, compact : false });
  // var expected = "<span>simple text</span>";
  // test.identical( got, expected );

  // var src = fg( 'red text', 'red' );
  // l.log({ src, compact : false });
  // var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span>";
  // test.identical( got, expected );

  // var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
  // l.log({ src, compact : false });
  // var expected = "<span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>red text</span><span style='color:transparent;background:rgba( 255, 0, 0, 1 );'>red background</span>";
  // test.identical( got, expected );

  // var src = [ 'some text',_.ct.fg( 'text','red' ),_.ct.bg( 'text','yellow' ),'some text' ];
  // l.log({ src, compact : false });
  // var expected = "<span>some text</span><span style='color:rgba( 255, 0, 0, 1 );background:transparent;'>text</span><span style='color:transparent;background:rgba( 255, 255, 0, 1 );'>text</span><span>some text</span>";
  // test.identical( got, expected );
}

//

function outputGray( test )
{
  var got;
  var fg = _.ct.fg;
  var bg = _.ct.bg;

  function onTransformEnd( args ){ got = args.outputForTerminal };

  var l = new _.Logger({ output : null, outputGray : false, onTransformEnd });

  test.case = 'wColor, outputGray : 0';
  l.log( _.ct.fg( 'text', 'dark red') );
  if( Config.interpreter === 'browser' )
  test.identical( got, [ '%ctext', 'color:rgba( 255, 0, 0, 1 );background:none;' ] );
  else
  test.identical( got[ 0 ], '\u001b[31mtext\u001b[39;0m' );


  test.case =  'wColor, outputGray : 1';
  l.outputGray = true;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got[ 0 ], 'red text red background' );

}

//

function emptyLines( test )
{
  test.case = 'logger is not skipping empty lines'

  var got;
  var onTransformEnd = function( args ){ got = args.outputForTerminal[ 0 ]; };

  var logger = new _.Logger({ output : null, onTransformEnd });


  /* on directive#1 */

  logger.log( '❮outputGray : 0❯' );
  var expected = '';
  test.identical( got, expected );

  /* on directive#2 */

  logger.log( '❮foreground : red❯❮foreground : default❯' );
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
  if( Config.interpreter === 'browser' )
  {
    test.identical( 1, 1 );
    return;
  }

  var l = new _.Logger({ output : console });

  /* */

  _.Logger.diagnosingColor = 0;
  _.Logger.diagnosingColorCollapse = 0;
  var got = l._diagnoseColorCheck();
  test.identical( got, undefined );

  /* */

  _.Logger.diagnosingColor = 1;
  _.Logger.diagnosingColorCollapse = 1;

  /* */

  var got = l._diagnoseColorCheck();
  test.identical( got, undefined );

  /* */

  l.foregroundColor = 'red';
  l.backgroundColor = 'default';
  var got = l._diagnoseColorCheck();
  test.identical( got, undefined );

  /* */

  l.foregroundColor = 'default';
  l.backgroundColor = 'red';
  var got = l._diagnoseColorCheck();
  test.identical( got, undefined );

  /* */

  test.case = 'ill color combinations test';

  /* IllColorCombination diagnostic off */

  _.Logger.diagnosingColor = 0;

  l.foregroundColor = 'bright black';
  l.backgroundColor = 'dark yellow';
  var got = l._diagnoseColorCheck();
  test.identical( got.ill, undefined  );

  /* IllColorCombination diagnostic on */

  _.Logger.diagnosingColor = 1;

  l.foregroundColor = 'bright black';
  l.backgroundColor = 'dark yellow';
  var got = l._diagnoseColorCheck();
  test.identical( got.ill, true );

  /* after warning diagnostic is disabled */

  test.identical( _.Logger.diagnosingColor, 0 );
  l.foregroundColor = 'dark black';
  l.backgroundColor = 'dark yellow';
  var got = l._diagnoseColorCheck();
  test.identical( got.ill, undefined );

  _.Logger.diagnosingColor = 1;

  l.foregroundColor = 'dark yellow';
  l.backgroundColor = 'dark blue';
  var got = l._diagnoseColorCheck();
  test.identical( got.ill, false );

  /* */

  test.case = 'color collapse test';

  /* ColorCollapse off */

  _.Logger.diagnosingColorCollapse = 0;

  l.foregroundColor = 'yellowish pink';
  l.backgroundColor = 'dark magenta';
  var got = l._diagnoseColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  _.Logger.diagnosingColorCollapse = 1;

  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'dark yellow';
  debugger
  var got = l._diagnoseColorCheck();
  test.identical( got.collapse, false  );

  /* ColorCollapse off after first warning */

  _.Logger.diagnosingColorCollapse = 0;
  test.identical( _.Logger.diagnosingColorCollapse, 0 );
  l.foregroundColor = 'greenish yellow';
  l.backgroundColor = 'dark yellow';
  var got = l._diagnoseColorCheck();
  test.identical( got.collapse, undefined  );

  /* ColorCollapse on */

  _.Logger.diagnosingColorCollapse = 1;

  l.foregroundColor = 'dark red';
  l.backgroundColor = 'dark yellow';
  var got = l._diagnoseColorCheck();
  test.identical( got.collapse, false  );
}

//

function stateChangingValue( test )
{

  test.open( 'inputGray' );
  runFor( 'inputGray' );
  test.close( 'inputGray' );

  test.open( 'outputGray' );
  runFor( 'outputGray' );
  test.close( 'outputGray' );

  test.open( 'inputRaw' );
  runFor( 'inputRaw' );
  test.close( 'inputRaw' );

  test.open( 'outputRaw' );
  runFor( 'outputRaw' );
  test.close( 'outputRaw' );

  function runFor( state )
  {

    test.case = state + ': ' + 'number';
    var l = new _.Logger();
    l[ state ] = 1;
    test.identical( l[ state ], 1 );
    l[ state ] = 1;
    test.identical( l[ state ], 1 );
    l[ state ] = 0;
    test.identical( l[ state ], 0 );
    // l[ state ] = -1;
    // test.identical( l[ state ], 0 );

    /* */

    test.case = state + ': ' + 'bool';
    var l = new _.Logger();
    var prev = l[ state ];
    l[ state ] = true;
    test.identical( l[ state ], prev + 1 );
    var prev = l[ state ];
    l[ state ] = false;
    test.identical( l[ state ], prev - 1 );

    /* */

    test.case = state + ': ' + 'as directive, number';
    var l = new _.Logger();
    l.log( `❮${state}:1❯` )
    test.identical( l[ state ], 1 );
    l.log( `❮${state}:1❯` )
    test.identical( l[ state ], 2 );
    l.log( `❮${state}:0❯` )
    test.identical( l[ state ], 1 );
    // l.log( `#${state}:-1#` )
    // test.identical( l[ state ], 2 );

    /* */

    test.case = state + ': ' + 'as directive, bool';
    var l = new _.Logger();
    l.log( `❮${state}:true❯` )
    test.identical( l[ state ], 1 );
    l.log( `❮${state}:true❯` )
    test.identical( l[ state ], 2 );
    l.log( `❮${state}:false❯` )
    test.identical( l[ state ], 1 );
    l.log( `❮${state}:false❯` )
    test.identical( l[ state ], 0 );

    /* */


    if( !Config.debug )
    return

    test.case = state + ': ' + 'string';
    test.shouldThrowErrorOfAnyKind( () =>
    {
      l[ state ] = '1';
    })
  }
}

//

function coloringNoColor( test )
{
  var color = _.color;
  var fg = _.ct.fg;
  var bg = _.ct.bg;
  _.color = null;

  var got;

  function onTransformEnd( args ){ got = args.outputForTerminal[ 0 ] };

  var l = new _.Logger({ output : null, outputGray : false, onTransformEnd });

  test.case = 'No wColor, outputGray : 0';
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );

  test.case =  'No wColor, outputGray : 1';
  l.outputGray = true;
  l.log( fg( 'red text', 'red' ), bg( 'red background', 'red' ) );
  test.identical( got, 'red text red background' );

  _.color = color;
}

//

function clone( test )
{
  test.case = 'clone printer';

  var printer = new _.Logger({ name : 'printerA', onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter', onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformEnd });

  printer.outputTo( outputPrinter );
  printer.inputFrom( inputPrinter );

  var clonedPrinter =  printer.clone();

  clonedPrinter.name = 'clonedPrinter';

  test.will = 'printers must have same inputs/outputs'

  test.identical( printer.inputs.length, 1 );
  test.identical( printer.outputs.length, 1 );

  test.identical( clonedPrinter.inputs.length, 1 );
  test.identical( clonedPrinter.outputs.length, 1 );

  test.identical( outputPrinter.inputs.length, 2 );
  test.identical( outputPrinter.inputs[ 0 ].inputPrinter, printer );
  test.identical( outputPrinter.inputs[ 1 ].inputPrinter, clonedPrinter );

  test.identical( inputPrinter.outputs.length, 2 );
  test.identical( inputPrinter.outputs[ 0 ].outputPrinter, printer );
  test.identical( inputPrinter.outputs[ 1 ].outputPrinter, clonedPrinter );

  test.identical( printer.inputs[ 0 ].inputPrinter, clonedPrinter.inputs[ 0 ].inputPrinter );
  test.identical( printer.outputs[ 0 ].outputPrinter, clonedPrinter.outputs[ 0 ].outputPrinter );

  var hooked = [];
  var expected =
  [
    'inputPrinter : for printers',

    'printerA : for printers',
    'outputPrinter : for printers',

    'clonedPrinter : for printers',
    'outputPrinter : for printers'
  ]

  inputPrinter.log( 'for printers' );

  test.identical( hooked, expected );

  function onTransformEnd( o )
  {
    hooked.push( this.name + ' : ' + o.input[ 0 ] );
    return o;
  }

}

function processWarning( test )
{
  if( Config.interpreter !== 'njs' )
  {
    test.identical( 1, 1 )
    return
  }

  let ready = new _.Consequence();

  var message = 'Something wrong';
  process.emitWarning( 'Something wrong' );
  process.on( 'warning', ( warning ) =>
  {
    ready.take( warning )
  });
  ready.then( ( got ) =>
  {
    test.identical( got.message, message );
    return null;
  })

  return ready;
}

//

function consoleBarExperiment( test )
{
  let context = this;
  let a = test.assetFor( false );
  let toolsPath = _testerGlobal_.wTools.strEscape( a.path.nativize( a.path.join( __dirname, '../../../../wtools/Tools.s' ) ) );
  let programSourceCode =
`
var toolsPath = '${toolsPath}';
${program.toString()}
program();
`

  /* */

  a.fileProvider.fileWrite( a.abs( 'Program.js' ), programSourceCode );
  a.appStartNonThrowing({ execPath : a.abs( 'Program.js' ) })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Console is barred' ), 1 );
    test.identical( _.strCount( op.output, 'Something wrong' ), 1 );

    return null;
  });

  /* */

  return a.ready;

  function program()
  {
    let _ = require( toolsPath );
    _.include( 'wLogger' );
    _.Logger.ConsoleBar();
    if( _.Logger.ConsoleIsBarred( console ) )
    console.log( 'Console is barred' )
    var message = 'Something wrong';
    console.error.call( undefined, [ message ] );
  }

}

consoleBarExperiment.timeOut = 30000;
consoleBarExperiment.description =
`
console is barred
console.error works without context
`

//

let Self =
{

  name : 'Tools.logger.Other',
  silencing : 1,
  /* verbosity : 1, */

  // routineTimeOut : 9999999,

  onSuiteBegin,
  onSuiteEnd,


  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null
  },

  tests :
  {
    currentColor,
    _colorsStack,
    logUp,
    logDown,
    coloredToHtml,
    outputGray,
    emptyLines,
    diagnostic,
    stateChangingValue,
    clone,
    coloringNoColor,
    processWarning,
    consoleBarExperiment
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
