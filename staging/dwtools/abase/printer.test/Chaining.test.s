( function _Chaining_test_s_( ) {

'use strict';



if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.Tester;

//

var _escaping = function( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

function log()
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

function levelsTest( test )
{
  var logger = new _.Logger({ output : null });
  var l = new _.Logger({ output : logger });

  logger._dprefix = '-';
  l._dprefix = '-';

  test.case = 'case1 : ';
  logger.up( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case2 : add 2 levels, first logger level must be  2';
  l.up( 2 );
  var got = logger.log( 'abc' );
  var expected = logger;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case3 : current levels of loggers must be equal';
  var got = l.level;
  var expected = logger.level;
  test.identical( got, expected );

  test.case = 'case4 : logger level - 2, l level - 4, text must have level 6 ';
  l.up( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case5 : zero level';
  l.down( 4 );
  logger.down( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  if( Config.debug )
  {
    test.case = 'level cant be less then zero';
    test.shouldThrowError( function( )
    {
      l.down( 10 );
    })
  }

}

//

function chaining( test )
{
  function onTransformEnd( o )
  {
    got.push( o.outputForPrinter[ 0 ] )
  };

  test.case = 'case1: l2 -> l1';
  var got = [];
  var l1 = new _.Logger( { output : null, onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger( { output : l1 } );
  l2.log( '1' );
  l2.log( '2' );
  var expected = [ '1', '2' ];
  test.identical( got, expected );

  test.case = 'case2: l3 -> l2 -> l1';
  var got = [];
  var l1 = new _.Logger( { output : null, onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger( { output : l1, onTransformEnd : onTransformEnd } );
  var l3 = new _.Logger( { output : l2 } );
  l2.log( 'l2' );
  l3.log( 'l3' );
  var expected = [ 'l2', 'l2', 'l3', 'l3' ];
  test.identical( got, expected );

  test.case = 'case3: l4->l3->l2->l1';
  var got = [];
  var l1 = new _.Logger( { output : null, onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger( { output : l1, onTransformEnd : onTransformEnd } );
  var l3 = new _.Logger( { output : l2, onTransformEnd : onTransformEnd } );
  var l4 = new _.Logger( { output : l3, onTransformEnd : onTransformEnd } );
  l4.log( 'l4' );
  l3.log( 'l3' );
  l2.log( 'l2' );
  var expected =
  [
    'l4', 'l4', 'l4', 'l4',
    'l3', 'l3', 'l3',
    'l2', 'l2',
  ];
  test.identical( got, expected );

  test.case = 'case4: l1 <- l2 <- l3 <- l4 ';
  var got = [];
  var l1 = new _.Logger( { output : null, onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger( { onTransformEnd : onTransformEnd } );
  var l3 = new _.Logger( { onTransformEnd : onTransformEnd } );
  var l4 = new _.Logger( { onTransformEnd : onTransformEnd } );
  l3.inputFrom( l4 );
  l2.inputFrom( l3 );
  l1.inputFrom( l2 );

  l4.log( 'l4' );
  l3.log( 'l3' );
  l2.log( 'l2' );
  var expected =
  [
    'l4', 'l4', 'l4', 'l4',
    'l3', 'l3', 'l3',
    'l2', 'l2',
  ];
  test.identical( got, expected );

  // test.case = 'case5: l1->l2->l3 leveling off ';
  // var l1 = new _.Logger({ output : console });
  // var l2 = new _.Logger({ output : console });
  // var l3 = new _.Logger({ output : console });
  // l1.outputTo( l2, { combining : 'rewrite', leveling : '' } );
  // l2.outputTo( l3, { combining : 'rewrite', leveling : '' } );
  // l1.up( 2 );
  // l2.up( 2 );
  // var got =
  // [
  //   l1.level,
  //   l2.level,
  //   l3.level,
  // ];
  // var expected = [ 2, 2, 0 ];
  // test.identical( got, expected );

  // test.case = 'case6: l1->l2->l3 leveling on ';
  // var l1 = new _.Logger({ output : console });
  // var l2 = new _.Logger({ output : console });
  // var l3 = new _.Logger({ output : console });
  // l1.outputTo( l2, { combining : 'rewrite', leveling : 'delta' } );
  // l2.outputTo( l3, { combining : 'rewrite', leveling : 'delta' } );
  // l1.up( 2 );
  // var got =
  // [
  //   l1.level,
  //   l2.level,
  //   l3.level,
  // ];
  // var expected = [ 2, 2, 2 ];
  // test.identical( got, expected );
}

//

function _consoleChaining( o )
{
  let test = o.test;

  if( _.Logger.consoleIsBarred( console ) )
  {
    o.consoleWasBarred = true;
    debugger
    test.suite.consoleBar( 0 );
  }

  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'inputFrom console that exists in outputs';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.inputFrom( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );


  //

  test.case = 'inputFrom console that not exists in outputs';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  test.is( l.hasInputClose( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputClose( console ) );

  //

  test.case = 'inputFrom console that exists in outputs, exclusiveOutput on';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.inputFrom( console, { exclusiveOutput : 1  } ) );

  //

  test.case = 'inputFrom console that not exists in outputs, exclusiveOutput on';
  var l = new _.Logger({ output : null });
  l.inputFrom( console, { exclusiveOutput : 1 } );
  test.is( l.hasInputClose( console ) );
  test.is( _.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputClose( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  debugger

  //

  if( Config.debug )
  {
    test.case = 'console is excluded, try to chain again';
    var l = new _.Logger({ output : null });
    l.inputFrom( console, { exclusiveOutput : 1 } );
    test.is( l.hasInputClose( console ) );
    test.is( _.Logger.consoleIsBarred( console ) );
    test.shouldThrowError( () => l.inputFrom( console, { exclusiveOutput : 1 } ) );
    l.inputUnchain( console );
    test.is( !l.hasInputClose( console ) );
    test.is( !_.Logger.consoleIsBarred( console ) );
  }

  //

  test.case = 'outputTo console that exists in outputs';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.outputTo( console ) );
  test.is( console.inputs === undefined || console.inputs.indexOf( l ) === -1 );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in outputs, originalOutput on';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.outputTo( console, { originalOutput : 1 } ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in inputs, originalOutput off';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  test.shouldThrowError( () => l.outputTo( console, { originalOutput : 0 } ) );
  test.is( !l.hasOutputClose( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputClose( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in inputs, originalOutput on';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  l.outputTo( console, { originalOutput : 1 } );
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( l.outputs[ l.outputs.length - 1 ] === consoleChainer.inputs[ consoleChainer.inputs.length - 1 ] );
  l.inputUnchain( console );
  l.outputUnchain( console );
  test.is( !l.hasInputClose( console ) && !l.inputs.length );
  test.is( !l.hasOutputClose( console ) && !l.outputs.length );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'console is not excluded, several inputs for console';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.input[ 0 ] );
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  l4.inputFrom( console, { combining : 'append' } );
  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.inputUnchain( console );
  test.identical( received, [ 'l1', 'l2', 'l3' ] );

  //

  test.case = 'console is not excluded, several outputs from console';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.input[ 0 ] );
  var l1 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l2 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l3 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  l1.inputFrom( console, { combining : 'append' } );
  l2.inputFrom( console, { combining : 'append' } );
  l3.inputFrom( console, { combining : 'append' } );
  console.log( 'msg' );
  l1.inputUnchain( console );
  l2.inputUnchain( console );
  l3.inputUnchain( console );
  test.identical( received, [ 'msg', 'msg', 'msg' ] );

  //

  test.case = 'console is not excluded, several outputs/inputs';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.input[ 0 ] );

  /*inputs*/

  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });

  /*outputs*/

  var l4 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l5 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l6 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  l4.inputFrom( console, { combining : 'append' } );
  l5.inputFrom( console, { combining : 'append' } );
  l6.inputFrom( console, { combining : 'append' } );

  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );

  l1.outputUnchain( console );
  l2.outputUnchain( console );
  l3.outputUnchain( console );
  l4.inputUnchain( console );
  l5.inputUnchain( console );
  l6.inputUnchain( console );

  test.identical( received, [ 'l1', 'l1', 'l1', 'l2', 'l2', 'l2', 'l3', 'l3', 'l3' ] );

  //

  if( o.consoleWasBarred )
  {
    test.suite.consoleBar( 1 );
    test.is( _.Logger.consoleIsBarred( console ) );
  }


  //

  test.case = 'console is excluded, several inputs for console';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  l4.inputFrom( console, { combining : 'append' } );
  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.inputUnchain( console );
  test.identical( received, [] );

  //

  test.case = 'console is excluded, several outputs from console';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l2 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l3 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  l1.inputFrom( console, { combining : 'append' } );
  l2.inputFrom( console, { combining : 'append' } );
  l3.inputFrom( console, { combining : 'append' } );
  console.log( 'msg' );
  l1.inputUnchain( console );
  l2.inputUnchain( console );
  l3.inputUnchain( console );
  test.identical( received, [] );

  //

  //

  test.case = 'console is excluded, several outputs/inputs';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onTransformEnd = ( o ) => received.push( o.output[ 0 ] );

  /*inputs*/

  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });

  /*outputs*/

  var l4 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l5 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });
  var l6 = new _.Logger({ output : null, onTransformEnd : onTransformEnd });

  l4.inputFrom( console, { combining : 'append' } );
  l5.inputFrom( console, { combining : 'append' } );
  l6.inputFrom( console, { combining : 'append' } );

  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );

  l1.outputUnchain( console );
  l2.outputUnchain( console );
  l3.outputUnchain( console );
  l4.inputUnchain( console );
  l5.inputUnchain( console );
  l6.inputUnchain( console );

  test.identical( received, [] );

  //

  test.case = 'if console is excluded, other console outputs must be omitted';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var l = new _.Logger
  ({
    output : null,
    onTransformEnd : ( o ) => received.push( o.input[ 0 ] )
  })
  l.inputFrom( console );
  test.is( l.hasInputClose( console ) );
  console.log( 'message' );
  l.inputUnchain( console );
  test.is( _.Logger.consoleIsBarred( console ) );
  test.identical( received, [] )

  //
}

//

function consoleChaining( test )
{
  var o =
  {
    test : test,
    consoleWasBarred : false
  }

  try
  {
    _consoleChaining( o );
  }
  catch( err )
  {
    if( o.consoleWasBarred )
    test.suite.consoleBar( 1 );

    throw _.errLogOnce( err );
  }

}

//

function chainingParallel( test )
{
  function onTransformEnd( o ) { got.push( o.input[ 0 ] ) };

  test.case = 'case1: 1 -> *';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd  });
  var l2 = new _.Logger({ onTransformEnd : onTransformEnd  });
  var l3 = new _.Logger({ onTransformEnd : onTransformEnd  });
  var l4 = new _.Logger({ output : console });
  l4.outputTo( l3, { combining : 'append' } );
  l4.outputTo( l2, { combining : 'append' } );
  l4.outputTo( l1, { combining : 'append' } );

  l4.log( 'msg' );
  var expected = [ 'msg','msg','msg' ];
  test.identical( got, expected );

  test.case = 'case2: many inputs to 1 logger';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l2.outputTo( l1, { combining : 'rewrite' } );
  l3.outputTo( l1, { combining : 'rewrite' } );
  l4.outputTo( l1, { combining : 'rewrite' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );

  test.case = 'case3: many inputs to 1 logger';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd  });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l1.inputFrom( l2, { combining : 'append' } );
  l1.inputFrom( l3, { combining : 'append' } );
  l1.inputFrom( l4, { combining : 'append' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );

  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );

  test.case = 'case3: 1 logger to many loggers';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l2 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l3 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l4 = new _.Logger({ onTransformEnd : onTransformEnd });
  l1.outputTo( l2, { combining : 'append' } );
  l1.outputTo( l3, { combining : 'append' } );
  l1.outputTo( l4, { combining : 'append' } );

  l1.log( 'msg' );
  var expected = [ 'msg', 'msg', 'msg', 'msg' ]
  test.identical( got, expected );

  test.case = 'case3: many loggers from 1 logger';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l2 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l3 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l4 = new _.Logger({ onTransformEnd : onTransformEnd });
  l2.inputFrom( l1, { combining : 'append' } );
  l3.inputFrom( l1, { combining : 'append' } );
  l4.inputFrom( l1, { combining : 'append' } );

  l1.log( 'msg' );
  var expected = [ 'msg', 'msg', 'msg', 'msg' ]
  test.identical( got, expected );

  test.case = 'case3:  *inputs ->  1 -> *outputs ';
  var got = [];
  var l1 = new _.Logger( { output : null  } );

  /* input */
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l1.inputFrom( l2, { combining : 'append' } );
  l1.inputFrom( l3, { combining : 'append' } );
  l1.inputFrom( l4, { combining : 'append' } );

  /* output */
  var l5 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l6 = new _.Logger({ onTransformEnd : onTransformEnd });
  var l7 = new _.Logger({ onTransformEnd : onTransformEnd });

  l1.outputTo( l5, { combining : 'append' } );
  l1.outputTo( l6, { combining : 'append' } );
  l1.outputTo( l7, { combining : 'append' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l2','l2','l3','l3','l3','l4','l4','l4' ];
  test.identical( got, expected );

  //

  test.case = 'case4: outputTo/inputFrom, remove some outputs ';
  var got = [];
  var l1 = new _.Logger({ onTransformEnd : onTransformEnd  });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l1.inputFrom( l2, { combining : 'rewrite' } );
  l1.inputFrom( l3, { combining : 'append' } );
  l4.outputTo( l1, { combining : 'rewrite' } );

  l2.outputUnchain( l1 );
  l1.inputUnchain( l4 );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l3' ];
  test.identical( got, expected );

  // test.case = 'case5: l1->* leveling off ';
  // var l1 = new _.Logger({ output : console });
  // var l2 = new _.Logger({ output : console });
  // var l3 = new _.Logger({ output : console });
  // l1.outputTo( l2, { combining : 'rewrite', leveling : '' } );
  // l1.outputTo( l3, { combining : 'append', leveling : '' } );
  // l1.up( 2 );
  // var got =
  // [
  //   l1.level,
  //   l2.level,
  //   l3.level,
  // ];
  // var expected = [ 2, 0, 0 ];
  // test.identical( got, expected );
  //
  // test.case = 'case6: l1->* leveling on ';
  // var l1 = new _.Logger({ output : console });
  // var l2 = new _.Logger({ output : console });
  // var l3 = new _.Logger({ output : console });
  // l1.outputTo( l2, { combining : 'rewrite', leveling : 'delta' } );
  // l1.outputTo( l3, { combining : 'append', leveling : 'delta' } );
  // l1.up( 2 );
  // var got =
  // [
  //   l1.level,
  //   l2.level,
  //   l3.level,
  // ];
  // var expected = [ 2, 2, 2 ];
  // test.identical( got, expected );

  // !!! needs silencing = false
  // test.case = 'case7: input from console twice ';
  // var l1 = new _.Logger({ output : null,onTransformEnd : onTransformEnd });
  // var l2 = new _.Logger({ output : null,onTransformEnd : onTransformEnd });
  // l1.inputFrom( console );
  // l2.inputFrom( console );
  // var got = [];
  // console.log('something');
  // l1.inputUnchain( console );
  // l2.inputUnchain( console );
  // var expected = [ 'something', 'something' ];
  // test.identical( got, expected );
}

//

function outputTo( test )
{

  test.case = 'output already exist';

  test.identical( got, expected );
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    var l1 = new _.Logger({ output : console });
    l.outputTo( l1, { combining : 'append' } );
    l.outputTo( l1, { combining : 'append' } );
  });

  test.case = 'output already exist, combining : rewrite';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'append' } );
  l.outputTo( l1, { combining : 'rewrite' } );
  test.is( l1.hasInputClose( l ) )

  //

  test.case = 'few logger are writting into console'
  var l = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : null });
  var l3 = new _.Logger({ output : null });

  l.outputTo( console );
  l2.outputTo( console );
  l3.outputTo( console );

  var got = [];
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  var outputPrinter = consoleChainer.outputs[ 0 ].outputPrinter;
  var onTransformEndTemp = outputPrinter.onTransformEnd;
  outputPrinter.onTransformEnd = ( o ) => got.push( o.input[ 0 ] );
  l.log( 1 );
  l2.log( 2 );
  l3.log( 3 );
  outputPrinter.onTransformEnd = onTransformEndTemp;
  test.identical( got, [ '1', '2', '3' ] );

  //

  test.case = 'chain console as output, check descriptor';
  var l = new _.Logger({ output : console });
  var got = l.outputs[ 0 ].outputPrinter;
  var expected = console;
  l.outputUnchain( console )
  test.identical( got, expected );

  test.case = 'empty output';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () =>
  {
    l.outputTo( null, { combining : 'rewrite' } );
  })
  test.identical( l.outputs.length, 1 );

  test.case = 'empty output';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () =>
  {
    l.outputTo( {}, { combining : 'rewrite' } );
  })
  test.identical( l.outputs.length, 1 );

  test.case = 'rewrite';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'rewrite' } );
  var got = ( l.output === l1 && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

  /*append*/
  test.case = 'append';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'append' } );
  var got = ( l.output === l1 && l.outputs.length === 2 );
  var expected = true;
  test.identical( got, expected );

  test.case = 'append list is empty';
  var l = new _.Logger({ output : null});
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'append' } );
  var got = ( l.output === l1 && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

  test.case = 'append null';
  var l = new _.Logger({ output : console });
  test.shouldThrowErrorSync( function()
  {
    l.outputTo( null, { combining : 'append' } );
  })


  test.case = 'append existing';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'append' } );
  test.shouldThrowError(function()
  {
    l.outputTo( l1, { combining : 'append' } );
  })

  /*prepend*/
  test.case = 'prepend';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'prepend' } );
  var got = ( l.outputs[ 0 ].output === l1 && l.outputs.length === 2 );
  var expected = true;
  test.identical( got, expected );

  test.case = 'prepend existing';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'prepend' } );
  test.shouldThrowError(function()
  {

    l.outputTo( l1, { combining : 'prepend' } );
  })

  test.case = 'prepend null';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'prepend' } );
  test.shouldThrowErrorSync( function()
  {
    var got = l.outputTo( null, { combining : 'prepend' } );

  })

  /*supplement*/
  test.case = 'try supplement not empty list';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  var got = l.outputTo( l1, { combining : 'supplement' } );
  var expected = false;
  test.identical( got, expected );

  test.case = 'supplement';
  var l = new _.Logger({  output : null });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'supplement' } );
  var got = ( l.output && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

  test.case = 'supplement null';
  var l = new _.Logger({ output : console });
  test.shouldThrowErrorSync( function()
  {
    var got = l.outputTo( null, { combining : 'supplement' } );

  })

  /*combining off*/
  test.case = 'combining off';
  var l = new _.Logger({  output : null });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1 );
  var got = ( l.output && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

  //

  if( !Config.debug )
  return;

  var l = new _.Logger({ output : console });

  //

  test.case = 'no args';
  test.shouldThrowError( function()
  {
    l.outputTo();
  });

  //

  test.case = 'output is not a Object';
  test.shouldThrowError( function()
  {
    l.outputTo( 'output', { combining : 'rewrite' } );
  });

  //

  test.case = 'not allowed combining mode';
  test.shouldThrowError( function()
  {
    l.outputTo( console, { combining : 'mode' } );
  });

  // test.case = 'not allowed leveling mode';
  // test.shouldThrowError( function()
  // {
  //   l.outputTo( console, { combining : 'rewrite', leveling : 'mode' } );
  // });

  test.case = 'empty call';
  test.shouldThrowError( function()
  {
    l.outputTo( )
  });

  //

  test.case = 'invalid output type';
  test.shouldThrowError( function()
  {
    l.outputTo( '1' )
  });

  //

  test.case = 'invalid combining type';
  test.shouldThrowError( function()
  {
    l.outputTo( console, { combining : 'invalid' } );
  });

  //

  test.case = 'invalid leveling type';
  test.shouldThrowError( function()
  {
    l.outputTo( console, { leveling : 'invalid' } );
  });

  //

  test.case = 'combining off, outputs not empty';
  test.shouldThrowError( function()
  {
    l.outputTo( console );
  });

  //

  test.case = ' ';
  var l1 = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : console });
  test.shouldThrowError( function()
  {
    l1.inputFrom( console );
    l1.outputTo( l2, { combining : 'append' } )
  });
  l1.inputUnchain( console );
}

