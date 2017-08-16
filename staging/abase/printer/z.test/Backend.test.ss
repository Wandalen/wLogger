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

//

var _ = wTools;
var Parent = wTools.Tester;
var isUnix = process.platform !== 'win32' ? true : false;

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

  var got;

  var onWrite = function ( args ){ got = args.outputForTerminal[ 0 ]; };

  var logger = new wLogger({ output : null, onWrite : onWrite });

  test.description = 'case1: red text';
  logger.log( _.strColor.fg( 'text', 'red') );
  var expected = '\u001b[31mtext\u001b[39m';
  test.identical( logger.foregroundColor, null );
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2: yellow background';
  logger.log( _.strColor.bg( 'text', 'yellow') );
  test.identical( logger.backgroundColor, null );
  var expected = '\u001b[43mtext\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3: red text on yellow background';
  logger.log( _.strColor.bg( _.strColor.fg( 'text', 'red'), 'yellow') );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = '\u001b[31m\u001b[43mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case4: yellow text on red background  + not styled text';
  logger.log( 'text' + _.strColor.fg( _.strColor.bg( 'text', 'red'), 'yellow') + 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text\u001b[33m\u001b[41mtext\u001b[39m\u001b[49mtext';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5: unknown color ';
  logger.log( _.strColor.fg( 'text', 'xxx') );
  test.identical( logger.foregroundColor, null );
  var expected = 'text';
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case6: text without styles  ';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text';
  test.identical( got, expected );

  //

  test.description = 'coloring using directive in log';

  /**/

  logger.log( '#foreground : red#' );
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 1, 0 ,0 ] );
  var expected = '\u001b[31mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.log( '#background : red#' );
  logger.log( 'text' );
  test.identical( logger.backgroundColor, [ 1, 0 ,0 ] );
  var expected = '\u001b[41mtext\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  logger.log( '#foreground : red#' );
  logger.log( '#background : yellow#' );
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 1, 0 ,0 ] );
  test.identical( logger.backgroundColor, [ 1, 1 ,0 ] );
  var expected = '\u001b[31m\u001b[43mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  logger.log( '#foreground : xxx#' );
  logger.log( '#background : xxx#' );
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.foregroundColor, null );
  var expected = 'text';
  test.identical( _escaping( got ), _escaping( expected ) );

  //

  test.description = 'coloring using setter';

  /**/

  logger.foregroundColor = 'blue';
  logger.backgroundColor = 'white';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 0, 0, 1 ] );
  test.identical( logger.backgroundColor, [ 1, 1, 1 ] );
  if( isUnix )
  var expected = '\u001b[34m\u001b[107mtext\u001b[39m\u001b[49m';
  else
  var expected = '\u001b[34m\u001b[47mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /**/

  logger.foregroundColor = 'xxx';
  logger.backgroundColor = 'white';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, [ 1, 1, 1 ] );
  if( isUnix )
  var expected = '\u001b[107mtext\u001b[49m';
  else
  var expected = '\u001b[47mtext\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /**/

  var logger = new wLogger({ output : null, onWrite : onWrite });
  logger.foregroundColor = 'xxx';
  logger.backgroundColor = 'xxx';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text';
  test.identical( _escaping( got ), _escaping( expected ) );

  //

  test.description = 'stacking colors';
  var logger = new wLogger({ output : null, onWrite : onWrite });

  /**/

  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );

  logger.foregroundColor = 'red';
  logger.foregroundColor = 'blue';

  logger.backgroundColor = 'yellow';
  logger.backgroundColor = 'green';

  test.identical( logger.foregroundColor, [ 0, 0, 1 ] )
  test.identical( logger.backgroundColor, [ 0, 1, 0 ] )
  logger.log( 'text' );
  var expected = '\u001b[34m\u001b[42mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  //setting to default to get stacked color

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';

  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 1, 1, 0 ] );
  logger.log( 'text' );
  var expected = '\u001b[31m\u001b[43mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  //setting to default, no stacked colors, must be null

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';

  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  logger.log( 'text' );
  var expected = 'text';
  test.identical( _escaping( got ), _escaping( expected ) );

  //other

  test.description = 'coloring directive'

  /**/

  var logger = new wLogger({ output : null, onWrite : onWrite });
  logger.log( '#coloring : 0#' );
  logger.log( '#foreground : red#' );
  logger.log( '#background : yellow#' );
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 1, 1, 0 ] );
  logger.log( 'text' );
  var expected = 'text';
  test.identical( _escaping( got ), _escaping( expected ) );
  logger.log( '#coloring : 1#' );
  logger.log( 'text' );
  var expected = '\u001b[31m\u001b[43mtext\u001b[39m\u001b[49m';
  test.identical( _escaping( got ), _escaping( expected ) );

  /* stacking colors even if coloring is disabled */

  var logger = new wLogger({ output : null, onWrite : onWrite });
  logger.log( '#coloring : 0#' );
  logger.log( '#foreground : red#' );
  logger.log( '#foreground : blue#' );
  logger.log( '#background : red#' );
  logger.log( '#background : blue#' );
  test.identical( logger.foregroundColor, [ 0, 0, 1 ] );
  test.identical( logger.backgroundColor, [ 0, 0, 1 ] );
  logger.log( '#foreground : default#' );
  logger.log( '#background : default#' );
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 1, 0, 0 ] );
  logger.log( '#foreground : default#' );
  logger.log( '#background : default#' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  // test.identical( 0, 1 );
  //trackingColor problem, logger of test suite cant override it value correctly, directive is inside of it output

  test.description = 'trackingColor directive'

  /**/

  var logger = new wLogger({ output : null, onWrite : onWrite });
  logger.log( '#trackingColor : 0#' );
  logger.log( '#foreground : red#' );
  logger.log( '#foreground : blue#' );
  logger.log( '#background : red#' );
  logger.log( '#background : blue#' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );

  /**/

  var logger = new wLogger({ output : null, onWrite : onWrite });
  logger.log( '#trackingColor : 0#' );
  logger.log( '#foreground : red#' );
  logger.log( '#trackingColor : 1#' );
  logger.log( '#foreground : red#' );
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  logger.log( 'text' );
  var expected = '\u001b[31mtext\u001b[39m';
  test.identical( _escaping( got ), _escaping( expected ) );
  // test.identical( 0, 1 );
  //trackingColor problem, logger of test suite cant override it value correctly, directive is inside of it output

}

