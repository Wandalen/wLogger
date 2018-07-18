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
  var logger = new _.Logger( { output : fakeConsole });

  var l = new _.Logger( { output : logger } );

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
  function _onWrite( args ) { got.push( args.output[ 0 ] ) };

  test.case = 'case1: l2 -> l1';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { output : l1 } );
  l2.log( '1' );
  l2.log( '2' );
  var expected = [ '1', '2' ];
  test.identical( got, expected );

  test.case = 'case2: l3 -> l2 -> l1';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { output : l1, onWrite : _onWrite } );
  var l3 = new _.Logger( { output : l2 } );
  l2.log( 'l2' );
  l3.log( 'l3' );
  var expected = [ 'l2', 'l2', 'l3', 'l3' ];
  test.identical( got, expected );

  test.case = 'case3: l4->l3->l2->l1';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { output : l1, onWrite : _onWrite } );
  var l3 = new _.Logger( { output : l2, onWrite : _onWrite } );
  var l4 = new _.Logger( { output : l3, onWrite : _onWrite } );
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
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { onWrite : _onWrite } );
  var l3 = new _.Logger( { onWrite : _onWrite } );
  var l4 = new _.Logger( { onWrite : _onWrite } );
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
  //
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

function consoleChaining( test )
{

  var consoleWasBarred = false;

  if( _.Logger.consoleIsBarred( console ) )
  {
    consoleWasBarred = true;
    debugger
    _global_.wTester._barOptions.bar = 0;
    _.Logger.consoleBar( _global_.wTester._barOptions );
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
  var chained = l.inputFrom( console );
  test.is( chained );
  test.is( !_.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputNotDeep( console ) );

  //

  test.case = 'inputFrom console that exists in outputs, barring on';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.inputFrom( console, { barring : 1  } ) )

  //

  test.case = 'inputFrom console that not exists in outputs, barring on';
  var l = new _.Logger({ output : null });
  var chained = l.inputFrom( console, { barring : 1 } );
  test.is( chained );
  test.is( _.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputNotDeep( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  if( Config.debug )
  {
    test.case = 'console is barred, try to chain again';
    var l = new _.Logger({ output : null });
    var chained = l.inputFrom( console, { barring : 1 } );
    test.is( chained );
    test.is( _.Logger.consoleIsBarred( console ) );
    test.shouldThrowError( () => l.inputFrom( console, { barring : 1 } ) );
    l.inputUnchain( console );
    test.is( !l.hasInputNotDeep( console ) );
    test.is( !_.Logger.consoleIsBarred( console ) );
  }

  //

  test.case = 'outputTo console that exists in outputs';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.outputTo( console ) );
  test.is( console.inputs === undefined || console.inputs.indexOf( l ) === -1 );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in outputs, unbarring on';
  var l = new _.Logger({ output : console });
  test.shouldThrowError( () => l.outputTo( console, { unbarring : 1 } ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in inputs, unbarring off';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  test.shouldThrowError( () => l.outputTo( console, { unbarring : 0 } ) );
  test.is( !l.hasOutputNotDeep( console ) );
  l.inputUnchain( console );
  test.is( !l.hasInputNotDeep( console ) );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'outputTo console that exists in inputs, unbarring on';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  l.outputTo( console, { unbarring : 1 } );
  test.is( l.outputs[ l.outputs.length - 1 ] === console.inputs[ console.inputs.length - 1 ] );
  l.inputUnchain( console );
  l.outputUnchain( console );
  test.is( !l.hasInputNotDeep( console ) && !l.inputs.length );
  test.is( !l.hasOutputNotDeep( console ) && !l.outputs.length );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'console is not barred, several inputs for console';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : null, onWrite : onWrite });
  l4.inputFrom( console, { combining : 'append' } );
  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.inputUnchain( console );
  test.identical( received, [ 'l1', 'l2', 'l3' ] );

  //

  test.case = 'console is not barred, several outputs from console';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : null, onWrite : onWrite });
  var l2 = new _.Logger({ output : null, onWrite : onWrite });
  var l3 = new _.Logger({ output : null, onWrite : onWrite });

  l1.inputFrom( console, { combining : 'append' } );
  l2.inputFrom( console, { combining : 'append' } );
  l3.inputFrom( console, { combining : 'append' } );
  console.log( 'msg' );
  l1.inputUnchain( console );
  l2.inputUnchain( console );
  l3.inputUnchain( console );
  test.identical( received, [ 'msg', 'msg', 'msg' ] );

  //

  test.case = 'console is not barred, several outputs/inputs';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );

  /*inputs*/

  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });

  /*outputs*/

  var l4 = new _.Logger({ output : null, onWrite : onWrite });
  var l5 = new _.Logger({ output : null, onWrite : onWrite });
  var l6 = new _.Logger({ output : null, onWrite : onWrite });

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

  if( consoleWasBarred )
  {
    _global_.wTester._barOptions = _.Logger.consoleBar({ outputLogger : _global_.wTester.logger, bar : 1 });
    test.is( _.Logger.consoleIsBarred( console ) );
  }

  //

  test.case = 'console is barred, several inputs for console';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : null, onWrite : onWrite });
  l4.inputFrom( console, { combining : 'append' } );
  l1.log( 'l1' );
  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.inputUnchain( console );
  test.identical( received, [] );

  //

  test.case = 'console is barred, several outputs from console';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );
  var l1 = new _.Logger({ output : null, onWrite : onWrite });
  var l2 = new _.Logger({ output : null, onWrite : onWrite });
  var l3 = new _.Logger({ output : null, onWrite : onWrite });

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

  test.case = 'console is barred, several outputs/inputs';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var onWrite = ( o ) => received.push( o.output[ 0 ] );

  /*inputs*/

  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });

  /*outputs*/

  var l4 = new _.Logger({ output : null, onWrite : onWrite });
  var l5 = new _.Logger({ output : null, onWrite : onWrite });
  var l6 = new _.Logger({ output : null, onWrite : onWrite });

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

  test.case = 'if console is barred, other console outputs must be omitted';
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var l = new _.Logger
  ({
    output : null,
    onWrite : ( o ) => received.push( o.input[ 0 ] )
  })
  l.inputFrom( console );
  test.is( l.hasInputNotDeep( console ) );
  console.log( 'message' );
  l.inputUnchain( console );
  test.is( _.Logger.consoleIsBarred( console ) );
  test.identical( received, [] )

  //
}