//

function outputUnchain( test )
{
  function onTransformEnd( args ) { got.push( args.output[ 0 ] ) };

  test.case = 'case1 delete l1 from l2 outputs, l2 still have one output';
  var got = [];
  var l1 = new _.Logger( { onTransformEnd : onTransformEnd  } );
  var l2 = new _.Logger( { onTransformEnd : onTransformEnd  } );
  l2.outputTo( l1, { combining : 'append' } );
  l2.outputUnchain( l1 )
  l2.log( 'msg' );
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.case = 'case2 delete l1 from l2 outputs, no msg transfered';
  var got = [];
  var l1 = new _.Logger( { onTransformEnd : onTransformEnd  } );
  var l2 = new _.Logger({ output : console });
  l2.outputTo( l1, { combining : 'rewrite' } );
  l2.outputUnchain( l1 );
  l2.log( 'msg' )
  var expected = [];
  test.identical( got, expected );

  test.case = 'case3: delete l1 from l2 outputs';
  var got = [];
  var l1 = new _.Logger( { onTransformEnd : onTransformEnd  } );
  var l2 = new _.Logger( { onTransformEnd : onTransformEnd  } );
  var l3 = new _.Logger({ output : console });
  l2.outputTo( l1, { combining : 'append' } );
  l3.outputTo( l2, { combining : 'append' } );
  l2.outputUnchain( l1 );
  l3.log( 'msg' )
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.case = 'no args - remove all outputs';
  var l1 = new _.Logger({ output : console });
  test.identical( l1.outputs.length, 1 );
  l1.outputUnchain();
  test.identical( l1.outputs.length, 0 );

  test.case = 'empty outputs list';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.outputTo( l1, { combining : 'rewrite' } );
  l.outputUnchain( l1 );
  test.identical( l.outputs.length, 0 );
  var got = l.outputUnchain( l1 );
  test.identical( got, false );

  //

  test.case = 'remove console from output';
  var l = new _.Logger({ output : console });
  var got = l.outputUnchain( console );
  var expected = true;
  test.identical( got, expected );

  test.case = 'output not exists';
  var l = new _.Logger({ output : console });
  var got = l.outputUnchain( {} );
  var expected = false;
  test.identical( got, expected );

  test.case = 'remove from output';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : l1 });
  var got = [ l2.outputUnchain( l1 ), l2.outputs.length, l1.inputs.length]
  var expected = [ true, 0, 0 ];
  test.identical( got, expected );

  test.case = 'remove from output';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  l2.outputTo( l1, { combining : 'append' } );
  var got = [ l2.outputUnchain( l1 ), l2.outputs.length, l1.inputs.length ]
  var expected = [ true, 1, 0 ];
  test.identical( got, expected );

  test.case = 'no args';
  var l = new _.Logger({ output : console });
  test.identical( l.outputs.length, 1 );
  l.outputUnchain();
  test.identical( l.outputs.length, 0 );


  test.case = 'output is not a object';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    l.outputUnchain( 1 );
  });

  test.case = 'empty ouputs';
  var l = new _.Logger({ output : null });
  var got = l.outputUnchain( console );
  test.identical( got, false )

  test.case = 'try to remove itself';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    l.outputUnchain( l );
  });

  if( !Config.debug )
  return;

  test.case = 'incorrect type';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    l.outputUnchain( '1' );
  });
}

