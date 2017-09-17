( function _Logger_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/dwtools/abase/z.test/Logger.test.s

*/

if( typeof module !== 'undefined' )
{

  require( '../top/Logger.s' );

  var _ = wTools;

  // require( '../../../abase/xTesting/cTester.debug.s' );

  _.include( 'wTesting' );

}

//

var _ = wTools;
var Parent = wTools.Tester;

//

function outputTo( test )
{
  test.description = '';
  var l = new wLogger({ output : null });
  l.outputTo( console );
  var got = l.outputs[ 0 ].output;
  var expected = console;
  l.outputUnchain( console )
  test.identical( got, expected );

  test.description = 'empty output';
  var l = new wLogger();
  l.outputTo( null, { combining : 'rewrite' } );
  test.identical( l.outputs.length, 0 );

  test.description = 'empty output';
  var l = new wLogger();
  l.outputTo( { },{ combining : 'rewrite' } );
  test.identical( l.outputs.length, 1 );

  /*rewrite*/
  test.description = 'rewrite with null';
  var l = new wLogger();
  l.outputTo( null, { combining : 'rewrite' } );
  var got = [ l.output, l.outputs ];
  var expected = [ null, [] ];
  test.identical( got, expected );

  test.description = 'rewrite';
  var l = new wLogger();
  var l1 = new wLogger();
  l.outputTo( l1, { combining : 'rewrite' } );
  var got = ( l.output === l1 && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

 /*append*/
 test.description = 'append';
 var l = new wLogger();
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'append' } );
 var got = ( l.output === l1 && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'append list is empty';
 var l = new wLogger({ output : null});
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'append' } );
 var got = ( l.output === l1 && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'append null';
 var l = new wLogger();
 test.shouldThrowErrorSync( function()
 {
   l.outputTo( null, { combining : 'append' } );
 })


 test.description = 'append existing';
 var l = new wLogger();
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'append' } );
 test.shouldThrowError(function()
 {
   l.outputTo( l1, { combining : 'append' } );
 })

 /*prepend*/
 test.description = 'prepend';
 var l = new wLogger();
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'prepend' } );
 var got = ( l.outputs[ 0 ].output === l1 && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'prepend existing';
 var l = new wLogger();
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'prepend' } );
 test.shouldThrowError(function()
 {

   l.outputTo( l1, { combining : 'prepend' } );
 })

 test.description = 'prepend null';
 var l = new wLogger();
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'prepend' } );
 test.shouldThrowErrorSync( function()
 {
   var got = l.outputTo( null, { combining : 'prepend' } );

 })

 /*supplement*/
 test.description = 'try supplement not empty list';
 var l = new wLogger();
 var l1 = new wLogger();
 var got = l.outputTo( l1, { combining : 'supplement' } );
 var expected = false;
 test.identical( got, expected );

 test.description = 'supplement';
 var l = new wLogger({  output : null });
 var l1 = new wLogger();
 l.outputTo( l1, { combining : 'supplement' } );
 var got = ( l.output && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'supplement null';
 var l = new wLogger();
 test.shouldThrowErrorSync( function()
 {
   var got = l.outputTo( null, { combining : 'supplement' } );

 })

 /*combining off*/
 test.description = 'combining off';
 var l = new wLogger({  output : null });
 var l1 = new wLogger();
 l.outputTo( l1 );
 var got = ( l.output && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 if( Config.debug )
 {
   var l1 = new wLogger();

   test.description = 'empty call';
   test.shouldThrowError( function()
   {
     l1.outputTo( )
   });

   test.description = 'invalid output type';
   test.shouldThrowError( function()
   {
     l1.outputTo( '1' )
   });

   test.description = 'invalid combining type';
   test.shouldThrowError( function()
   {
     l1.outputTo( console, { combining : 'invalid' } );
   });

   test.description = 'invalid leveling type';
   test.shouldThrowError( function()
   {
     l1.outputTo( console, { leveling : 'invalid' } );
   });

   test.description = 'combining off, outputs not empty';
   test.shouldThrowError( function()
   {
     l1.outputTo( console );
   });

   test.description = ' ';
   var l1 = new wLogger({ output : null });
   var l2 = new wLogger();
   test.shouldThrowError( function()
   {
     l1.inputFrom( console );
     l1.outputTo( l2, { combining : 'append' } )
   });
   l1.inputUnchain( console );
 }
}

//

function outputUnchain( test )
{
  test.description = 'remove console from output';
  var l = new wLogger();
  var got = l.outputUnchain( console );
  var expected = true;
  test.identical( got, expected );

  test.description = 'output not exists';
  var l = new wLogger();
  var got = l.outputUnchain( {} );
  var expected = false;
  test.identical( got, expected );

  test.description = 'remove from output';
  var l1 = new wLogger();
  var l2 = new wLogger({ output : l1 });
  var got = [ l2.outputUnchain( l1 ), l2.outputs.length, l1.inputs.length]
  var expected = [ true, 0, 0 ];
  test.identical( got, expected );

  test.description = 'remove from output';
  var l1 = new wLogger();
  var l2 = new wLogger();
  l2.outputTo( l1, { combining : 'append' } );
  var got = [ l2.outputUnchain( l1 ), l2.outputs.length, l1.inputs.length ]
  var expected = [ true, 1, 0 ];
  test.identical( got, expected );

  test.description = 'no args';
  var l = new wLogger();
  test.identical( l.outputs.length, 1 );
  l.outputUnchain();
  test.identical( l.outputs.length, 0 );


  test.description = 'output is not a object';
  test.shouldThrowError( function()
  {
    var l = new wLogger();
    l.outputUnchain( 1 );
  });

  test.description = 'empty ouputs';
  var l = new wLogger({ output : null });
  var got = l.outputUnchain( console );
  test.identical( got, false )

  test.description = 'try to remove itself';
  test.shouldThrowError( function()
  {
    var l = new wLogger();
    l.outputUnchain( l );
  });

}

//

function inputFrom( test )
{
  test.description = 'try to add existing input';
  var l = new wLogger();
  var l1 = new wLogger({ output : l });
  test.shouldThrowError( function()
  {
    l.inputFrom( l1 );
  });

  test.description = 'try to add console that exists in output';
  var l = new wLogger();
  test.shouldThrowError( function()
  {
    l.inputFrom( console );
  });

  test.description = 'try to add console';
  var l = new wLogger({ output : null });
  var got = [ l.inputFrom( console ), l.inputs.length ];
  var expected = [ true, 1 ];
  l.inputUnchain( console );
  test.identical( got, expected );

  test.description = 'try to add other logger';
  var l = new wLogger();
  var l1 = new wLogger();
  var got = [ l.inputFrom( l1 ), l.inputs.length,l1.outputs.length ];
  var expected = [ true, 1, 2 ];
  test.identical( got, expected );

  test.description = 'try to add itself';
  test.shouldThrowError( function()
  {
    var l = new wLogger();
    l.inputFrom( l );
  });

  test.description = 'try to add null';
  test.shouldThrowError( function()
  {
    var l = new wLogger();
    l.inputFrom( null );
  });

  test.description = 'simple recursion';
  test.shouldThrowError( function()
  {
    var l = new wLogger();
    var l1 = new wLogger();
    l1.inputFrom( l );
    l1.inputFrom( l1 );
  });

  test.description = 'l1->l2,l2->l3,l3->l1';
  test.shouldThrowError( function()
  {
    var l1 = new wLogger();
    var l2 = new wLogger();
    var l3 = new wLogger();
    l1.inputFrom( l3 );
    l2.inputFrom( l1 );
    l3.inputFrom( l2 );
  });

  test.description = 'console->l1->l2->console';
  var l1 = new wLogger();
  var l2 = new wLogger({ output : null });
  test.shouldThrowError( function()
  {
    l2.inputFrom( console );
    l1.inputFrom( l2 );
  });
  l2.inputUnchain( console );
}

//

function inputUnchain( test )
{
  // !!! needs silencing = false
  // test.description = 'remove existing input';
  // var l = new wLogger({ output : null });
  // l.inputFrom( console );
  // var got = [ l.inputUnchain( console ), console.outputs ];
  // var expected = [ true, undefined ];
  // test.identical( got, expected );

  test.description = 'input not exists';
  var l = new wLogger();
  var got = l.inputUnchain( console );
  var expected = false;
  test.identical( got, expected );

  test.description = 'remove logger from input';
  var l1 = new wLogger();
  var l2 = new wLogger();
  l2.inputFrom( l1 );
  var got = [ l2.inputs.length, l1.outputs.length ];
  var expected = [ 1, 2 ];
  test.identical( got, expected );
  var got = [ l2.inputUnchain( l1 ), l2.inputs.length, l1.outputs.length ];
  var expected = [ true, 0, 1 ];
  test.identical( got, expected );

  test.description = 'remove logger from input#2';
  var l1 = new wLogger();
  var l2 = new wLogger();
  var l3 = new wLogger();
  l3.inputFrom( l1 );
  l3.inputFrom( l2 );
  var got = [ l3.inputUnchain( l1 ), l3.inputs.length, l1.outputs.length ];
  var expected = [ true, 1, 1 ];
  test.identical( got, expected );

  test.description = 'no args';
  var l = new wLogger();
  var l1 = new wLogger();
  l.inputFrom( l1 );
  test.identical( l.inputs.length, 1 )
  l.inputUnchain();
  test.identical( l.inputs.length, 0 )

  test.description = 'try to remove itself, false because no inputs';
  var l = new wLogger();
  var got = l.inputUnchain( l );
  test.identical( l.inputs.length, 0 );
  test.identical( got, false );

}

//

function hasInputDeep( test )
{
  test.description = 'has console in inputs';
  var l = new wLogger({ output : null });
  l.inputFrom( console );
  var got = l.hasInputDeep( console );
  var expected = true;
  test.identical( got, expected );

  test.description = 'has logger in inputs';
  var l = new wLogger({ output : null });
  var got = l.hasInputDeep( logger );
  var expected = false;
  test.identical( got, expected );

  test.description = 'no args';
  test.shouldThrowError( function()
  {
    var logger = new wLogger();
    logger.hasInputDeep();
  });
}

//

function hasOutputDeep( test )
{
  test.description = 'has logger in outputs';
  var l1 = new wLogger();
  var l2 = new wLogger();
  l1.outputTo( l2,{ combining : 'rewrite' } );
  var got = l1.hasOutputDeep( l2 );
  var expected = true;
  test.identical( got, expected );

  test.description = 'object not exists in outputs';
  var l1 = new wLogger();
  var got = l1.hasOutputDeep( {} );
  var expected = false;
  test.identical( got, expected );

  test.description = 'no args';
  test.shouldThrowError( function()
  {
    var logger = new wLogger();
    logger.hasOutputDeep();
  });
}

//

function _hasInput( test )
{
  test.description = 'l1->l2->l3, l3 has l1 in input chain';
  var l1 = new wLogger({ output : null });
  var l2 = new wLogger({ output : null });
  var l3 = new wLogger({ output : null });
  l1.outputTo( l2 )
  l2.outputTo( l3 );
  var got = l3._hasInput( l1, {} );
  var expected = true;
  test.identical( got, expected );

  test.description = 'console->l1,l2,l3, l1->l2->l3, l3 has l1 in input chain';
  var l1 = new wLogger({ output : null });
  var l2 = new wLogger({ output : null });
  var l3 = new wLogger({ output : null });
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
  test.description = 'l1->l2->l3, l1 has l3 in output chain';
  var l1 = new wLogger({ output : null });
  var l2 = new wLogger({ output : null });
  var l3 = new wLogger({ output : null });
  l1.outputTo( l2 )
  l2.outputTo( l3 );
  var got = l1._hasOutput( l3, {} );
  var expected = true;
  test.identical( got, expected );

  test.description = 'two outputs for l1,l2, l1 has l3 in output chain';
  var l1 = new wLogger();
  var l2 = new wLogger();
  var l3 = new wLogger();
  l1.outputTo( l2, { combining : 'append' } );
  l2.outputTo( l3, { combining : 'append' } );
  var got = l1._hasOutput( l3, {} );
  var expected = true;
  test.identical( got, expected );
}

//

function recursion( test )
{
  test.description = 'add own object to outputs';
  test.shouldThrowError( function()
  {
    var l = new wLogger({ output : null });
    l.outputTo( l );
  });

  test.description = 'l1->l2->l1';
  test.shouldThrowError( function()
  {
    var l1 = new wLogger({ output : null });
    var l2 = new wLogger({ output : null });
    l1.outputTo( l2 );
    l2.outputTo( l1 );
  });

  test.description = 'l1->l2->l1';
  test.shouldThrowError( function()
  {
    var l1 = new wLogger();
    var l2 = new wLogger();
    l1.outputTo( l2, { combining : 'rewrite' } );
    l2.outputTo( l1, { combining : 'rewrite' } );
  });

  test.description = 'multiple inputs, try to add existing input to output';
  test.shouldThrowError( function()
  {
    var l1 = new wLogger();
    var l2 = new wLogger();
    var l3 = new wLogger();
    var l4 = new wLogger();
    l1.outputTo( l4, { combining : 'rewrite' } );
    l2.outputTo( l4, { combining : 'rewrite' } );
    l3.outputTo( l4, { combining : 'rewrite' } );
    l4.outputTo( l1, { combining : 'rewrite' } );
  });

  test.description = 'l3->l2,l2->l1,l1->l3';
  test.shouldThrowError( function()
  {
    var l1 = new wLogger();
    var l2 = new wLogger();
    var l3 = new wLogger();
    l1.inputFrom( l2, { combining : 'rewrite' } );
    l3.inputFrom( l1, { combining : 'rewrite' } );
    l2.inputFrom( l3, { combining : 'rewrite' } );
  });

  test.description = 'console->a->b->console';
  test.shouldThrowError( function()
  {
    var a = new wLogger({ output : null });
    var b = new wLogger({ output : null });
    a.inputFrom( console );
    b.inputFrom( a );
    b.outputTo( console );
  });

  test.description = 'input from existing output';
  test.shouldThrowError( function()
  {
    var a = new wLogger();
    a.inputFrom( console );
  });

  test.description = 'add existing output';
  test.shouldThrowError( function()
  {
    var a = new wLogger();
    a.outputTo( console, { combining : 'append' } );
  });
}

//

var Self =
{

  name : 'Logger',
  silencing : 1,
  // verbosity : 1,
  // silencing : false,

  tests :
  {

    outputTo : outputTo,
    outputUnchain : outputUnchain,

    inputFrom : inputFrom,
    inputUnchain : inputUnchain,

    hasInputDeep : hasInputDeep,
    hasOutputDeep : hasOutputDeep,
    _hasInput : _hasInput,
    _hasOutput : _hasOutput,
    recursion : recursion

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
//   // debugger
//   Self = wTestSuite( Self.name );
//   // Self.logger = wPrinterToJstructure();
//
//   _.Tester.test( Self.name )
//   .doThen( function()
//   {
//     debugger;
//     logger.log( Self.logger.outputData );
//     debugger;
//   });
//
// });

} )( );