//

function chainingParallel( test )
{
  function _onWrite( args ) { got.push( args.output[ 0 ] ) };

  test.case = 'case1: 1 -> *';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
  var l3 = new _.Logger( { onWrite : _onWrite  } );
  var l4 = new _.Logger({ output : console });
  l4.outputTo( l3, { combining : 'append' } );
  l4.outputTo( l2, { combining : 'append' } );
  l4.outputTo( l1, { combining : 'append' } );

  l4.log( 'msg' );
  var expected = [ 'msg','msg','msg' ];
  test.identical( got, expected );

  test.case = 'case2: many inputs to 1 logger';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
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
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l1.inputFrom( l2, { combining : 'rewrite' } );
  l1.inputFrom( l3, { combining : 'rewrite' } );
  l1.inputFrom( l4, { combining : 'rewrite' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );

  test.case = 'case3: 1 logger to many loggers';
  var got = [];
  var l1 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l2 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l3 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l4 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  l1.outputTo( l2, { combining : 'append' } );
  l1.outputTo( l3, { combining : 'append' } );
  l1.outputTo( l4, { combining : 'append' } );

  l1.log( 'msg' );
  var expected = [ 'msg', 'msg', 'msg', 'msg' ]
  test.identical( got, expected );

  test.case = 'case3: many loggers from 1 logger';
  var got = [];
  var l1 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l2 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l3 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
  var l4 = new _.Logger({ output : fakeConsole, onWrite : _onWrite });
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
  var l5 = new _.Logger({ output : null, onWrite : _onWrite });
  var l6 = new _.Logger({ output : null, onWrite : _onWrite });
  var l7 = new _.Logger({ output : null, onWrite : _onWrite });

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
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  var l4 = new _.Logger({ output : console });
  l1.inputFrom( l2, { combining : 'rewrite' } );
  l1.inputFrom( l3, { combining : 'rewrite' } );
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
  // var l1 = new _.Logger({ output : null,onWrite : _onWrite });
  // var l2 = new _.Logger({ output : null,onWrite : _onWrite });
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
  var got = l.outputTo( l1, { combining : 'rewrite' } );
  var expected = true;
  test.identical( got, expected );

  //

  test.case = 'few logger are writting into console'
  var l = new _.Logger({ output : null });
  var l2 = new _.Logger({ output : null });
  var l3 = new _.Logger({ output : null });

  l.outputTo( console );
  l2.outputTo( console );
  l3.outputTo( console );

  var got = [];
  var temp = console.outputs[ 0 ].output.onWrite;
  console.outputs[ 0 ].output.onWrite = ( o ) => got.push( o.input[ 0 ] );
  l.log( 1 );
  l2.log( 2 );
  l3.log( 3 );
  console.outputs[ 0 ].output.onWrite = temp;
  test.identical( got, [ '1', '2', '3' ] );

  //

  test.case = '';
  var l = new _.Logger({ output : null });
  l.outputTo( console );
  var got = l.outputs[ 0 ].output;
  var expected = console;
  l.outputUnchain( console )
  test.identical( got, expected );

  test.case = 'empty output';
  var l = new _.Logger({ output : console });
  l.outputTo( null, { combining : 'rewrite' } );
  test.identical( l.outputs.length, 0 );

  test.case = 'empty output';
  var l = new _.Logger({ output : console });
  l.outputTo( { },{ combining : 'rewrite' } );
  test.identical( l.outputs.length, 1 );

  /*rewrite*/
  test.case = 'rewrite with null';
  var l = new _.Logger({ output : console });
  l.outputTo( null, { combining : 'rewrite' } );
  var got = [ l.output, l.outputs ];
  var expected = [ null, [] ];
  test.identical( got, expected );

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
  function _onWrite( args ) { got.push( args.output[ 0 ] ) };

  test.case = 'case1 delete l1 from l2 outputs, l2 still have one output';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
  l2.outputTo( l1, { combining : 'append' } );
  l2.outputUnchain( l1 )
  l2.log( 'msg' );
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.case = 'case2 delete l1 from l2 outputs, no msg transfered';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger({ output : console });
  l2.outputTo( l1, { combining : 'rewrite' } );
  l2.outputUnchain( l1 );
  l2.log( 'msg' )
  var expected = [];
  test.identical( got, expected );

  test.case = 'case3: delete l1 from l2 outputs';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
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
  var onWrite = function( args ){ got.push( args.output[ 0 ] ) };

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
  // var l = new _.Logger( { output : null, onWrite : onWrite } );
  // l.inputFrom( console );
  // l._prefix = '*';
  // console.log( 'abc' )
  // var expected = [ '*abc' ];
  // l.inputUnchain( console );
  // test.identical( got, expected );

  test.case = 'case4: logger as input';
  var got = [];
  var l = new _.Logger( { onWrite : onWrite } );
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
  var onWrite = function( args ){ got.push( args[0] ) };

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
  var l = new _.Logger( { output : null,onWrite : onWrite } );
  l.inputFrom( console );
  l.inputUnchain( console );
  console.log( '1' );
  var expected = [];
  test.identical( got, expected );

  test.case = 'case4: remove logger from input';
  var got = [];
  var l1 = new _.Logger( { onWrite : onWrite } );
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
  var l1 = new _.Logger({ output : console });
  var got = l1.hasOutputDeep( {} );
  var expected = false;
  test.identical( got, expected );

  test.case = 'no args';
  test.shouldThrowError( function()
  {
    var logger = new _.Logger({ output : console });
    logger.hasOutputDeep();
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
  var got = l3._hasInput( l1, {} );
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
  var got = l3._hasInput( l1, {} );
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
  var got = l1._hasOutput( l3, {} );
  var expected = true;
  test.identical( got, expected );

  test.case = 'two outputs for l1,l2, l1 has l3 in output chain';
  var l1 = new _.Logger({ output : console });
  var l2 = new _.Logger({ output : console });
  var l3 = new _.Logger({ output : console });
  l1.outputTo( l2, { combining : 'append' } );
  l2.outputTo( l3, { combining : 'append' } );
  var got = l1._hasOutput( l3, {} );
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

function consoleBar( test )
{
  var consoleWasBarred = false;

  if( _.Logger.consoleIsBarred( console ) )
  {
    consoleWasBarred = true;
    _global_.wTester._barOptions.bar = 0;
    _.Logger.consoleBar( _global_.wTester._barOptions );
  }

  //

  test.case = 'bar/unbar console'
  var barDescriptor = _.Logger.consoleBar
  ({
    outputLogger : _.Tester.logger,
    barLogger : null,
    bar : 1,
  });
  test.is( _.Logger.consoleIsBarred( console ) );

  if( Config.debug )
  {
    //try to bar console again
    test.shouldThrowError( () =>
    {
      _.Logger.consoleBar
      ({
        outputLogger : _.Tester.logger,
        barLogger : null,
        bar : 1,
      })
    });

    var consoleIsBarred = _.Logger.consoleIsBarred( console );

    if( _.Logger.unbarringConsoleOnError )
    test.is( !consoleIsBarred );
    else
    test.is( consoleIsBarred );
  }

  barDescriptor.bar = 0;
  _.Logger.consoleBar( barDescriptor );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  test.case = 'barred console forwards message only to bar logger';
  test.is( !_.Logger.consoleIsBarred( console ) );
  var barDescriptor = _.Logger.consoleBar
  ({
    outputLogger : _.Tester.logger,
    barLogger : null,
    bar : 1,
  });
  test.is( _.Logger.consoleIsBarred( console ) );
  var received = [];
  var l = new _.Logger
  ({
    output : null,
    onWrite : ( o ) => received.push( o.input[ 0 ] )
  });
  l.inputFrom( console, { barring : 0 } );
  console.log( 'message' );
  l.inputUnchain( console );
  barDescriptor.bar = 0;
  _.Logger.consoleBar( barDescriptor );
  test.identical( received, [] );
  test.is( !_.Logger.consoleIsBarred( console ) );

  //

  if( Config.debug )
  {
    test.case = 'error if provider barLogger has inputs/outputs'
    test.is( !_.Logger.consoleIsBarred( console ) );
    var o =
    {
      outputLogger : _.Tester.logger,
      barLogger : new _.Logger,
      bar : 1,
    }
    test.shouldThrowError( () => _.Logger.consoleBar( o ) );
    test.is( !_.Logger.consoleIsBarred( console ) );
  }

  //

  if( consoleWasBarred )
  {
    _global_.wTester._barOptions = _.Logger.consoleBar({ outputLogger : _global_.wTester.logger, bar : 1 });
    test.is( _.Logger.consoleIsBarred( console ) );
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

var Self =
{

  name : 'Tools/base/printer/Chaining',

  silencing : 1,
  /* verbosity : 1, */

  tests :
  {

    levelsTest : levelsTest,
    chaining : chaining,
    consoleChaining : consoleChaining,
    chainingParallel : chainingParallel,
    outputTo : outputTo,
    outputUnchain : outputUnchain,
    inputFrom : inputFrom,
    inputUnchain : inputUnchain,
    hasInputDeep : hasInputDeep,
    hasOutputDeep : hasOutputDeep,
    _hasInput : _hasInput,
    _hasOutput : _hasOutput,
    recursion : recursion,

    consoleBar : consoleBar,
    consoleIs : consoleIs,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