//

function inputFrom( test )
{
  var onTransformEnd = function( args ){ got.push( args.output[ 0 ] ) };

  test.case = 'case1: input already exist';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : console });
    var l2 = new _.Logger({ output : l1 });
    l1.inputFrom( l2 );
  });

  test.case = 'case2: input already exist';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    var l1 = new _.Logger({ output : console });
    l.outputTo( l1, { combining : 'append' } )
    l1.inputFrom( l );
  });

  // !!! needs silencing = false
  //
  // test.case = 'case3: console as input';
  // var got = [];
  // var l = new _.Logger( { output : null, onTransformEnd : onTransformEnd } );
  // l.inputFrom( console );
  // l._prefix = '*';
  // console.log( 'abc' )
  // var expected = [ '*abc' ];
  // l.inputUnchain( console );
  // test.identical( got, expected );

  test.case = 'case4: logger as input';
  var got = [];
  var l = new _.Logger( { onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger( );
  l.inputFrom( l2 );
  l._prefix = '--';
  l2.log( 'abc' )
  var expected = [ '--abc' ];
  test.identical( got, expected );

  //

  test.case = 'try to add existing input';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : l });
  test.shouldThrowError( function()
  {
    l.inputFrom( l1 );
  });

  test.case = 'try to add console that exists in output';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( function()
  {
    l.inputFrom( console );
  });

  test.case = 'try to add console';
  var l = new _.Logger({ output : null });
  var got = [ l.inputFrom( console ), l.inputs.length ];
  var expected = [ true, 1 ];
  l.inputUnchain( console );
  test.identical( got, expected );

  test.case = 'try to add other logger';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  var got = [ l.inputFrom( l1 ), l.inputs.length,l1.outputs.length ];
  var expected = [ true, 1, 2 ];
  test.identical( got, expected );

  test.case = 'try to add itself';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    l.inputFrom( l );
  });

  test.case = 'try to add null';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    l.inputFrom( null );
  });

  test.case = 'simple recursion';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : console });
    var l1 = new _.Logger({ output : console });
    l1.inputFrom( l );
    l1.inputFrom( l1 );
  });

  test.case = 'l1->l2,l2->l3,l3->l1';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : console });
    var l2 = new _.Logger({ output : console });
    var l3 = new _.Logger({ output : console });
    l1.inputFrom( l3 );
    l2.inputFrom( l1 );
    l3.inputFrom( l2 );
  });

  test.case = 'console->l1->l2->console';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : null });
  test.shouldThrowError( function()
  {
    l2.inputFrom( console );
    l1.inputFrom( l2 );
  });
  l2.inputUnchain( console );

  //

  if( !Config.debug )
  return;

  var l = new _.Logger({ output : console });

  //

  test.case = 'no args';
  test.shouldThrowError( function()
  {
    l.inputFrom();
  });

  //

  test.case = 'incorrect type';
  test.shouldThrowError( function()
  {
    l.inputFrom( '1' );
  });

  //

  test.case = 'console exists as output';
  test.shouldThrowError( function()
  {
    l.inputFrom( console );
  });
}

//

function inputUnchain( test )
{
  var onTransformEnd = function( args ){ got.push( args[0] ) };

  test.case = 'case1: input not exist in the list';
  var l = new _.Logger({ output : console });
  var got = l.inputUnchain( console );
  var expected = false;
  test.identical( got, expected );

  test.case = 'case2: input not exist in the list';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  var got = l.inputUnchain( l1 );
  var expected = false;
  test.identical( got, expected );

  test.case = 'case3: remove console from input';
  var got = [];
  var l = new _.Logger( { output : null,onTransformEnd : onTransformEnd } );
  l.inputFrom( console );
  l.inputUnchain( console );
  console.log( '1' );
  var expected = [];
  test.identical( got, expected );

  test.case = 'case4: remove logger from input';
  var got = [];
  var l1 = new _.Logger( { onTransformEnd : onTransformEnd } );
  var l2 = new _.Logger({ output : console });
  l1.inputFrom( l2 );
  l1.inputUnchain( l2 );
  l2.log( '1' );
  var expected = [];
  test.identical( got, expected );

  test.case = 'no args - removes all inputs';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : null });
  l1.inputFrom( l2 );
  test.identical( l1.inputs.length, 1 );
  test.identical( l2.outputs.length, 1 );
  l1.inputUnchain();
  test.identical( l1.inputs.length, 0 );
  test.identical( l2.outputs.length, 0 );

  //

  // !!! needs silencing = false
  // test.case = 'remove existing input';
  // var l = new _.Logger({ output : null });
  // l.inputFrom( console );
  // var got = [ l.inputUnchain( console ), console.outputs ];
  // var expected = [ true, undefined ];
  // test.identical( got, expected );

  test.case = 'input not exists';
  var l = new _.Logger({ output : console });
  var got = l.inputUnchain( console );
  var expected = false;
  test.identical( got, expected );

  test.case = 'remove logger from input';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  l2.inputFrom( l1 );
  var got = [ l2.inputs.length, l1.outputs.length ];
  var expected = [ 1, 2 ];
  test.identical( got, expected );
  var got = [ l2.inputUnchain( l1 ), l2.inputs.length, l1.outputs.length ];
  var expected = [ true, 0, 1 ];
  test.identical( got, expected );

  test.case = 'remove logger from input#2';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  l3.inputFrom( l1 );
  l3.inputFrom( l2 );
  var got = [ l3.inputUnchain( l1 ), l3.inputs.length, l1.outputs.length ];
  var expected = [ true, 1, 1 ];
  test.identical( got, expected );

  test.case = 'no args';
  var l = new _.Logger({ output : console });
  var l1 = new _.Logger({ output : console });
  l.inputFrom( l1 );
  test.identical( l.inputs.length, 1 )
  l.inputUnchain();
  test.identical( l.inputs.length, 0 )

  test.case = 'try to remove itself, false because no inputs';
  var l = new _.Logger({ output : console });
  var got = l.inputUnchain( l );
  test.identical( l.inputs.length, 0 );
  test.identical( got, false );

  if( !Config.debug )
  return;

  test.case = 'incorrect type';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger({ output : console });
    logger.inputUnchain( '1' );
  });
}

//

