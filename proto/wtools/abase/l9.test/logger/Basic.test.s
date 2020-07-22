( function _Basic_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../l9/logger/entry/Logger.s' );
  _.include( 'wTesting' );
}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTester;

// --
// tests
// --

function consoleIs( test )
{
  test.case = 'LoggerBasic';
  var src = _.LoggerBasic;
  var got = _.consoleIs( src );
  test.identical( got, false );

  test.case = 'LoggerMid';
  var src = _.LoggerMid;
  var got = _.consoleIs( src );
  test.identical( got, false );

  test.case = 'LoggerTop';
  var src = _.LoggerTop;
  var got = _.consoleIs( src );
  test.identical( got, false );

  test.case = 'instance of Logger';
  var src = new _.Logger();
  var got = _.consoleIs( src );
  test.identical( got, false );
}

//

function printerIs( test )
{

  test.case = 'LoggerBasic';
  var src = _.LoggerBasic;
  debugger;
  var got = _.printerIs( src );
  test.identical( got, false );

  test.case = 'LoggerMid';
  var src = _.LoggerMid;
  var got = _.printerIs( src );
  test.identical( got, false );

  test.case = 'LoggerTop';
  var src = _.LoggerTop;
  var got = _.printerIs( src );
  test.identical( got, false );

  test.case = 'instance of Logger';
  var src = new _.Logger();
  var got = _.printerIs( src );
  test.identical( got, true );

}

//

function printerLike( test )
{
  test.case = 'LoggerBasic';
  var src = _.LoggerBasic;
  var got = _.printerLike( src );
  test.identical( got, false );

  test.case = 'LoggerMid';
  var src = _.LoggerMid;
  var got = _.printerLike( src );
  test.identical( got, false );

  test.case = 'LoggerTop';
  var src = _.LoggerTop;
  var got = _.printerLike( src );
  test.identical( got, false );

  test.case = 'instance of Logger';
  var src = new _.Logger();
  var got = _.printerLike( src );
  test.identical( got, true );

  test.case = 'console';
  var got = _.printerLike( console );
  test.identical( got, true );

}

//

function loggerIs( test )
{
  test.case = 'LoggerBasic';
  var src = _.LoggerBasic;
  var got = _.loggerIs( src );
  test.identical( got, false );

  test.case = 'LoggerMid';
  var src = _.LoggerMid;
  var got = _.loggerIs( src );
  test.identical( got, false );

  test.case = 'LoggerTop';
  var src = _.LoggerTop;
  var got = _.loggerIs( src );
  test.identical( got, false );

  test.case = 'instance of Logger';
  var src = new _.Logger();
  var got = _.loggerIs( src );
  test.identical( got, true );
}

//

