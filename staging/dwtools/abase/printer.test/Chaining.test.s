( function _Chaining_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/dwtools/abase/z.test/Chaining.test.s

*/

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

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

  test.description = 'case1 : ';
  logger.up( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2 : add 2 levels, first logger level must be  2';
  l.up( 2 );
  var got = logger.log( 'abc' );
  var expected = logger;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3 : current levels of loggers must be equal';
  var got = l.level;
  var expected = logger.level;
  test.identical( got, expected );

  test.description = 'case4 : logger level - 2, l level - 4, text must have level 6 ';
  l.up( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5 : zero level';
  l.down( 4 );
  logger.down( 2 );
  var got = l.log( 'abc' );
  var expected = l;
  test.identical( _escaping( got ), _escaping( expected ) );

  if( Config.debug )
  {
    test.description = 'level cant be less then zero';
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

  test.description = 'case1: l1 must get two messages';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { output : l1 } );
  l2.log( '1' );
  l2.log( '2' );
  var expected = [ '1', '2' ];
  test.identical( got, expected );

  test.description = 'case2: multiple loggers';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite } );
  var l2 = new _.Logger( { output : l1, onWrite : _onWrite } );
  var l3 = new _.Logger( { output : l2 } );
  l2.log( 'l2' );
  l3.log( 'l3' );
  var expected = [ 'l2', 'l2', 'l3', 'l3' ];
  test.identical( got, expected );

  test.description = 'case3: multiple loggers';
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

  test.description = 'case4: input test ';
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

  // test.description = 'case5: l1->l2->l3 leveling off ';
  // var l1 = new _.Logger();
  // var l2 = new _.Logger();
  // var l3 = new _.Logger();
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
  // test.description = 'case6: l1->l2->l3 leveling on ';
  // var l1 = new _.Logger();
  // var l2 = new _.Logger();
  // var l3 = new _.Logger();
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

  var wasBarred = false;

  if( _.Logger.consoleIsBarred( console ) )
  {
    wasBarred = true;
    _.Tester._bar.bar = 0;
    _.Logger.consoleBar( _.Tester._bar );
  }

  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'inputFrom console that exists in outputs';
  var l = new _.Logger();
  test.shouldThrowError( () => l.inputFrom( console ) );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'inputFrom console that not exists in outputs';
  var l = new _.Logger({ output : null });
  var chained = l.inputFrom( console );
  test.shouldBe( chained );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.shouldBe( !l.hasInputNotDeep( console ) );

  //

  test.description = 'inputFrom console that exists in outputs, barring on';
  var l = new _.Logger();
  test.shouldThrowError( () => l.inputFrom( console, { barring : 1  } ) )

  //

  test.description = 'inputFrom console that not exists in outputs, barring on';
  var l = new _.Logger({ output : null });
  var chained = l.inputFrom( console, { barring : 1 } );
  test.shouldBe( chained );
  test.shouldBe( _.Logger.consoleIsBarred( console ) );
  l.inputUnchain( console );
  test.shouldBe( !l.hasInputNotDeep( console ) );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'console is barred, try to chain again';
  var l = new _.Logger({ output : null });
  var chained = l.inputFrom( console, { barring : 1 } );
  test.shouldBe( chained );
  test.shouldBe( _.Logger.consoleIsBarred( console ) );
  test.shouldThrowError( () => l.inputFrom( console, { barring : 1 } ) );
  l.inputUnchain( console );
  test.shouldBe( !l.hasInputNotDeep( console ) );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'outputTo console that exists in outputs';
  var l = new _.Logger();
  test.shouldThrowError( () => l.outputTo( console ) );
  test.shouldBe( console.inputs === undefined || console.inputs.indexOf( l ) === -1 );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'outputTo console that exists in outputs, unbarring on';
  var l = new _.Logger();
  test.shouldThrowError( () => l.outputTo( console, { unbarring : 1 } ) );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'outputTo console that exists in inputs, unbarring off';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  test.shouldThrowError( () => l.outputTo( console, { unbarring : 0 } ) );
  test.shouldBe( !l.hasOutputNotDeep( console ) );
  l.inputUnchain( console );
  test.shouldBe( !l.hasInputNotDeep( console ) );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  //

  test.description = 'outputTo console that exists in inputs, unbarring on';
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  l.outputTo( console, { unbarring : 1 } );
  test.shouldBe( l.outputs[ l.outputs.length - 1 ] === console.inputs[ console.inputs.length - 1 ] );
  l.inputUnchain( console );
  l.outputUnchain( console );
  test.shouldBe( !l.hasInputNotDeep( console ) && !l.inputs.length );
  test.shouldBe( !l.hasOutputNotDeep( console ) && !l.outputs.length );
  test.shouldBe( !_.Logger.consoleIsBarred( console ) );

  if( wasBarred )
  _.Tester._bar = _.Logger.consoleBar({ outputLogger : _.Tester.logger, bar : 1 });
}