function _output( o )
{
  let test = o.test;

  /*

     combining:

    'rewrite', 'supplement', 'append', 'prepend'

    supplement+printer -> ordinary -> printer
    supplement+printer -> ordinary -> console
    supplement+printer -> exclusive -> printer
    +printer -> exclusive -> console
    +printer -> original -> printer
    +printer -> original -> console

    try to do multiple original/exclusive output in different order
  */

  if( _.Logger.consoleIsBarred( console ) )
  {
    o.consoleWasBarred = true;
    test.suite.consoleBar( 0 );
  }

  /* - */

  test.open( 'output exists' );

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });

  test.shouldThrowError( () => printerA.outputTo( printerB, { combining : 'unknown' } ) );

  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'rewrite' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'rewrite' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 1, combining : 'rewrite' } ) );

  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 1, combining : 'append' } ) );

  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 1, combining : 'prepend' } ) );

  printerA.outputTo( printerB );
  test.shouldThrowError( () => printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } ) );

  test.shouldThrowError( () => printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } ) );
  test.shouldThrowError( () => printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } ) );

  test.close( 'output exists' );

  /* - */

  test.open( 'close/deep loop' );

  test.case = 'close';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });

  printerA.outputTo( printerB );

  test.shouldThrowError( () => printerB.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } ) );
  test.shouldThrowError( () => printerB.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } ) );

  test.shouldThrowError( () => printerB.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } ) );
  test.shouldThrowError( () => printerB.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } ) );

  test.case = 'deep';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });

  printerA.outputTo( printerB );
  printerB.outputTo( printerC );

  test.shouldThrowError( () => printerC.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } ) );
  test.shouldThrowError( () => printerC.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } ) );

  test.shouldThrowError( () => printerC.outputTo( printerA, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } ) );
  test.shouldThrowError( () => printerC.outputTo( printerA, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } ) );

  test.close( 'close/deep loop' );


  /* - */

  test.open( 'printer -> ordinary -> printer' );

  test.case = 'combining : rewrite, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'rewrite' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : for printer B', 'end : printerB : for printer B' ] );

  test.case = 'combining : rewrite, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  printerB.inputFrom( inputPrinter );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( printerB.hasInputClose( inputPrinter ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'rewrite' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 2 );
  test.identical( printerB.outputs.length, 0 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, inputPrinter );
  test.identical( printerB.inputs[ 1 ].inputPrinter, printerA );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : for printer B', 'end : printerB : for printer B' ] );

  test.case = 'combining : append, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : for printer B', 'end : printerB : for printer B' ] );

  test.case = 'combining : append, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  printerB.inputFrom( inputPrinter );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( printerB.hasInputClose( inputPrinter ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, outputPrinter );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 2 );
  test.identical( printerB.outputs.length, 0 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, inputPrinter );
  test.identical( printerB.inputs[ 1 ].inputPrinter, printerA );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B',
    'begin : printerB : for printer B', 'end : printerB : for printer B'
  ]
  test.identical( hooked, expected );

  test.case = 'combining : prepend, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : for printer B', 'end : printerB : for printer B' ] );

  test.case = 'combining : prepend, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  printerB.inputFrom( inputPrinter );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( printerB.hasInputClose( inputPrinter ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, outputPrinter );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 2 );
  test.identical( printerB.outputs.length, 0 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, inputPrinter );
  test.identical( printerB.inputs[ 1 ].inputPrinter, printerA );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerB : for printer B', 'end : printerB : for printer B',
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B'
  ]
  test.identical( hooked, expected );

  //

  test.case = 'combining : supplement, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  var result = printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must  have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : for printer B', 'end : printerB : for printer B' ] );

  //

  test.case = 'combining : prepend, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  printerB.inputFrom( inputPrinter );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( printerB.hasInputClose( inputPrinter ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, outputPrinter );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 0 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, inputPrinter );
  printerA.log( 'for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B'
  ]
  test.identical( hooked, expected );

  //

  test.close( 'printer -> ordinary -> printer' );

  /* - */

  test.open( 'printer -> ordinary -> console' );

  test.case = 'combining : rewrite, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'rewrite' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.ge( consoleChainer.inputs.length, 1 );
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.ge( consoleChainer.outputs.length, 0 );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B' ] );

  test.case = 'combining : rewrite, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  inputPrinter.outputTo( console );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( inputPrinter.hasOutputClose( console ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'rewrite' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  inputPrinter.outputUnchain( console );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B' ] );


  test.case = 'combining : append, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ]
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B' ] );

  test.case = 'combining : append, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  inputPrinter.outputTo( console );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( inputPrinter.hasOutputClose( console ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, outputPrinter );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 2 ].inputPrinter, inputPrinter );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  inputPrinter.outputUnchain( console );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B',
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B'
  ]
  test.identical( hooked, expected );


  test.case = 'combining : prepend, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ]
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B' ] );

  test.case = 'combining : prepend, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  inputPrinter.outputTo( console );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( inputPrinter.hasOutputClose( console ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, outputPrinter );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 2 ].inputPrinter, inputPrinter );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  inputPrinter.outputUnchain( console );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B',
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B'
  ]
  test.identical( hooked, expected );

  //

  test.case = 'combining : supplement, printers have no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ]
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  outputPrinter.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B' ] );

  //

  test.case = 'supplement : prepend, printers have other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( outputPrinter );
  inputPrinter.outputTo( console );
  test.will = 'printer must have other input and output'
  test.is( printerA.hasOutputClose( outputPrinter ) );
  test.is( inputPrinter.hasOutputClose( console ) );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, outputPrinter );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs';
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, inputPrinter );
  outputPrinter.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'for printer B' );
  inputPrinter.outputUnchain( console );
  outputPrinter.inputUnchain( console );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : outputPrinter : for printer B', 'end : outputPrinter : for printer B'
  ]
  test.identical( hooked, expected );

  test.close( 'printer -> ordinary -> console' );

  test.open( 'printer -> exclusive -> printer' );

  test.case = 'combining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( console );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'rewrite' } );
  printerA.outputTo( printerC );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : A for printer B', 'end : printerB : A for printer B' ] );
  test.will = 'unchain exclusive output, printerC now must get the message';
  printerA.outputUnchain( printerB );
  hooked = [];
  printerA.log( 'A for printer C' );
  test.identical( hooked, [ 'begin : printerC : A for printer C', 'end : printerC : A for printer C' ] );

  test.case = 'combining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : A for printer B', 'end : printerB : A for printer B' ] );
  test.will = 'unchain exclusive output, printerC now must get the message';
  printerA.outputUnchain( printerB );
  hooked = [];
  printerA.log( 'A for printer C' );
  test.identical( hooked, [ 'begin : printerC : A for printer C', 'end : printerC : A for printer C' ] );

  test.case = 'combining : prepend';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerB : A for printer B', 'end : printerB : A for printer B' ] );
  test.will = 'unchain exclusive output, printerC now must get the message';
  printerA.outputUnchain( printerB );
  hooked = [];
  printerA.log( 'A for printer C' );
  test.identical( hooked, [ 'begin : printerC : A for printer C', 'end : printerC : A for printer C' ] );

  test.case = 'combining : supplement';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 0 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ] );

  test.close( 'printer -> exclusive -> printer' );

  /* - */

  test.open( 'printer -> exclusive -> console' );

  test.case = 'combining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC' });
  var printerD = new _.Logger({ name : 'printerD', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'rewrite' } );
  printerA.outputTo( printerD );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerD );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  printerD.inputFrom( console );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerD : A for printer B', 'end : printerD : A for printer B' ] );
  test.will = 'unchain exclusive output, printerD now must get the message';
  printerD.inputUnchain( console );
  printerA.outputUnchain( printerB );
  hooked = [];
  printerA.log( 'A for printer D' );
  test.identical( hooked, [ 'begin : printerD : A for printer D', 'end : printerD : A for printer D' ] );

  test.case = 'combining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  printerC.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'A for printer B' );
  test.will = 'unchain exclusive output, printerD now must get the message';
  printerC.inputUnchain( console );
  printerA.outputUnchain( printerB );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ] );
  hooked = [];
  printerA.log( 'A for printer C' );
  test.identical( hooked, [ 'begin : printerC : A for printer C', 'end : printerC : A for printer C' ] );

  test.case = 'combining : prepend';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  printerC.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'A for printer B' );
  test.will = 'unchain exclusive output, printerD now must get the message';
  printerC.inputUnchain( console );
  printerA.outputUnchain( printerB );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ] );
  hooked = [];
  printerA.log( 'A for printer C' );
  test.identical( hooked, [ 'begin : printerC : A for printer C', 'end : printerC : A for printer C' ] );

  test.case = 'combining : supplement, no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  printerC.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  test.identical( hooked, [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ] );
  test.will = 'unchain exclusive output, printerD now must get the message';
  printerC.inputUnchain( console );
  printerA.outputUnchain( printerB );

  test.case = 'combining : supplement';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 1, originalOutput : 0, combining : 'supplement' } );
  test.will = 'printerA must not have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must not have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  printerC.inputFrom( console, { exclusiveOutput : 1 } );
  printerA.log( 'A for printer B' );
  printerC.inputUnchain( console );
  test.will = 'message from printerA must not reach printerB';
  test.identical( hooked, [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ] );

  test.close( 'printer -> exclusive -> console' );

  /* - */

  test.open( 'printer -> original -> printer' );

  test.case = 'combining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( console );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'rewrite' } );
  printerA.outputTo( printerC );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerB : A for printer B', 'end : printerB : A for printer B',
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ]
  test.identical( hooked, expected );

  test.case = 'combining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'append' } );
  printerA.outputTo( printerC );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerB : A for printer B', 'end : printerB : A for printer B',
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ]
  test.identical( hooked, expected );

  test.case = 'combining : prepend';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];

  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerB : A for printer B', 'end : printerB : A for printer B',
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ]
  test.identical( hooked, expected );

  test.case = 'combining : supplement, no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerB : A for printer B', 'end : printerB : A for printer B'
  ]
  test.identical( hooked, expected );

  test.case = 'combining : supplement';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'supplement' } );
  test.will = 'printerA must not have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must not have printerA in inputs'
  test.is( !printerB.hasInputClose( printerA ) );
  test.identical( printerB.inputs.length, 0 );
  test.identical( printerB.outputs.length, 0 );
  printerA.log( 'A for printer B' );
  test.will = 'message from printerA must reach both of handlers';
  var expected =
  [
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ]
  test.identical( hooked, expected );

  test.close( 'printer -> original -> printer' );

  /* - */

  test.open( 'printer -> original -> console' );

  test.case = 'combining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( console );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'rewrite' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  printerC.inputFrom( console );
  printerA.log( 'A for printer B' );
  printerC.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA will be printed by original method, printer C will not get a message';
  var expected = [];
  test.identical( hooked, expected );

  test.case = 'combining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var consoleHook = new _.Logger({ name : 'consoleHook', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'append' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  consoleHook.inputFrom( console );
  printerA.log( 'A for printer B' );
  consoleHook.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA will be printed by original method, printer C will not get a message';
  var expected =
  [
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ];
  test.identical( hooked, expected );

  test.case = 'combining : prepend';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var consoleHook = new _.Logger({ name : 'consoleHook', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'prepend' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,2 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.outputs[ 1 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = console[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter, printerA );
  consoleHook.inputFrom( console );
  printerA.log( 'A for printer B' );
  consoleHook.inputUnchain( console );
  printerA.outputUnchain( console );
  test.will = 'message from printerA will be printed by original method, printer C will not get a message';
  var expected =
  [
    'begin : printerC : A for printer B', 'end : printerC : A for printer B'
  ];
  test.identical( hooked, expected );

  test.case = 'combining : supplement, no other chains';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'supplement' } );
  test.will = 'printerA must have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must have printerA in inputs'
  var consoleChainer = printerB[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  test.identical( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter,printerA );
  printerC.inputFrom( printerB );
  printerA.log( 'A for printer B' );
  printerC.inputUnchain( printerB );
  printerA.outputUnchain( printerB );
  test.will = 'message from printerA will be printed by original method, printer C will not get a message';
  var expected = [];
  test.identical( hooked, expected );

  test.case = 'combining : supplement';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  printerA.outputTo( printerC );
  printerA.outputTo( printerB, { exclusiveOutput : 0, originalOutput : 1, combining : 'supplement' } );
  test.will = 'printerA must not have printerB in outputs'
  test.is( !printerA.hasOutputClose( printerB ) );
  test.identical( printerA.outputs.length,1 );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerC );
  test.identical( printerA.inputs.length,0 );
  test.will = 'printerB must not have printerA in inputs'
  var consoleChainer = printerB[ Symbol.for( 'chainer' ) ];
  test.is( !consoleChainer.hasInputClose( printerA ) );
  test.is( consoleChainer.inputs[ consoleChainer.inputs.length - 1 ].inputPrinter !== printerA );
  printerC.inputFrom( printerB );
  printerA.log( 'A for printer B' );
  printerC.inputUnchain( printerB );
  test.will = 'message from printerA will not be printed by original method, printer C will get a message';
  var expected = [ 'begin : printerC : A for printer B', 'end : printerC : A for printer B' ];
  test.identical( hooked, expected );

  test.close( 'printer -> original -> console' );

  /* - */

  test.open( 'multiple original/exclusive output' );

  test.case = 'two otputs';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerO = new _.Logger({ name : 'printerO', onTransformBegin : onTransformBegin2 });
  var printerEx = new _.Logger({ name : 'printerEx', onTransformBegin : onTransformBegin2  });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });

  printerA.outputTo( printerO, { originalOutput : 1 } );
  printerA.outputTo( printerEx, { exclusiveOutput : 1 } );
  printerB.inputFrom( printerO );
  printerB.inputFrom( printerEx );

  hooked = [];

  printerA.log( 'for printerB' );

  var expected =
  [
    'begin : printerB : printerEx : for printerB',
    'end : printerB : printerEx : for printerB'
  ];
  test.identical( hooked, expected );

  function onTransformBegin2( o )
  {
    o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
    return o;
  }

  test.case = 'two otputs, console as input';

  var printerA = console;
  var printerO = new _.Logger({ name : 'printerO', onTransformBegin : onTransformBegin2 });
  var printerEx = new _.Logger({ name : 'printerEx', onTransformBegin : onTransformBegin2  });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });

  printerO.inputFrom( printerA, { originalOutput : 1 } );
  printerEx.inputFrom( printerA, { exclusiveOutput : 1 } );
  printerB.inputFrom( printerO );
  printerB.inputFrom( printerEx );

  hooked = [];

  printerA.log( 'for printerB' );
  printerO.inputUnchain( printerA );
  printerEx.inputUnchain( printerA );

  var expected =
  [
    'begin : printerB : printerEx : for printerB',
    'end : printerB : printerEx : for printerB'
  ];
  test.identical( hooked, expected );

  function onTransformBegin2( o )
  {
    o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
    return o;
  }

  test.case = 'two otputs, console as input, diff order';

  var printerA = console;
  var printerO = new _.Logger({ name : 'printerO', onTransformBegin : onTransformBegin2 });
  var printerEx = new _.Logger({ name : 'printerEx', onTransformBegin : onTransformBegin2  });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });

  printerEx.inputFrom( printerA, { exclusiveOutput : 1 } );
  printerO.inputFrom( printerA, { originalOutput : 1 } );
  printerB.inputFrom( printerO );
  printerB.inputFrom( printerEx );

  hooked = [];

  printerA.log( 'for printerB' );
  printerO.inputUnchain( printerA );
  printerEx.inputUnchain( printerA );

  var expected =
  [
    'begin : printerB : printerEx : for printerB',
    'end : printerB : printerEx : for printerB'
  ];
  test.identical( hooked, expected );

  test.case = 'two otputs, different order';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerO = new _.Logger({ name : 'printerO', onTransformBegin : onTransformBegin2 });
  var printerEx = new _.Logger({ name : 'printerEx', onTransformBegin : onTransformBegin2  });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });

  printerA.outputTo( printerEx, { exclusiveOutput : 1 } );
  printerA.outputTo( printerO, { originalOutput : 1 } );
  printerB.inputFrom( printerO );
  printerB.inputFrom( printerEx );

  hooked = [];

  printerA.log( 'for printerB' );

  var expected =
  [
    'begin : printerB : printerEx : for printerB',
    'end : printerB : printerEx : for printerB'
  ];
  test.identical( hooked, expected );

  function onTransformBegin2( o )
  {
    o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
    return o;
  }

  test.case = 'multiple outputs, different order';

  var printerA = new _.Logger({ name : 'printerA', onTransformBegin : onTransformBegin2 });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin2 });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin2 });
  var printerD = new _.Logger({ name : 'printerD', onTransformBegin : onTransformBegin2 });
  var printerE = new _.Logger({ name : 'printerE', onTransformEnd : onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin2 });

  printerA.outputTo( printerB, { exclusiveOutput : 1 } );
  printerA.outputTo( outputPrinter, { originalOutput : 1 } );
  printerB.outputTo( printerC, { originalOutput : 1 } );
  printerC.outputTo( printerD, { exclusiveOutput : 1 } );
  printerC.outputTo( outputPrinter, { originalOutput : 1 } );
  printerD.outputTo( printerE, { originalOutput : 1 } );

  hooked = [];
  printerA.log( 'for E' );
  var expected = [ 'end : printerE : printerD : printerC : printerB : for E' ];
  test.identical( hooked, expected )

  test.case = 'multiple outputs, different order';

  var printerA = new _.Logger({ name : 'printerA', onTransformBegin : onTransformBegin2 });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin2 });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin2 });
  var printerD = new _.Logger({ name : 'printerD', onTransformBegin : onTransformBegin2 });
  var printerE = new _.Logger({ name : 'printerE', onTransformEnd : onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin2 });

  printerA.outputTo( printerB, { originalOutput : 1 } );
  printerB.outputTo( printerC, { exclusiveOutput : 1 } );
  printerB.outputTo( outputPrinter, { originalOutput : 1 } );
  printerC.outputTo( printerD, { exclusiveOutput : 1 } );
  printerC.outputTo( outputPrinter, { originalOutput : 1 } );
  printerD.outputTo( printerE, { originalOutput : 1 } );

  hooked = [];
  printerA.log( 'for E' );
  var expected = [ 'end : printerE : printerD : printerB : printerA : for E' ];
  test.identical( hooked, expected )

  test.case = 'multiple outputs, different order';

  var printerA = new _.Logger({ name : 'printerA', onTransformBegin : onTransformBegin2 });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin2 });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin2 });
  var printerD = new _.Logger({ name : 'printerD', onTransformBegin : onTransformBegin2 });
  var printerE = new _.Logger({ name : 'printerE', onTransformEnd : onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin2 });

  printerA.outputTo( printerB, { originalOutput : 1 } );
  printerB.outputTo( printerC, { exclusiveOutput : 1 } );
  printerB.outputTo( outputPrinter, { originalOutput : 1 } );
  printerC.outputTo( printerD, { originalOutput : 1 } );
  printerD.outputTo( printerE, { exclusiveOutput : 1 } );
  printerD.outputTo( outputPrinter, { originalOutput : 1 } );

  hooked = [];
  printerA.log( 'for E' );
  var expected = [ 'end : printerE : printerD : printerC : printerB : printerA : for E' ];
  test.identical( hooked, expected );

  test.case = 'multiple outputs, different order';

  var printerA = new _.Logger({ name : 'printerA', onTransformBegin : onTransformBegin2 });
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin2 });
  var printerC = new _.Logger({ name : 'printerC', onTransformBegin : onTransformBegin2 });
  var printerD = new _.Logger({ name : 'printerD', onTransformBegin : onTransformBegin2 });
  var printerE = new _.Logger({ name : 'printerE', onTransformEnd : onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin2 });

  printerA.outputTo( printerB, { exclusiveOutput : 1 } );
  printerA.outputTo( outputPrinter, { originalOutput : 1 } );
  printerB.outputTo( printerC, { originalOutput : 1 } );
  printerC.outputTo( printerD, { originalOutput : 1 } );
  printerD.outputTo( printerE, { exclusiveOutput : 1 } );
  printerD.outputTo( outputPrinter, { originalOutput : 1 } );

  hooked = [];
  printerA.log( 'for E' );
  var expected = [ 'end : printerE : printerD : printerC : printerB : for E' ];
  test.identical( hooked, expected )

  test.close( 'multiple original/exclusive output' );


  if( o.consoleWasBarred )
  {
    test.suite.consoleBar( 1 );
    test.is( _.Logger.consoleIsBarred( console ) );
  }

  function onTransformBegin2( o )
  {
    o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
    return o;
  }

  function onTransformBegin( o )
  {
    hooked.push( 'begin' + ' : ' + this.name + ' : ' + o.input[ 0 ] );
    return o;
  }

  function onTransformEnd( o )
  {
    hooked.push( 'end' + ' : ' + this.name + ' : ' + o.input[ 0 ]  );
    return o;
  }

}