function clone( test )
{
  test.case = 'clone chainer';

  var printer = new _.Logger({ name : 'printerA' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printer.outputTo( outputPrinter );
  printer.inputFrom( inputPrinter );

  var chainer = printer.chainer;
  var clonedChainer = chainer.clone();

  test.will = 'chainers must have same printer'

  test.identical( chainer.printer, clonedChainer.printer );
  test.identical( chainer.name, clonedChainer.name );

  test.will = 'chainers must have same inputs/outputs'

  test.identical( chainer.inputs.length, 1 );
  test.identical( chainer.outputs.length, 1 );

  test.identical( clonedChainer.inputs.length, 1 );
  test.identical( clonedChainer.outputs.length, 1 );

  test.identical( chainer.inputs[ 0 ].inputPrinter , clonedChainer.inputs[ 0 ].inputPrinter );
  test.identical( chainer.outputs[ 0 ].outputPrinter , clonedChainer.outputs[ 0 ].outputPrinter );

  test.will = 'cloned chainer reflects changes';

  printer.inputUnchain( inputPrinter );
  printer.outputUnchain( outputPrinter );

  test.identical( clonedChainer.inputs.length, 0 );
  test.identical( clonedChainer.outputs.length, 0 );

  test.identical( clonedChainer.outputs, chainer.outputs );
  test.identical( clonedChainer.inputs, chainer.inputs );
}

//

function finit( test )
{
  var o =
  {
    test,
    consoleWasBarred : false
  }

  try
  {
    // test.suite.consoleBar( o );
    _finit( test );
  }
  catch( err )
  {
    // if( o.consoleWasBarred )
    // test.suite.consoleBar( 1 );
    throw _.errLogOnce( err );
  }

  /* */

  function _finit( test )
  {

    /* +console -> ordinary -> self
    +printer -> ordinary -> self
    +console -> excluding -> self
    + printer -> excluding -> self
    +self -> ordinary -> console
    +self -> ordinary -> printer
    +self -> original -> console
    +self -> original -> printer */

    if( _.Logger.ConsoleIsBarred( console ) )
    {
      o.consoleWasBarred = true;
      test.suite.consoleBar( 0 );
    }


    test.open( 'console -> ordinary -> self' );

    var printer = new _.Logger();
    var printerBefore = printerGatherInfo( printer );
    var consoleBefore = printerGatherInfo( console );
    test.will = 'must not have console in inputs';
    test.is( !printer.hasInputClose( console ) );
    printer.inputFrom( console, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must have console in inputs after printer.inputFrom( console )';
    test.is( printer.hasInputClose( console ) );
    printer.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printer ) );
    test.will = 'console must not be chained with printer';
    test.is( printerIsNotChainedWith( console, printer ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerBefore, printer ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( consoleBefore, console ) );
    test.will = null;

    test.close( 'console -> ordinary -> self' );

    /* - */

    test.open( 'printer -> ordinary -> self' );

    test.case = 'self = printer, finit on left side of chain'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerB' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( printerB.hasInputClose( printerA ) );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    /* */

    test.case = 'self = printer, finit on right side of chain'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerB' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( printerB.hasInputClose( printerA ) );
    printerB.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    /* */

    test.case = 'self = console'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = console;
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( chainerGet( printerB ).hasInputClose( printerA ) );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'printer -> ordinary -> self' );

    /* - */

    test.open( 'console -> excluding -> self' );

    var printer = new _.Logger();
    var printerBefore = printerGatherInfo( printer );
    var consoleBefore = printerGatherInfo( console );
    test.will = 'must not have console in inputs';
    test.is( !printer.hasInputClose( console ) );
    printer.inputFrom( console, { exclusiveOutput : 1, originalOutput : 0 } );
    test.will = 'must have console in inputs after printer.inputFrom( console )';
    test.is( printer.hasInputClose( console ) );
    printer.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printer ) );
    test.will = 'console must not be chained with printer';
    test.is( printerIsNotChainedWith( console, printer ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerBefore, printer ) );
    test.will = 'console must not be modified';
    test.is( printerIsNotModified( consoleBefore, console ) );
    test.will = null;

    test.close( 'console -> excluding -> self' );

    /* - */

    test.open( 'printer -> excluding -> self' );

    test.case = 'self = printer, finit on left side of chain'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerB' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( printerB.hasInputClose( printerA ) );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    /* */

    test.case = 'self = printer, finit on right side of chain'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerB' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( printerB.hasInputClose( printerA ) );
    printerB.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'printer -> excluding -> self' );

    /* - */

    test.open( 'self -> ordinary -> console' );

    test.case = 'self = printer'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = console;
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( chainerGet( printerB ).hasInputClose( printerA ) );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'self -> ordinary -> console' );

    /* - */

    test.open( 'self -> ordinary -> printer' );

    test.case = 'self = printer'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerB' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0 } );
    test.will = 'must be chained';
    test.is( printerA.hasOutputClose( printerB ) );
    test.is( chainerGet( printerB ).hasInputClose( printerA ) );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.will = 'printerA must not be chained with printerB';
    test.is( printerIsNotChainedWith( printerA, printerB ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'self -> ordinary -> printer' );

    /* - */

    test.open( 'self -> original -> console' );

    test.case = 'self = printer'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = console;
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1 } );
    test.will = 'printerA.hasOutputClose( printerB ) must give negative becase of original chain';
    test.is( !printerA.hasOutputClose( printerB ) );
    test.will = 'but still have console in outputs';
    test.is( printerA.outputs[ 0 ].outputPrinter === printerB );
    test.will = 'printerB.hasInputClose( printerA ) must give negative becase of original chain';
    var consoleChainer = chainerGet( printerB );
    test.is( !consoleChainer.hasInputClose( printerA ) );
    test.will = 'but still have printerA in inputs';
    test.is( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter === printerA );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.will = 'printerB must not be chained with printerA';
    test.is( printerIsNotChainedWith( printerB, printerA ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'self -> original -> console' );

    /* - */

    test.open( 'self -> original -> printer' );

    test.case = 'self = printer'

    var printerA = new _.Logger({ name : 'printerA' });
    var printerB = new _.Logger({ name : 'printerA' });
    var printerABefore = printerGatherInfo( printerA );
    var printerBBefore = printerGatherInfo( printerB );

    test.will = 'must not have chains';
    test.is( printerIsNotChained( printerA ) );
    printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1 } );
    test.will = 'printerA.hasOutputClose( printerB ) must give negative becase of original chain';
    test.is( !printerA.hasOutputClose( printerB ) );
    test.will = 'but still have console in outputs';
    test.is( printerA.outputs[ 0 ].outputPrinter === printerB );
    test.will = 'printerB.hasInputClose( printerA ) must give negative becase of original chain';
    var consoleChainer = chainerGet( printerB );
    test.is( !consoleChainer.hasInputClose( printerA ) );
    test.will = 'but still have printerA in inputs';
    test.is( printerB.inputs[ 0 ].inputPrinter === printerA );
    printerA.finit();
    test.will = 'must not have any chains after finit';
    test.is( printerIsNotChained( printerA ) );
    test.is( printerIsNotChained( printerB ) );
    test.will = 'printer must not be modified';
    test.is( printerIsNotModified( printerABefore, printerA ) );
    test.is( printerIsNotModified( printerBBefore, printerB ) );
    test.will = null;

    test.close( 'self -> original -> printer' );

    /* - */

    if( o.consoleWasBarred )
    {
      test.suite.consoleBar( 1 );
      test.is( _.Logger.ConsoleIsBarred( console ) );
    }


    function printerGatherInfo( printer )
    {
      let info = Object.create( null );

      let chainer = chainerGet( printer );

      info.name = printer.name;
      info.keys = _.mapOwnKeys( printer );

      if( _.arrayLike( chainer.outputs ) )
      info.outputs = chainer.outputs.slice();

      if( _.arrayLike( chainer.inputs ) )
      info.inputs = chainer.inputs.slice();

      return info;
    }

    function chainerGet( src )
    {
      return src[ Symbol.for( 'chainer' ) ]
    }

    function printerIsNotModified( oldInfo, printer )
    {
      /* checks if printer was changed */

      let newInfo = printerGatherInfo( printer );
      let result = _.entityDiff( oldInfo, newInfo );
      if( result === false )
      return true;
      logger.log( 'Printer ',  printer.name, ' is changed!' );
      logger.log( result );
      return false;
    }

    function printerIsNotChained( printer )
    {
      /* checks if printer has any inputs/outputs */

      let chainer = chainerGet( printer );
      let chained = chainer.outputs.length > 1 || chainer.inputs.length;
      return !chained;
    }

    function printerIsNotChainedWith( printer, withPrinter )
    {
      /* checks if printer A is chained with B somehow */

      let chainer = chainerGet( printer );
      let chained = chainer.hasInputClose( withPrinter ) || chainer.hasOutputClose( withPrinter );
      return !chained;
    }
  }

}

// --
// declare
// --

let Self =
{

  name : 'Tools.logger.Basic',

  // routineTimeOut : 999999,

  silencing : 1,
  /* verbosity : 1, */

  tests :
  {

    consoleIs,
    printerIs,
    printerLike,
    loggerIs,

    clone,
    finit,

  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
