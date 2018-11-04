( function _Color_test_ss_( ) {

'use strict';



if( typeof module !== 'undefined' )
{

  require( '../../l9/printer/top/Logger.s' );
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//
var _global = _global_;
var _ = _global_.wTools;
var Parent = /*_.*/wTester;
var isUnix = process.platform !== 'win32' ? true : false;

//

var escape = function( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function colorConsole( test )
{

  var got;
  var onTransformEnd = function( args )
  {
    debugger;
    got = args.outputForTerminal[ 0 ];
  };
  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  test.case = 'case1: dark red text';
  logger.log( _.color.strFormatForeground( 'text', 'dark red') );
  var expected = '\u001b[31mtext\u001b[39;0m';
  test.identical( logger.foregroundColor, null );
  test.identical( escape( got ), escape( expected ) );

  test.case = 'case2: dark yellow background';
  logger.log( _.color.strFormatBackground( 'text', 'dark yellow') );
  test.identical( logger.backgroundColor, null );
  var expected = '\u001b[43mtext\u001b[49;0m';
  test.identical( escape( got ), escape( expected ) );

  test.case = 'case3: dark red text on dark yellow background';
  logger.log( _.color.strFormatBackground( _.color.strFormatForeground( 'text', 'dark red'), 'dark yellow') );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = '\u001b[31m\u001b[43mtext\u001b[49;0m\u001b[39;0m';
  debugger;
  test.identical( escape( got ), escape( expected ) );
  debugger;

  test.case = 'case4: dark yellow text on dark red background  + not styled text';
  logger.log( 'text' + _.color.strFormatForeground( _.color.strFormatBackground( 'text', 'dark red'), 'dark yellow') + 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text\u001b[33m\u001b[41mtext\u001b[49;0m\u001b[39;0mtext';
  test.identical( escape( got ), escape( expected ) );

  test.case = 'case5: unknown color ';
  test.shouldThrowError( () =>
  {
    logger.log( _.color.strFormatForeground( 'text', 'aa') );
  })
  test.identical( logger.foregroundColor, null );

  test.case = 'case6: text without styles  ';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text';
  test.identical( got, expected );

  //

  test.case = 'outputGray using directive in log';

  /**/

  logger.log( '#foreground : dark red#' );
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 0.5, 0 ,0 ] );
  var expected = '\u001b[31mtext\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.log( '#background : dark red#' );
  logger.log( 'text' );
  test.identical( logger.backgroundColor, [ 0.5, 0 ,0 ] );
  var expected = '\u001b[41mtext\u001b[49;0m';
  test.identical( escape( got ), escape( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  logger.log( '#foreground : dark red#' );
  logger.log( '#background : dark yellow#' );
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 0.5, 0 ,0 ] );
  test.identical( logger.backgroundColor, [ 0.5, 0.5 ,0 ] );
  var expected = '\u001b[31m\u001b[43mtext\u001b[49;0m\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  /**/

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';
  test.shouldThrowError( () =>
  {
    logger.log( '#foreground : aa#' );
  })
  test.shouldThrowError( () =>
  {
    logger.log( '#background : aa#' );
  })
  test.identical( logger.foregroundColor, null );
  test.identical( logger.foregroundColor, null );

  //

  test.case = 'outputGray using setter';

  /**/

  logger.foregroundColor = 'dark blue';
  logger.backgroundColor = 'dark white';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, [ 0, 0, 0.5 ] );
  test.identical( logger.backgroundColor, [ 0.9, 0.9, 0.9 ] );
  // if( isUnix )
  // var expected = '\u001b[34m\u001b[107mtext\u001b[39;0m\u001b[49;0m';
  // else
  var expected = '\u001b[34m\u001b[47mtext\u001b[49;0m\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  /**/

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  test.shouldThrowError( () =>
  {
    logger.foregroundColor = 'aa';
  })
  logger.backgroundColor = 'dark white';
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, [ 0.9, 0.9, 0.9 ] );
  // if( isUnix )
  // var expected = '\u001b[107mtext\u001b[49;0m';
  // else
  var expected = '\u001b[47mtext\u001b[49;0m';
  test.identical( escape( got ), escape( expected ) );

  /**/

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  test.shouldThrowError( () =>
  {
    logger.foregroundColor = 'aa';
  })
  test.shouldThrowError( () =>
  {
    logger.backgroundColor = 'aa';
  })
  logger.log( 'text' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  var expected = 'text';
  test.identical( escape( got ), escape( expected ) );

  //

  test.case = 'stacking colors';
  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  /**/

  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );

  logger.foregroundColor = 'dark red';
  logger.foregroundColor = 'dark blue';

  logger.backgroundColor = 'dark yellow';
  logger.backgroundColor = 'dark green';

  test.identical( logger.foregroundColor, [ 0, 0, 0.5 ] )
  test.identical( logger.backgroundColor, [ 0, 0.5, 0 ] )
  logger.log( 'text' );
  var expected = '\u001b[34m\u001b[42mtext\u001b[49;0m\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  //setting to default to get stacked color

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';

  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 0.5, 0.5, 0 ] );
  logger.log( 'text' );
  var expected = '\u001b[31m\u001b[43mtext\u001b[49;0m\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  //setting to default, no stacked colors, must be null

  logger.foregroundColor = 'default';
  logger.backgroundColor = 'default';

  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  logger.log( 'text' );
  var expected = 'text';
  test.identical( escape( got ), escape( expected ) );

  //other

  test.case = 'outputGray directive'

  /**/

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  logger.log( '#outputGray : 1#' );
  logger.log( '#foreground : dark red#' );
  logger.log( '#background : dark yellow#' );
  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 0.5, 0.5, 0 ] );
  logger.log( 'text' );
  var expected = 'text';
  test.identical( escape( got ), escape( expected ) );
  logger.log( '#outputGray : 0#' );
  logger.log( 'text' );
  var expected = '\u001b[31m\u001b[43mtext\u001b[49;0m\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );

  /* stacking colors even if outputGray is enabled */

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  logger.log( '#outputGray : 1#' );
  logger.log( '#foreground : dark red#' );
  logger.log( '#foreground : dark blue#' );
  logger.log( '#background : dark red#' );
  logger.log( '#background : dark blue#' );
  test.identical( logger.foregroundColor, [ 0, 0, 0.5 ] );
  test.identical( logger.backgroundColor, [ 0, 0, 0.5 ] );
  logger.log( '#foreground : default#' );
  logger.log( '#background : default#' );
  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  test.identical( logger.backgroundColor, [ 0.5, 0, 0 ] );
  logger.log( '#foreground : default#' );
  logger.log( '#background : default#' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );
  // test.identical( 0, 1 );
  //inputGray problem, logger of test suit cant override it value correctly, directive is inside of it output

  test.case = 'inputGray directive'

  /**/

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  logger.log( '#inputGray : 1#' );
  logger.log( '#foreground : dark red#' );
  logger.log( '#foreground : dark blue#' );
  logger.log( '#background : dark red#' );
  logger.log( '#background : dark blue#' );
  test.identical( logger.foregroundColor, null );
  test.identical( logger.backgroundColor, null );

  /**/

  var logger = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  logger.log( '#inputGray : 1#' );
  logger.log( '#foreground : dark red#' );
  logger.log( '#inputGray : 0#' );
  logger.log( '#foreground : dark red#' );
  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  logger.log( 'text' );
  var expected = '\u001b[31mtext\u001b[39;0m';
  test.identical( escape( got ), escape( expected ) );
  // test.identical( 0, 1 );
  //inputGray problem, logger of test suit cant override it value correctly, directive is inside of it output

}

//

function colorConsoleDirectives( test )
{
  let got;
  let fg = _.color.strFormatForeground;
  let bg = _.color.strFormatBackground;

  function onTransformEnd( o )
  {
    got = o;
    // console.log( test.case );
    // console.log( 'o.outputForTerminal:', escape( o.outputForTerminal[ 0 ] ) )
    // console.log( 'o.outputForPrinter', escape( o.outputForPrinter[ 0 ] ) )
  }

  let l = new _.Logger({ output : null, onTransformEnd : onTransformEnd  });

  test.open( 'setting states as property' )

  function runCase( o )
  {
    test.case =
    _.toStr
    ({
      ig : o.inputGray,
      og : o.outputGray,
      ir : o.inputRaw,
      or : o.outputRaw
    },
    {
      multiline : 0,
    });

    l.inputGray = o.inputGray;
    l.outputGray = o.outputGray;
    l.inputRaw = o.inputRaw;
    l.outputRaw = o.outputRaw;

    l.log( o.text );

    debugger;

    test.identical( escape( got.outputForTerminal[ 0 ] ), escape( o.outputForTerminal ) );
    test.identical( escape( got.outputForPrinter[ 0 ] ), escape( o.text ) );
  }

  runCase
  ({
    inputGray : 0,
    outputGray : 0,
    inputRaw : 0,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '\u001b[91mtext\u001b[39;0m'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 0,
    inputRaw : 0,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 1,
    inputRaw : 0,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : 'text'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 0,
    inputRaw : 1,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 0,
    inputRaw : 0,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : 'text'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 1,
    inputRaw : 1,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 1,
    inputRaw : 0,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 0,
    inputRaw : 1,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 0,
    inputRaw : 0,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 1,
    inputRaw : 1,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 1,
    inputRaw : 0,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : 'text'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 0,
    inputRaw : 1,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 1,
    inputRaw : 0,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 0,
    inputRaw : 1,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 1,
    outputGray : 1,
    inputRaw : 1,
    outputRaw : 0,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  runCase
  ({
    inputGray : 0,
    outputGray : 1,
    inputRaw : 1,
    outputRaw : 1,
    text : '#foreground: red#text#foreground: default#',
    outputForTerminal : '#foreground: red#text#foreground: default#'
  })

  test.close( 'setting states as property' );

  /* - */

  test.open( 'states combined with colored input' )

  let output = 'text';
  let coloredInput = '#fg: red#text#fg: default#';
  let coloredOutput = '\u001b[91mtext\u001b[39;0m'

  let inputGrayOn = '#inputGray:1#';
  let inputGrayOff = '#inputGray:0#';
  let outputGrayOn = '#outputGray:1#';
  let outputGrayOff = '#outputGray:0#';

  let inputRawOn = '#inputRaw:1#';
  let inputRawOff = '#inputRaw:0#';
  let outputRawOn = '#outputRaw:1#';
  let outputRawOff = '#outputRaw:0#';

  function runCase2( o )
  {
    test.case = o.case;

    var directiveOn = `#${o.directive}:1#`;
    var directiveOff = `#${o.directive}:0#`;
    var input = coloredInput + directiveOn + coloredInput + directiveOn + coloredInput + directiveOff + coloredInput + directiveOff + coloredInput;

    l.inputGray = o.other;
    l.outputGray = o.other;
    l.inputRaw = o.other;
    l.outputRaw = o.other;
    l[ o.directive ] = 0;

    l.log( input );
    test.identical( escape( got.outputForTerminal[ 0 ] ), escape( o.expected ) );
  }

  runCase2
  ({
    case : 'inputGray 0 - 1 - 2 - 1 - 0, other 0 ',
    other : 0,
    directive : 'inputGray',
    expected : coloredOutput + coloredInput + coloredInput + coloredInput + coloredOutput
  })

  runCase2
  ({
    case : 'outputGray 0 - 1 - 2 - 1 - 0, other 0 ',
    other : 0,
    directive : 'outputGray',
    expected : coloredOutput + output + output + output + coloredOutput
  })

  runCase2
  ({
    case : 'inputRaw 0 - 1 - 2 - 1 - 0, other 0 ',
    other : 0,
    directive : 'inputRaw',
    expected : coloredOutput + coloredInput + coloredInput + coloredInput + coloredOutput
  })

  runCase2
  ({
    case : 'outputRaw 0 - 1 - 2 - 1 - 0, other 0 ',
    other : 0,
    directive : 'outputRaw',
    expected : coloredOutput + output + output + output + coloredOutput
  })

  /**/

  runCase2
  ({
    case : 'inputGray 0 - 1 - 2 - 1 - 0, other 1 ',
    other : 1,
    directive : 'inputGray',
    expected : coloredInput + inputGrayOn + coloredInput + inputGrayOn + coloredInput + inputGrayOff + coloredInput + inputGrayOff + coloredInput
  })

  runCase2
  ({
    case : 'outputGray 0 - 1 - 2 - 1 - 0, other 1 ',
    other : 1,
    directive : 'outputGray',
    expected : coloredInput + outputGrayOn + coloredInput + outputGrayOn + coloredInput + outputGrayOff + coloredInput + outputGrayOff + coloredInput
  })

  runCase2
  ({
    case : 'inputRaw 0 - 1 - 2 - 1 - 0, other 1 ',
    other : 1,
    directive : 'inputRaw',
    expected : coloredInput + coloredInput + coloredInput + coloredInput + coloredInput
  })

  runCase2
  ({
    case : 'outputRaw 0 - 1 - 2 - 1 - 0, other 1 ',
    other : 1,
    directive : 'outputRaw',
    expected : coloredInput + outputRawOn + coloredInput + outputRawOn + coloredInput + outputRawOff + coloredInput + outputRawOff + coloredInput
  })

  /**/

  runCase2
  ({
    case : 'inputGray 0 - 1 - 2 - 1 - 0, other 2 ',
    other : 2,
    directive : 'inputGray',
    expected : coloredInput + inputGrayOn + coloredInput + inputGrayOn + coloredInput + inputGrayOff + coloredInput + inputGrayOff + coloredInput
  })

  runCase2
  ({
    case : 'outputGray 0 - 1 - 2 - 1 - 0, other 2 ',
    other : 2,
    directive : 'outputGray',
    expected : coloredInput + outputGrayOn + coloredInput + outputGrayOn + coloredInput + outputGrayOff + coloredInput + outputGrayOff + coloredInput
  })

  runCase2
  ({
    case : 'inputRaw 0 - 1 - 2 - 1 - 0, other 2 ',
    other : 2,
    directive : 'inputRaw',
    expected : coloredInput + coloredInput + coloredInput + coloredInput + coloredInput
  })

  runCase2
  ({
    case : 'outputRaw 0 - 1 - 2 - 1 - 0, other 2 ',
    other : 2,
    directive : 'outputRaw',
    expected : coloredInput + outputRawOn + coloredInput + outputRawOn + coloredInput + outputRawOff + coloredInput + outputRawOff + coloredInput
  })

  test.close( 'states combined with colored input' )
}

//

function shellColors( test )
{

  test.case = 'shell colors codes test';

  var logger = new _.Logger({ output : console });

  logger.foregroundColor = 'dark black';
  test.identical( logger.foregroundColor, [ 0, 0, 0 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '30' );


  logger.foregroundColor = 'bright black';
  test.identical( logger.foregroundColor, [ 0.5, 0.5, 0.5 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '90' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;30' );

  logger.foregroundColor = 'dark red';
  test.identical( logger.foregroundColor, [ 0.5, 0, 0 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '31' );

  logger.foregroundColor = 'red';
  test.identical( logger.foregroundColor, [ 1, 0, 0 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '91' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;31' );

  logger.foregroundColor = 'dark green';
  test.identical( logger.foregroundColor, [ 0, 0.5, 0 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '32' );

  logger.foregroundColor = 'green';
  test.identical( logger.foregroundColor, [ 0, 1, 0 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '92' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;32' );

  logger.foregroundColor = 'dark yellow';
  test.identical( logger.foregroundColor, [ 0.5, 0.5, 0 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '33' );

  logger.foregroundColor = 'yellow';
  test.identical( logger.foregroundColor, [ 1, 1, 0 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '93' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;33' );

  logger.foregroundColor = 'dark blue';
  test.identical( logger.foregroundColor, [ 0, 0, 0.5 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '34' );

  logger.foregroundColor = 'blue';
  test.identical( logger.foregroundColor, [ 0, 0, 1 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '94' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;34' );

  logger.foregroundColor = 'dark magenta';
  test.identical( logger.foregroundColor, [ 0.5, 0, 0.5 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '35' );

  logger.foregroundColor = 'magenta';
  test.identical( logger.foregroundColor, [ 1, 0, 1] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '95' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;35' );

  logger.foregroundColor = 'dark cyan';
  test.identical( logger.foregroundColor, [ 0, 0.5, 0.5 ] );
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '36' );

  logger.foregroundColor = 'cyan';
  test.identical( logger.foregroundColor, [ 0, 1, 1 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '96' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;36' );

  logger.foregroundColor = 'dark white';
  test.identical( logger.foregroundColor, [ 0.9, 0.9, 0.9 ] );
  // if( isUnix )
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), 97 );
  // else
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '37' );

  logger.foregroundColor = 'white';
  test.identical( logger.foregroundColor, [ 1, 1, 1 ] );
  // if( isUnix )
  test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '97' );
  // else
  // test.identical( logger._rgbToCode_nodejs( logger.foregroundColor ), '1;37' );
}

//

var Self =
{

  name : 'Tools/base/printer/Color/Shell',
  silencing : 1,

  tests :
  {
    colorConsole : colorConsole,
    colorConsoleDirectives : colorConsoleDirectives,
    shellColors : shellColors,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
/*_.*/wTester.test( Self.name );

} )( );