//

function output( test )
{
  var o =
  {
    test : test,
    consoleWasBarred : false
  }

  try
  {
    _output( o );
  }
  catch( err )
  {
    if( o.consoleWasBarred )
    test.suite.consoleBar( 1 );

    throw _.errLogOnce( err );
  }

}

//

function _input( o )
{
  let test = o.test;

  if( _.Logger.consoleIsBarred( console ) )
  {
    o.consoleWasBarred = true;
    test.suite.consoleBar( 0 );
  }

  /* - */

  test.case = 'exclusive input from console';

  var printerA = console;
  var printerB = new _.Logger({ name : 'printerB', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });
  var hooked = [];
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin, onTransformEnd : onTransformEnd });

  /* chain input/output to console */

  printerB.inputFrom( printerA, { exclusiveOutput : 1 } );
  outputPrinter.inputFrom( printerA, { combining : 'append' } );

  printerA.log( 'console for printerB' );

  var expected = [ 'begin : printerB : console for printerB', 'end : printerB : console for printerB' ];
  test.identical( hooked, expected )

  var consoleChainer = printerA[ Symbol.for( 'chainer' ) ];
  test.identical( consoleChainer.outputs[ consoleChainer.outputs.length - 2 ].outputPrinter, printerB );
  test.identical( consoleChainer.outputs[ consoleChainer.outputs.length - 1 ].outputPrinter, outputPrinter );

  printerB.inputUnchain( printerA );

  hooked = [];
  printerA.log( 'console for outputPrinter' );
  var expected = [ 'begin : outputPrinter : console for outputPrinter', 'end : outputPrinter : console for outputPrinter' ];
  test.identical( hooked, expected )

  outputPrinter.inputUnchain( printerA );

  test.is( !printerB.hasInputClose( printerA ) );
  test.is( !outputPrinter.hasInputClose( printerA ) );

  /* - */

  if( o.consoleWasBarred )
  {
    test.suite.consoleBar( 1 );
    test.is( _.Logger.consoleIsBarred( console ) );
  }


  function onTransformBegin( o )
  {
    hooked.push( 'begin' + ' : ' + this.name + ' : ' + o.input[ 0 ] );
    return o;
  }

  function onTransformEnd( o )
  {
    hooked.push( 'end' + ' : ' + this.name + ' : ' + o.input[ 0 ]  );
    return o;
  }

}

function input( test )
{
  var o =
  {
    test : test,
    consoleWasBarred : false
  }

  try
  {
    _input( o );
  }
  catch( err )
  {
    if( o.consoleWasBarred )
    test.suite.consoleBar( 1 );

    throw _.errLogOnce( err );
  }

}


//