//

function chainingParallel( test )
{
  function _onWrite( args ) { got.push( args.output[ 0 ] ) };

  test.description = 'case1: 1 -> *';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
  var l3 = new _.Logger( { onWrite : _onWrite  } );
  var l4 = new _.Logger();
  l4.outputTo( l3, { combining : 'append' } );
  l4.outputTo( l2, { combining : 'append' } );
  l4.outputTo( l1, { combining : 'append' } );

  l4.log( 'msg' );
  var expected = [ 'msg','msg','msg' ];
  test.identical( got, expected );

  test.description = 'case2: * -> 1';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new _.Logger();
  var l3 = new _.Logger();
  var l4 = new _.Logger();
  l2.outputTo( l1, { combining : 'rewrite' } );
  l3.outputTo( l1, { combining : 'rewrite' } );
  l4.outputTo( l1, { combining : 'rewrite' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );

  test.description = 'case3: *inputs -> 1';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new _.Logger();
  var l3 = new _.Logger();
  var l4 = new _.Logger();
  l1.inputFrom( l2, { combining : 'rewrite' } );
  l1.inputFrom( l3, { combining : 'rewrite' } );
  l1.inputFrom( l4, { combining : 'rewrite' } );

  l2.log( 'l2' );
  l3.log( 'l3' );
  l4.log( 'l4' );
  var expected = [ 'l2','l3','l4' ];
  test.identical( got, expected );

  test.description = 'case4: outputTo/inputFrom, remove some outputs ';
  var got = [];
  var l1 = new _.Logger( { output : fakeConsole, onWrite : _onWrite  } );
  var l2 = new _.Logger();
  var l3 = new _.Logger();
  var l4 = new _.Logger();
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

  // test.description = 'case5: l1->* leveling off ';
  // var l1 = new _.Logger();
  // var l2 = new _.Logger();
  // var l3 = new _.Logger();
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
  // test.description = 'case6: l1->* leveling on ';
  // var l1 = new _.Logger();
  // var l2 = new _.Logger();
  // var l3 = new _.Logger();
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
  // test.description = 'case7: input from console twice ';
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

  test.description = 'output already exist';

  test.identical( got, expected );
  test.shouldThrowError( function()
  {
    var l = new _.Logger();
    var l1 = new _.Logger();
    l.outputTo( l1, { combining : 'append' } );
    l.outputTo( l1, { combining : 'append' } );
  });

  test.description = 'output already exist, combining : rewrite';
  var l = new _.Logger();
  var l1 = new _.Logger();
  l.outputTo( l1, { combining : 'append' } );
  var got = l.outputTo( l1, { combining : 'rewrite' } );
  var expected = true;
  test.identical( got, expected );

  //

  test.description = 'few logger are writting into console'
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

  if( Config.debug )
  {
    var l = new _.Logger();

    test.description = 'no args';
    test.shouldThrowError( function()
    {
      l.outputTo();
    });

    test.description = 'output is not a Object';
    test.shouldThrowError( function()
    {
      l.outputTo( 'output', { combining : 'rewrite' } );
    });

    test.description = 'not allowed combining mode';
    test.shouldThrowError( function()
    {
      l.outputTo( console, { combining : 'mode' } );
    });

    // test.description = 'not allowed leveling mode';
    // test.shouldThrowError( function()
    // {
    //   l.outputTo( console, { combining : 'rewrite', leveling : 'mode' } );
    // });
  }
}

//

function outputUnchain( test )
{
  function _onWrite( args ) { got.push( args.output[ 0 ] ) };

  test.description = 'case1 delete l1 from l2 outputs, l2 still have one output';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
  l2.outputTo( l1, { combining : 'append' } );
  l2.outputUnchain( l1 )
  l2.log( 'msg' );
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.description = 'case2 delete l1 from l2 outputs, no msg transfered';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger();
  l2.outputTo( l1, { combining : 'rewrite' } );
  l2.outputUnchain( l1 );
  l2.log( 'msg' )
  var expected = [];
  test.identical( got, expected );

  test.description = 'case3: delete l1 from l2 outputs';
  var got = [];
  var l1 = new _.Logger( { onWrite : _onWrite  } );
  var l2 = new _.Logger( { onWrite : _onWrite  } );
  var l3 = new _.Logger();
  l2.outputTo( l1, { combining : 'append' } );
  l3.outputTo( l2, { combining : 'append' } );
  l2.outputUnchain( l1 );
  l3.log( 'msg' )
  var expected = [ 'msg' ];
  test.identical( got, expected );

  test.description = 'no args - remove all outputs';
  var l1 = new _.Logger();
  test.identical( l1.outputs.length, 1 );
  l1.outputUnchain();
  test.identical( l1.outputs.length, 0 );

  test.description = 'empty outputs list';
  var l = new _.Logger();
  var l1 = new _.Logger();
  l.outputTo( l1, { combining : 'rewrite' } );
  l.outputUnchain( l1 );
  test.identical( l.outputs.length, 0 );
  var got = l.outputUnchain( l1 );
  test.identical( got, false );

  if( Config.debug )
  {
    test.description = 'incorrect type';
    test.shouldThrowError( function()
    {
      var l = new _.Logger();
      l.outputUnchain( '1' );
    });
  }
}

//

function inputFrom( test )
{
  var onWrite = function( args ){ got.push( args.output[ 0 ] ) };

  test.description = 'case1: input already exist';
  test.shouldThrowError( function()
  {
    var l1 = new _.Logger();
    var l2 = new _.Logger({ output : l1 });
    l1.inputFrom( l2 );
  });

  test.description = 'case2: input already exist';
  test.shouldThrowError( function()
  {
    var l = new _.Logger();
    var l1 = new _.Logger();
    l.outputTo( l1, { combining : 'append' } )
    l1.inputFrom( l );
  });

  // !!! needs silencing = false
  //
  // test.description = 'case3: console as input';
  // var got = [];
  // var l = new _.Logger( { output : null, onWrite : onWrite } );
  // l.inputFrom( console );
  // l._prefix = '*';
  // console.log( 'abc' )
  // var expected = [ '*abc' ];
  // l.inputUnchain( console );
  // test.identical( got, expected );

  test.description = 'case4: logger as input';
  var got = [];
  var l = new _.Logger( { onWrite : onWrite } );
  var l2 = new _.Logger( );
  l.inputFrom( l2 );
  l._prefix = '--';
  l2.log( 'abc' )
  var expected = [ '--abc' ];
  test.identical( got, expected );

  if( Config.debug )
  {
    var l = new _.Logger();

    test.description = 'no args';
    test.shouldThrowError( function()
    {
      l.inputFrom();
    });

    test.description = 'incorrect type';
    test.shouldThrowError( function()
    {
      l.inputFrom( '1' );
    });

    test.description = 'console exists as output';
    test.shouldThrowError( function()
    {
      l.inputFrom( console );
    });
  }
}

//

function inputUnchain( test )
{
  var onWrite = function( args ){ got.push( args[0] ) };

  test.description = 'case1: input not exist in the list';
  var l = new _.Logger();
  var got = l.inputUnchain( console );
  var expected = false;
  test.identical( got, expected );

  test.description = 'case2: input not exist in the list';
  var l = new _.Logger();
  var l1 = new _.Logger();
  var got = l.inputUnchain( l1 );
  var expected = false;
  test.identical( got, expected );

  test.description = 'case3: remove console from input';
  var got = [];
  var l = new _.Logger( { output : null,onWrite : onWrite } );
  l.inputFrom( console );
  l.inputUnchain( console );
  console.log( '1' );
  var expected = [];
  test.identical( got, expected );

  test.description = 'case4: remove logger from input';
  var got = [];
  var l1 = new _.Logger( { onWrite : onWrite } );
  var l2 = new _.Logger();
  l1.inputFrom( l2 );
  l1.inputUnchain( l2 );
  l2.log( '1' );
  var expected = [];
  test.identical( got, expected );

  test.description = 'no args - removes all inputs';
  var l1 = new _.Logger();
  var l2 = new _.Logger({ output : null });
  l1.inputFrom( l2 );
  test.identical( l1.inputs.length, 1 );
  test.identical( l2.outputs.length, 1 );
  l1.inputUnchain();
  test.identical( l1.inputs.length, 0 );
  test.identical( l2.outputs.length, 0 );

  if( Config.debug )
  {
    test.description = 'incorrect type';
    test.shouldThrowError( function()
    {
      var logger = new _.Logger();
      logger.inputUnchain( '1' );
    });
  }
}

//

function consoleIs( test )
{
  test.description = 'consoleIs';

  test.shouldBe( _.Logger.consoleIs( console ) );
  test.shouldBe( !_.Logger.consoleIs( [] ) );
  test.shouldBe( !_.Logger.consoleIs( Object.create( null ) ) );

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.Logger.consoleIs() );
}

//

var Self =
{

  name : 'Chaining test',

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
    consoleIs : consoleIs

  },

}

//

Self = wTestSuit( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