//

function shellColors( test )
{
  test.description = 'shell colors codes test';

  var logger = new wLogger();

  logger.foregroundColor = 'black';
  test.identical( logger.foregroundColor, [ 0, 0, 0 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 30 );

  logger.foregroundColor = 'light black';
  test.identical( logger.foregroundColor, [ 0.5, 0.5, 0.5 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 90 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;30' );

  logger.foregroundColor = 'red';
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 31 );

  logger.foregroundColor = 'light red';
  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 91 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;31' );

  logger.foregroundColor = 'green';
  test.identical( logger.foregroundColor, [ 0, 1, 0 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 32 );

  logger.foregroundColor = 'light green';
  test.identical( logger.foregroundColor, [ 0, 0.5, 0 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 92 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;32' );

  logger.foregroundColor = 'yellow';
  test.identical( logger.foregroundColor, [ 1, 1, 0 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 33 );

  logger.foregroundColor = 'light yellow';
  test.identical( logger.foregroundColor, [ 0.5, 0.5, 0 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 93 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;33' );

  logger.foregroundColor = 'blue';
  test.identical( logger.foregroundColor, [ 0, 0, 1 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 34 );

  logger.foregroundColor = 'light blue';
  test.identical( logger.foregroundColor, [ 0, 0, 0.5 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 94 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;34' );

  logger.foregroundColor = 'magenta';
  test.identical( logger.foregroundColor, [ 1, 0, 1 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 35 );

  logger.foregroundColor = 'light magenta';
  test.identical( logger.foregroundColor, [ 0.5, 0, 0.5 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 95 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;35' );

  logger.foregroundColor = 'cyan';
  test.identical( logger.foregroundColor, [ 0, 1, 1 ] );
  test.identical( logger._rgbToCode( logger.foregroundColor ), 36 );

  logger.foregroundColor = 'light cyan';
  test.identical( logger.foregroundColor, [ 0, 0.5, 0.5 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 96 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;36' );

  logger.foregroundColor = 'white';
  test.identical( logger.foregroundColor, [ 1, 1, 1 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 97 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), 37 );

  logger.foregroundColor = 'light white';
  test.identical( logger.foregroundColor, [ 0.9, 0.9, 0.9 ] );
  if( isUnix )
  test.identical( logger._rgbToCode( logger.foregroundColor ), 37 );
  else
  test.identical( logger._rgbToCode( logger.foregroundColor ), '1;37' );
}

//

var Self =
{

  name : 'Backend test',
  /* verbosity : 1, */

  tests :
  {

    simplest : simplest,
    colorConsole : colorConsole,
    shellColors : shellColors,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