function chain( test )
{
  let chain  = _.Logger.chain;

  /*
    different inputCombining/outputCombining

    one input - one output
    one input - multiple outputs
    multiple inputs - one output
    multiple inputs - multiple outputs

  */

  /* - */

  test.open( 'one input - one output' );

  test.case = 'printer - printer, both have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerB.inputFrom( inputPrinter );

  printerA.outputTo( outputPrinter );
  printerB.outputTo( outputPrinter );

  var result = chain
  ({
    inputPrinter : printerA,
    outputPrinter : printerB,
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  test.identical( result, 1 );

  test.is( printerA.hasOutputClose( printerB ) );
  test.is( printerB.hasInputClose( printerA ) );

  test.identical( printerA.inputs.length, 1 );
  test.identical( printerA.outputs.length, 1 );

  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 1 );

  test.identical( printerA.inputs[ 0 ].inputPrinter, inputPrinter );
  test.identical( printerA.inputs[ 0 ].outputPrinter, printerA );
  // test.identical( printerA.inputs[ 0 ].inputCombining, 'append' );
  // test.identical( printerA.inputs[ 0 ].outputCombining, 'append' );
  test.identical( printerA.inputs[ 0 ].originalOutput, 0 );
  test.identical( printerA.inputs[ 0 ].exclusiveOutput, 0 );

  test.identical( printerA.outputs[ 0 ].inputPrinter, printerA );
  test.identical( printerA.outputs[ 0 ].outputPrinter, printerB );
  // test.identical( printerA.outputs[ 0 ].inputCombining, 'rewrite' );
  // test.identical( printerA.outputs[ 0 ].outputCombining, 'rewrite' );
  test.identical( printerA.outputs[ 0 ].originalOutput, 0 );
  test.identical( printerA.outputs[ 0 ].exclusiveOutput, 0 );

  test.identical( printerB.inputs[ 0 ].inputPrinter, printerA );
  test.identical( printerB.inputs[ 0 ].outputPrinter, printerB );
  // test.identical( printerB.inputs[ 0 ].inputCombining, 'rewrite' );
  // test.identical( printerB.inputs[ 0 ].outputCombining, 'rewrite' );
  test.identical( printerB.inputs[ 0 ].originalOutput, 0 );
  test.identical( printerB.inputs[ 0 ].exclusiveOutput, 0 );

  test.identical( printerB.outputs[ 0 ].inputPrinter, printerB );
  test.identical( printerB.outputs[ 0 ].outputPrinter, outputPrinter );
  // test.identical( printerB.outputs[ 0 ].inputCombining, 'append' );
  // test.identical( printerB.outputs[ 0 ].outputCombining, 'append' );
  test.identical( printerB.outputs[ 0 ].originalOutput, 0 );
  test.identical( printerB.outputs[ 0 ].exclusiveOutput, 0 );

  //

  test.case = 'printer - console, both have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = console;
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  var chainerPrinterB = printerB[ Symbol.for( 'chainer' ) ];
  var inputsPrinterB = chainerPrinterB.inputs.slice();

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  inputPrinter.outputTo( printerB );
  outputPrinter.inputFrom( printerB );

  var result = chain
  ({
    inputPrinter : printerA,
    outputPrinter : printerB,
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  test.identical( result, 1 );

  test.is( printerA.hasOutputClose( printerB ) );
  test.is( chainerPrinterB.hasInputClose( printerA ) );

  test.identical( printerA.inputs.length, 1 );
  test.identical( printerA.outputs.length, 1 );

  test.ge( chainerPrinterB.inputs.length, 1 );
  test.ge( chainerPrinterB.outputs.length, 1 );

  var inputsA = printerA.inputs.slice();
  var outputsA = printerA.outputs.slice();

  var inputsB = chainerPrinterB.inputs.slice();
  var outputsB = chainerPrinterB.outputs.slice();

  chainerPrinterB.inputUnchain( printerA );
  chainerPrinterB.outputUnchain( outputPrinter );

  var result = chain
  ({
    inputPrinter : inputsPrinterB,
    outputPrinter : printerB,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  test.identical( result, inputsPrinterB.length );

  test.identical( inputsA[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ 0 ].outputPrinter, printerA );
  test.identical( inputsA[ 0 ].originalOutput, 0 );
  test.identical( inputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 0 ].inputPrinter, printerA );
  test.identical( outputsA[ 0 ].outputPrinter, printerB );
  test.identical( outputsA[ 0 ].originalOutput, 0 );
  test.identical( outputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB[ 0 ].inputPrinter, printerA );
  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ outputsB.length - 1 ].inputPrinter, printerB );
  test.identical( outputsB[ outputsB.length - 1  ].outputPrinter, outputPrinter );
  test.identical( outputsB[ outputsB.length - 1  ].originalOutput, 0 );
  test.identical( outputsB[ outputsB.length - 1  ].exclusiveOutput, 0 );

  inputsPrinterB.forEach( ( cd ) =>
  {
    test.will = 'console has ' + cd.inputPrinter.name + ' in inputs';
    test.is( chainerPrinterB._hasInput( cd.inputPrinter, { withoutOutputToOriginal : 0 }) );
    test.will = null;
  })

  test.case = 'console - printer, both have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = console;
  var printerB = new _.Logger({ name : 'printerA' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  var chainerPrinterA = printerA[ Symbol.for( 'chainer' ) ];
  var outputsPrinterA = chainerPrinterA.outputs.slice();

  chainerPrinterA.inputFrom( inputPrinter );
  chainerPrinterA.outputTo( outputPrinter );

  inputPrinter.outputTo( printerB );
  outputPrinter.inputFrom( printerB );

  var result = chain
  ({
    inputPrinter : printerA,
    outputPrinter : printerB,
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  test.identical( result, 1 );

  test.is( chainerPrinterA.hasOutputClose( printerB ) );
  test.is( printerB.hasInputClose( printerA ) );

  test.ge( chainerPrinterA.inputs.length, 1 );
  test.identical( chainerPrinterA.outputs.length, 1 );

  test.identical( printerB.inputs.length, 1 );
  test.identical( printerB.outputs.length, 1 );

  var inputsA = chainerPrinterA.inputs.slice();
  var outputsA = chainerPrinterA.outputs.slice();

  var inputsB = printerB.inputs.slice();
  var outputsB = printerB.outputs.slice();

  chainerPrinterA.inputUnchain( inputPrinter );
  chainerPrinterA.outputUnchain( printerB );

  var result = chain
  ({
    inputPrinter : printerA,
    outputPrinter : outputsPrinterA,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  test.identical( result, outputsPrinterA.length );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 0 ].inputPrinter, printerA );
  test.identical( outputsA[ 0 ].outputPrinter, printerB );
  test.identical( outputsA[ 0 ].originalOutput, 0 );
  test.identical( outputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB[ 0 ].inputPrinter, printerA );
  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  outputsPrinterA.forEach( ( cd ) =>
  {
    test.will = 'console has ' + cd.outputPrinter.name + ' in outputs';
    test.is( chainerPrinterA._hasOutput( cd.outputPrinter, { withoutOutputToOriginal : 0 }) );
    test.will = null;
  })

  // test.case = 'console - other printer, both have chains, inputCombining : rewrite, outputCombining : rewrite';

  test.close( 'one input - one output' );

  /* - */

  test.open( 'one input - multiple outputs' );

  test.case = 'printer - multiple printers, have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = console;
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  var chainerPrinterC = printerC[ Symbol.for( 'chainer' ) ];
  chainerPrinterC.inputFrom( inputPrinter );
  chainerPrinterC.outputTo( outputPrinter );

  var inputsPrinterC = chainerPrinterC.inputs.slice();

  var resultA = chain
  ({
    inputPrinter : printerA,
    outputPrinter : [ printerB, printerC ],
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = chainerPrinterC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = chainerPrinterC.outputs.slice();

  /* restoring console */

  var resultB = chain
  ({
    inputPrinter : inputsPrinterC,
    outputPrinter : printerC,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });
  chainerPrinterC.outputUnchain( outputPrinter );

  test.identical( resultA, 2 );
  test.identical( resultB, inputsPrinterC.length );

  test.identical( inputsA.length, 1 );
  test.identical( outputsA.length, 1 );

  test.identical( inputsA[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ 0 ].outputPrinter, printerA );
  test.identical( inputsA[ 0 ].originalOutput, 0 );
  test.identical( inputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 0 ].outputPrinter, printerC );
  test.identical( outputsA[ 0 ].inputPrinter, printerA );
  test.identical( outputsA[ 0 ].originalOutput, 0 );
  test.identical( outputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 0 );
  test.identical( outputsB.length, 1 );
  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 1 );
  test.ge( outputsC.length, 1 );
  test.identical( inputsC[ 0 ].inputPrinter, printerA );
  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );
  test.identical( outputsC[ outputsC.length - 1 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ outputsC.length - 1 ].inputPrinter, printerC );
  test.identical( outputsC[ outputsC.length - 1 ].originalOutput, 0 );
  test.identical( outputsC[ outputsC.length - 1 ].exclusiveOutput, 0 );

  //

  test.case = 'printer - multiple printers, have chains, inputCombining : append, outputCombining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = console;
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  var chainerPrinterC = printerC[ Symbol.for( 'chainer' ) ];
  chainerPrinterC.inputFrom( inputPrinter );
  chainerPrinterC.outputTo( outputPrinter );

  var result = chain
  ({
    inputPrinter : printerA,
    outputPrinter : [ printerB, printerC ],
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs;
  var inputsB = printerB.inputs;
  var inputsC = chainerPrinterC.inputs;

  var outputsA = printerA.outputs;
  var outputsB = printerB.outputs;
  var outputsC = chainerPrinterC.outputs;

  test.identical( result, 2 );

  test.identical( inputsA.length, 1 );
  test.identical( outputsA.length, 3 );

  test.identical( inputsA[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ 0 ].outputPrinter, printerA );
  test.identical( inputsA[ 0 ].originalOutput, 0 );
  test.identical( inputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 1 ].outputPrinter, printerB );
  test.identical( outputsA[ 1 ].inputPrinter, printerA );
  test.identical( outputsA[ 1 ].originalOutput, 0 );
  test.identical( outputsA[ 1 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 2 ].outputPrinter, printerC );
  test.identical( outputsA[ 2 ].inputPrinter, printerA );
  test.identical( outputsA[ 2 ].originalOutput, 0 );
  test.identical( outputsA[ 2 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 2 );
  test.identical( outputsB.length, 1 );

  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB[ 1 ].inputPrinter, printerA );
  test.identical( inputsB[ 1 ].outputPrinter, printerB );
  test.identical( inputsB[ 1 ].originalOutput, 0 );
  test.identical( inputsB[ 1 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.ge( inputsC.length, 2 );
  test.ge( outputsC.length, 1 );

  test.identical( inputsC[ inputsC.length - 2 ].inputPrinter, inputPrinter );
  test.identical( inputsC[ inputsC.length - 2 ].outputPrinter, printerC );
  test.identical( inputsC[ inputsC.length - 2 ].originalOutput, 0 );
  test.identical( inputsC[ inputsC.length - 2 ].exclusiveOutput, 0 );

  test.identical( inputsC[ inputsC.length - 1 ].inputPrinter, printerA );
  test.identical( inputsC[ inputsC.length - 1 ].outputPrinter, printerC );
  test.identical( inputsC[ inputsC.length - 1 ].originalOutput, 0 );
  test.identical( inputsC[ inputsC.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsC[ outputsC.length - 1 ].inputPrinter, printerC );
  test.identical( outputsC[ outputsC.length - 1 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ outputsC.length - 1 ].originalOutput, 0 );
  test.identical( outputsC[ outputsC.length - 1 ].exclusiveOutput, 0 );

  chainerPrinterC.inputUnchain( inputPrinter );
  chainerPrinterC.inputUnchain( printerA );
  chainerPrinterC.outputUnchain( outputPrinter );

  //

  test.case = 'console - multiple printers, have chains, inputCombining : append, outputCombining : append';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var result = chain
  ({
    inputPrinter : printerA.printer,
    outputPrinter : [ printerB, printerC ],
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs;
  var inputsB = printerB.inputs;
  var inputsC = printerC.inputs;

  var outputsA = printerA.outputs;
  var outputsB = printerB.outputs;
  var outputsC = printerC.outputs;

  test.identical( result, 2 );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 3 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsA[ outputsA.length - 2 ].outputPrinter, printerB );
  test.identical( outputsA[ outputsA.length - 2 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ outputsA.length - 2 ].originalOutput, 0 );
  test.identical( outputsA[ outputsA.length - 2 ].exclusiveOutput, 0 );

  test.identical( outputsA[ outputsA.length - 1 ].outputPrinter, printerC );
  test.identical( outputsA[ outputsA.length - 1 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ outputsA.length - 1 ].originalOutput, 0 );
  test.identical( outputsA[ outputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 2 );
  test.identical( outputsB.length, 1 );

  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB[ 1 ].inputPrinter, printerA.printer );
  test.identical( inputsB[ 1 ].outputPrinter, printerB );
  test.identical( inputsB[ 1 ].originalOutput, 0 );
  test.identical( inputsB[ 1 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 2 );
  test.identical( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC[ 1 ].inputPrinter, printerA.printer );
  test.identical( inputsC[ 1 ].outputPrinter, printerC );
  test.identical( inputsC[ 1 ].originalOutput, 0 );
  test.identical( inputsC[ 1 ].exclusiveOutput, 0 );

  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  printerA.inputUnchain( inputPrinter );
  printerA.outputUnchain( outputPrinter );
  printerA.outputUnchain( printerB );
  printerA.outputUnchain( printerC );

  test.case = 'console - multiple printers, have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var outputsPrinterA = printerA.outputs.slice();

  var resultA = chain
  ({
    inputPrinter : printerA.printer,
    outputPrinter : [ printerB, printerC ],
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();

  /* restoring console */

  var resultB = chain
  ({
    inputPrinter : printerA.printer,
    outputPrinter : outputsPrinterA,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });
  printerA.inputUnchain( inputPrinter );

  test.identical( resultA, 2 );
  test.identical( resultB, outputsPrinterA.length );

  test.ge( inputsA.length, 1 );
  test.identical( outputsA.length, 1 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 0 ].outputPrinter, printerC );
  test.identical( outputsA[ 0 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ 0 ].originalOutput, 0 );
  test.identical( outputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 0 );
  test.identical( outputsB.length, 1 );

  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 1 );
  test.identical( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].inputPrinter, printerA.printer );
  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );
  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  test.close( 'one input - multiple outputs' );

  /* - */

  test.open( 'multiple inputs - one output' );

  test.case = 'multiple inputs - printer, have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var outputsPrinterA = printerA.outputs.slice();

  var resultA = chain
  ({
    inputPrinter : [ printerA.printer, printerB ],
    outputPrinter : printerC,
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();

  /* restoring console */

  var resultB = chain
  ({
    inputPrinter : printerA.printer,
    outputPrinter : outputsPrinterA,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });
  printerA.inputUnchain( inputPrinter );

  test.identical( resultA, 2 );
  test.identical( resultB, outputsPrinterA.length );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 0 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 1 );

  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, printerC );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 1 );
  test.identical( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].inputPrinter, printerB );
  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  test.case = 'multiple inputs - printer, have chains, inputCombining : append, outputCombining : append';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var resultA = chain
  ({
    inputPrinter : [ printerA.printer, printerB ],
    outputPrinter : printerC,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();

  test.identical( resultA, 2 );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 2 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 2 );

  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 1 ].outputPrinter, printerC );
  test.identical( outputsB[ 1 ].inputPrinter, printerB );
  test.identical( outputsB[ 1 ].originalOutput, 0 );
  test.identical( outputsB[ 1 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 3 );
  test.identical( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC[ 1 ].inputPrinter, printerA.printer );
  test.identical( inputsC[ 1 ].outputPrinter, printerC );
  test.identical( inputsC[ 1 ].originalOutput, 0 );
  test.identical( inputsC[ 1 ].exclusiveOutput, 0 );

  test.identical( inputsC[ 2 ].inputPrinter, printerB );
  test.identical( inputsC[ 2 ].outputPrinter, printerC );
  test.identical( inputsC[ 2 ].originalOutput, 0 );
  test.identical( inputsC[ 2 ].exclusiveOutput, 0 );

  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  printerA.inputUnchain( inputPrinter );
  printerA.outputUnchain( outputPrinter );
  printerA.outputUnchain( printerC );

  test.case = 'multiple inputs - console, have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = console[ Symbol.for( 'chainer' ) ]
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var inputsPrinterC = printerC.inputs.slice();

  var resultA = chain
  ({
    inputPrinter : [ printerA, printerB ],
    outputPrinter : printerC.printer,
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();

  /* restoring console */

  var resultB = chain
  ({
    inputPrinter : inputsPrinterC,
    outputPrinter : printerC.printer,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });
  printerC.outputUnchain( outputPrinter );

  test.identical( resultA, 2 );
  test.identical( resultB, inputsPrinterC.length );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 0 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA);
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 1 );

  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, printerC.printer );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 1 );
  test.ge( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].inputPrinter, printerB );
  test.identical( inputsC[ 0 ].outputPrinter, printerC.printer );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsC[ outputsC.length - 1 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ outputsC.length - 1 ].inputPrinter, printerC.printer );
  test.identical( outputsC[ outputsC.length - 1 ].originalOutput, 0 );
  test.identical( outputsC[ outputsC.length - 1 ].exclusiveOutput, 0 );

  test.case = 'multiple inputs - console, have chains, inputCombining : append, outputCombining : append';

  var printerA = new _.Logger({ name : 'printerA' });
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = console[ Symbol.for( 'chainer' ) ];
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  var resultA = chain
  ({
    inputPrinter : [ printerA, printerB ],
    outputPrinter : printerC.printer,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();

  test.identical( resultA, 2 );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 2 );

  test.identical( inputsA[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ 0 ].outputPrinter, printerA );
  test.identical( inputsA[ 0 ].originalOutput, 0 );
  test.identical( inputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 0 ].inputPrinter, printerA );
  test.identical( outputsA[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsA[ 0 ].originalOutput, 0 );
  test.identical( outputsA[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsA[ 1 ].inputPrinter, printerA );
  test.identical( outputsA[ 1 ].outputPrinter, printerC.printer );
  test.identical( outputsA[ 1 ].originalOutput, 0 );
  test.identical( outputsA[ 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 2 );

  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 1 ].inputPrinter, printerB );
  test.identical( outputsB[ 1 ].outputPrinter, printerC.printer );
  test.identical( outputsB[ 1 ].originalOutput, 0 );
  test.identical( outputsB[ 1 ].exclusiveOutput, 0 );

  test.ge( inputsC.length, 3 );
  test.ge( outputsC.length, 1 );

  test.identical( inputsC[ inputsC.length - 3 ].inputPrinter, inputPrinter );
  test.identical( inputsC[ inputsC.length - 3 ].outputPrinter, printerC.printer );
  test.identical( inputsC[ inputsC.length - 3 ].originalOutput, 0 );
  test.identical( inputsC[ inputsC.length - 3 ].exclusiveOutput, 0 );

  test.identical( inputsC[ inputsC.length - 2 ].inputPrinter, printerA );
  test.identical( inputsC[ inputsC.length - 2 ].outputPrinter, printerC.printer );
  test.identical( inputsC[ inputsC.length - 2 ].originalOutput, 0 );
  test.identical( inputsC[ inputsC.length - 2 ].exclusiveOutput, 0 );

  test.identical( inputsC[ inputsC.length - 1 ].inputPrinter, printerB );
  test.identical( inputsC[ inputsC.length - 1 ].outputPrinter, printerC.printer );
  test.identical( inputsC[ inputsC.length - 1 ].originalOutput, 0 );
  test.identical( inputsC[ inputsC.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsC[ outputsC.length - 1 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ outputsC.length - 1 ].inputPrinter, printerC.printer );
  test.identical( outputsC[ outputsC.length - 1 ].originalOutput, 0 );
  test.identical( outputsC[ outputsC.length - 1 ].exclusiveOutput, 0 );

  printerC.inputUnchain( inputPrinter );
  printerC.inputUnchain( printerA );
  printerC.inputUnchain( printerB );
  printerC.outputUnchain( outputPrinter );

  test.close( 'multiple inputs - one output' );

  /* - */

  test.open( 'multiple inputs - multiple outputs' );

  test.case = 'multiple inputs - multiple outputs, have chains, inputCombining : rewrite, outputCombining : rewrite';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var printerD = new _.Logger({ name : 'printerD' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  printerD.inputFrom( inputPrinter );
  printerD.outputTo( outputPrinter );

  var outputsPrinterA = printerA.outputs.slice();

  var resultA = chain
  ({
    inputPrinter : [ printerA.printer, printerB ],
    outputPrinter : [ printerC, printerD ],
    inputCombining : 'rewrite',
    outputCombining : 'rewrite',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();
  var inputsD = printerD.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();
  var outputsD = printerD.outputs.slice();

  /* restoring console */

  var resultB = chain
  ({
    inputPrinter : printerA.printer,
    outputPrinter : outputsPrinterA,
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });
  printerA.inputUnchain( inputPrinter );

  test.identical( resultA, 4 );
  test.identical( resultB, outputsPrinterA.length );

  test.ge( inputsA.length, 1 );
  test.identical( outputsA.length, 0 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 1 );

  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, printerD );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 0 );
  test.identical( outputsC.length, 1 );

  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsD.length, 1 );
  test.identical( outputsD.length, 1 );

  test.identical( inputsD[ 0 ].outputPrinter, printerD );
  test.identical( inputsD[ 0 ].inputPrinter, printerB );
  test.identical( inputsD[ 0 ].originalOutput, 0 );
  test.identical( inputsD[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsD[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsD[ 0 ].inputPrinter, printerD );
  test.identical( outputsD[ 0 ].originalOutput, 0 );
  test.identical( outputsD[ 0 ].exclusiveOutput, 0 );

  test.case = 'multiple inputs - multiple outputs, have chains, inputCombining : append, outputCombining : append';

  var printerA = console[ Symbol.for( 'chainer' ) ];
  var printerB = new _.Logger({ name : 'printerB' });
  var printerC = new _.Logger({ name : 'printerC' });
  var printerD = new _.Logger({ name : 'printerD' });
  var inputPrinter = new _.Logger({ name : 'inputPrinter' });
  var outputPrinter = new _.Logger({ name : 'outputPrinter' });

  printerA.inputFrom( inputPrinter );
  printerA.outputTo( outputPrinter );

  printerB.inputFrom( inputPrinter );
  printerB.outputTo( outputPrinter );

  printerC.inputFrom( inputPrinter );
  printerC.outputTo( outputPrinter );

  printerD.inputFrom( inputPrinter );
  printerD.outputTo( outputPrinter );

  var resultA = chain
  ({
    inputPrinter : [ printerA.printer, printerB ],
    outputPrinter : [ printerC, printerD ],
    inputCombining : 'append',
    outputCombining : 'append',
    originalOutput : 0,
    exclusiveOutput : 0
  });

  var inputsA = printerA.inputs.slice();
  var inputsB = printerB.inputs.slice();
  var inputsC = printerC.inputs.slice();
  var inputsD = printerD.inputs.slice();

  var outputsA = printerA.outputs.slice();
  var outputsB = printerB.outputs.slice();
  var outputsC = printerC.outputs.slice();
  var outputsD = printerD.outputs.slice();


  test.identical( resultA, 4 );

  test.ge( inputsA.length, 1 );
  test.ge( outputsA.length, 3 );

  test.identical( inputsA[ inputsA.length - 1 ].inputPrinter, inputPrinter );
  test.identical( inputsA[ inputsA.length - 1 ].outputPrinter, printerA.printer );
  test.identical( inputsA[ inputsA.length - 1 ].originalOutput, 0 );
  test.identical( inputsA[ inputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( outputsA[ outputsA.length - 3 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ outputsA.length - 3 ].outputPrinter, outputPrinter );
  test.identical( outputsA[ outputsA.length - 3 ].originalOutput, 0 );
  test.identical( outputsA[ outputsA.length - 3 ].exclusiveOutput, 0 );

  test.identical( outputsA[ outputsA.length - 2 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ outputsA.length - 2 ].outputPrinter, printerC );
  test.identical( outputsA[ outputsA.length - 2 ].originalOutput, 0 );
  test.identical( outputsA[ outputsA.length - 2 ].exclusiveOutput, 0 );

  test.identical( outputsA[ outputsA.length - 1 ].inputPrinter, printerA.printer );
  test.identical( outputsA[ outputsA.length - 1 ].outputPrinter, printerD );
  test.identical( outputsA[ outputsA.length - 1 ].originalOutput, 0 );
  test.identical( outputsA[ outputsA.length - 1 ].exclusiveOutput, 0 );

  test.identical( inputsB.length, 1 );
  test.identical( outputsB.length, 3 );

  test.identical( inputsB[ 0 ].outputPrinter, printerB );
  test.identical( inputsB[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsB[ 0 ].originalOutput, 0 );
  test.identical( inputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsB[ 0 ].inputPrinter, printerB );
  test.identical( outputsB[ 0 ].originalOutput, 0 );
  test.identical( outputsB[ 0 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 1 ].outputPrinter, printerC );
  test.identical( outputsB[ 1 ].inputPrinter, printerB );
  test.identical( outputsB[ 1 ].originalOutput, 0 );
  test.identical( outputsB[ 1 ].exclusiveOutput, 0 );

  test.identical( outputsB[ 2 ].outputPrinter, printerD );
  test.identical( outputsB[ 2 ].inputPrinter, printerB );
  test.identical( outputsB[ 2 ].originalOutput, 0 );
  test.identical( outputsB[ 2 ].exclusiveOutput, 0 );

  test.identical( inputsC.length, 3 );
  test.identical( outputsC.length, 1 );

  test.identical( inputsC[ 0 ].outputPrinter, printerC );
  test.identical( inputsC[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsC[ 0 ].originalOutput, 0 );
  test.identical( inputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsC[ 1 ].outputPrinter, printerC );
  test.identical( inputsC[ 1 ].inputPrinter, printerA.printer );
  test.identical( inputsC[ 1 ].originalOutput, 0 );
  test.identical( inputsC[ 1 ].exclusiveOutput, 0 );

  test.identical( inputsC[ 2 ].outputPrinter, printerC );
  test.identical( inputsC[ 2 ].inputPrinter, printerB );
  test.identical( inputsC[ 2 ].originalOutput, 0 );
  test.identical( inputsC[ 2 ].exclusiveOutput, 0 );

  test.identical( outputsC[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsC[ 0 ].inputPrinter, printerC );
  test.identical( outputsC[ 0 ].originalOutput, 0 );
  test.identical( outputsC[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsD.length, 3 );
  test.identical( outputsD.length, 1 );

  test.identical( inputsD[ 0 ].outputPrinter, printerD );
  test.identical( inputsD[ 0 ].inputPrinter, inputPrinter );
  test.identical( inputsD[ 0 ].originalOutput, 0 );
  test.identical( inputsD[ 0 ].exclusiveOutput, 0 );

  test.identical( inputsD[ 1 ].outputPrinter, printerD );
  test.identical( inputsD[ 1 ].inputPrinter, printerA.printer );
  test.identical( inputsD[ 1 ].originalOutput, 0 );
  test.identical( inputsD[ 1 ].exclusiveOutput, 0 );

  test.identical( inputsD[ 2 ].outputPrinter, printerD );
  test.identical( inputsD[ 2 ].inputPrinter, printerB );
  test.identical( inputsD[ 2 ].originalOutput, 0 );
  test.identical( inputsD[ 2 ].exclusiveOutput, 0 );

  test.identical( outputsD[ 0 ].outputPrinter, outputPrinter );
  test.identical( outputsD[ 0 ].inputPrinter, printerD );
  test.identical( outputsD[ 0 ].originalOutput, 0 );
  test.identical( outputsD[ 0 ].exclusiveOutput, 0 );

  //restore console

  printerA.inputUnchain( inputPrinter );
  printerA.outputUnchain( outputPrinter );
  printerA.outputUnchain( printerC );
  printerA.outputUnchain( printerD );

  test.close( 'multiple inputs - multiple outputs' );

}

//

function hasInputDeep( test )
{
  test.case = 'has console in inputs';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  var got = l.hasInputDeep( console );
  var expected = true;
  test.identical( got, expected );

  test.case = 'has logger in inputs';
  var l = new _.Logger({ output : null });
  var got = l.hasInputDeep( logger );
  var expected = false;
  test.identical( got, expected );

  test.case = 'no args';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger({ output : console });
    logger.hasInputDeep();
  });
}

//

function hasOutputDeep( test )
{
  test.case = 'has logger in outputs';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  l1.outputTo( l2,{ combining : 'rewrite' } );
  var got = l1.hasOutputDeep( l2 );
  var expected = true;
  test.identical( got, expected );

  test.case = 'object not exists in outputs';
  var l1 = new _.Logger();
  var got = l1.hasOutputDeep( console );
  var expected = false;
  test.identical( got, expected );

  test.case = 'no args';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger({ output : console });
    logger.hasOutputDeep();
  });

  test.case = 'incorrect type';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger({ output : console });
    logger.hasOutputDeep( 1 );
  });
}

//

function _hasInput( test )
{
  test.case = 'l1->l2->l3, l3 has l1 in input chain';
  var l1 = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : null });
  var l3 = new _.Logger({ output : null });
  l1.outputTo( l2 )
  l2.outputTo( l3 );
  var got = l3.chainer._hasInput( l1, {} );
  var expected = true;
  test.identical( got, expected );

  test.case = 'console->l1,l2,l3, l1->l2->l3, l3 has l1 in input chain';
  var l1 = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : null });
  var l3 = new _.Logger({ output : null });
  l1.inputFrom( console );
  l2.inputFrom( console );
  l3.inputFrom( console );
  l2.inputFrom( l1 );
  l3.inputFrom( l2 );
  var got = l3.chainer._hasInput( l1, {} );
  var expected = true;
  test.identical( got, expected );
}

//

function _hasOutput( test )
{
  test.case = 'l1->l2->l3, l1 has l3 in output chain';
  var l1 = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : null });
  var l3 = new _.Logger({ output : null });
  l1.outputTo( l2 )
  l2.outputTo( l3 );
  var got = l1.chainer._hasOutput( l3, {} );
  var expected = true;
  test.identical( got, expected );

  test.case = 'two outputs for l1,l2, l1 has l3 in output chain';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  l1.outputTo( l2, { combining : 'append' } );
  l2.outputTo( l3, { combining : 'append' } );
  var got = l1.chainer._hasOutput( l3, {} );
  var expected = true;
  test.identical( got, expected );
}

//

function recursion( test )
{
  test.case = 'add own object to outputs';
  test.shouldThrowError( function()
  {
    var l = new _.Logger({ output : null });
    l.outputTo( l );
  });

  test.case = 'l1->l2->l1';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : null });
    var l2 = new _.Logger({ output : null });
    l1.outputTo( l2 );
    l2.outputTo( l1 );
  });

  test.case = 'l1->l2->l1';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : console });
    var l2 = new _.Logger({ output : console });
    l1.outputTo( l2, { combining : 'rewrite' } );
    l2.outputTo( l1, { combining : 'rewrite' } );
  });

  test.case = 'multiple inputs, try to add existing input to output';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : console });
    var l2 = new _.Logger({ output : console });
    var l3 = new _.Logger({ output : console });
    var l4 = new _.Logger({ output : console });
    l1.outputTo( l4, { combining : 'rewrite' } );
    l2.outputTo( l4, { combining : 'rewrite' } );
    l3.outputTo( l4, { combining : 'rewrite' } );
    l4.outputTo( l1, { combining : 'rewrite' } );
  });

  test.case = 'l3->l2,l2->l1,l1->l3';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger({ output : console });
    var l2 = new _.Logger({ output : console });
    var l3 = new _.Logger({ output : console });
    l1.inputFrom( l2, { combining : 'rewrite' } );
    l3.inputFrom( l1, { combining : 'rewrite' } );
    l2.inputFrom( l3, { combining : 'rewrite' } );
  });

  test.case = 'console->a->b->console';
  test.shouldThrowError( function()
  {
    var a = new _.Logger({ output : null });
    var b = new _.Logger({ output : null });
    a.inputFrom( console );
    b.inputFrom( a );
    b.outputTo( console );
  });

  test.case = 'input from existing output';
  test.shouldThrowError( function()
  {
    var a = new _.Logger({ output : console });
    a.inputFrom( console );
  });

  test.case = 'add existing output';
  test.shouldThrowError( function()
  {
    var a = new _.Logger({ output : console });
    a.outputTo( console, { combining : 'append' } );
  });
}

//

function _consoleBar( o )
{
  let test = o.test;

  if( _.Logger.consoleIsBarred( console ) )
  {
    o.consoleWasBarred = true;
    test.suite.consoleBar( 0 );
  }

  //

  test.case = 'bar/unbar console'
  var barDescriptor = _.Logger.consoleBar
  ({
    outputPrinter : _.Tester.logger,
    barPrinter : null,
    on : 1,
  });
  test.is( _.Logger.consoleIsBarred( console ) );

  if( Config.debug )
  {
    //try to on console again
    test.shouldThrowError( () =>
    {
      _.Logger.consoleBar
      ({
        outputPrinter : _.Tester.logger,
        barPrinter : null,
        on : 1,
      })
    });

    var consoleIsBarred = _.Logger.consoleIsBarred( console );

    // if( _.Logger.unbarringConsoleOnError )
    // test.is( !consoleIsBarred );
    // else
    test.is( consoleIsBarred );
  }

  barDescriptor.on = 0;
  _.Logger.consoleBar( barDescriptor );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'excluded console forwards message only to on logger';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var barDescriptor = _.Logger.consoleBar
  ({
    outputPrinter : _.Tester.logger,
    barPrinter : null,
    on : 1,
  });
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var l = new _.Logger
  ({
    output : null,
    onTransformEnd : ( o ) => received.push( o.input[ 0 ] )
  });
  l.inputFrom( console, { exclusiveOutput : 0 } );
  console.log( 'message' );
  l.inputUnchain( console );
  barDescriptor.on = 0;
  _.Logger.consoleBar( barDescriptor );
  test.identical( received, [] );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  if( Config.debug )
  {
    test.case = 'error if provided barPrinter has inputs/outputs'
    test.is( !_.Logger.consoleIsBarred( console ) );
    let o =
    {
      outputPrinter : _.Tester.logger,
      barPrinter : new _.Logger({ output : console }),
      on : 1,
    }
    test.shouldThrowError( () => _.Logger.consoleBar( o ) );
    test.is( !_.Logger.consoleIsBarred( console ) );
  }

  //

  if( o.consoleWasBarred )
  {
    test.suite.consoleBar( 1 );
    test.is( _.Logger.consoleIsBarred( console ) );
  }
}

//

function consoleBar( test )
{
  var o =
  {
    test : test,
    consoleWasBarred : false
  }

  try
  {
    _consoleBar( o );
  }
  catch( err )
  {
    if( o.consoleWasBarred )
    test.suite.consoleBar( 1 );

    throw _.errLogOnce( err );
  }

}

//

function consoleIs( test )
{
  test.case = 'consoleIs';

  test.is( _.consoleIs( console ) );
  test.is( !_.consoleIs( [] ) );
  test.is( !_.consoleIs( Object.create( null ) ) );

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.consoleIs() );
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

  if( _.Logger.consoleIsBarred( console ) )
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

  //

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

  //

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

  //

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
    test.is( _.Logger.consoleIsBarred( console ) );
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

//

function finit( test )
{
  var o =
  {
    test : test,
    consoleWasBarred : false
  }

  try
  {
    _consoleBar( o );
  }
  catch( err )
  {
    if( o.consoleWasBarred )
    test.suite.consoleBar( 1 );

    throw _.errLogOnce( err );
  }

}

//

var Self =
{

  name : 'Tools/base/printer/Chaining',

  routineTimeOut : 999999,

  silencing : 1,
  /* verbosity : 1, */

  tests :
  {

    levelsTest : levelsTest,
    chaining : chaining,
    consoleChaining : consoleChaining,
    chainingParallel : chainingParallel,
    // outputTo : outputTo,
    // outputUnchain : outputUnchain,
    // inputFrom : inputFrom,
    // inputUnchain : inputUnchain,

    output : output,
    input : input,

    chain : chain,

    hasInputDeep : hasInputDeep,
    hasOutputDeep : hasOutputDeep,
    _hasInput : _hasInput,
    _hasOutput : _hasOutput,
    recursion : recursion,

    consoleBar : consoleBar,
    consoleIs : consoleIs,

    clone : clone,
    finit : finit,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
