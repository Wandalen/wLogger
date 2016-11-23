( function _PrinterBase_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/Logger.test.s

*/

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  require( '../../../../wTools/staging/abase/component/StringTools.s' );
  require( '../object/printer/printer/Logger.s' );

  try
  {
    require( '../../../../wTesting/staging/abase/object/Testing.debug.s' );
  }
  catch ( err )
  {
    require ( 'wTesting' );
  }

}

var _ = wTools;
var Self = {};

//

var outputTo = function( test )
{
  test.description = '';
  var l = new wLogger({ output : null });
  l.outputTo( console );
  var got = l.outputs[ 0 ].output;
  var expected = console;
  test.identical( got, expected );

  test.description = '';
  var l = new wLogger();
  var got = l.outputTo( null );
  var expected = false;
  test.identical( got, expected );

  /*rewrite*/
  test.description = 'rewrite with null';
  var l = new wLogger();
  l.outputTo( null, { combining : 'rewrite' } );
  var got = [ l.output, l.outputs ];
  var expected = [ null, [] ];
  test.identical( got, expected );

  test.description = 'rewrite';
  var l = new wLogger();
  l.outputTo( logger, { combining : 'rewrite' } );
  var got = ( l.output === logger && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

 /*append*/
 test.description = 'append';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'append' } );
 var got = ( l.output === logger && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'append list is empty';
 var l = new wLogger({ output : null});
 l.outputTo( logger, { combining : 'append' } );
 var got = ( l.output === logger && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'append null';
 var l = new wLogger();
 l.outputTo( null, { combining : 'append' } );
 var got = ( l.output === logger && l.outputs.length === 1 );
 var expected = false;
 test.identical( got, expected );

 test.description = 'append existing';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'append' } );

 var got =  l.outputTo( logger, { combining : 'append' } );
 var expected = false;
 test.identical( got, expected );

 /*prepend*/
 test.description = 'prepend';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'prepend' } );
 var got = ( l.outputs[ 0 ].output === logger && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'prepend existing';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'prepend' } );
 var got = l.outputTo( logger, { combining : 'prepend' } );
 var expected = false;
 test.identical( got, expected );

 test.description = 'prepend null';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'prepend' } );
 var got = l.outputTo( null, { combining : 'prepend' } );
 var expected = false;
 test.identical( got, expected );

 /*supplement*/
 test.description = 'try supplement not empty list';
 var l = new wLogger();
 var got = l.outputTo( logger, { combining : 'supplement' } );
 var expected = false;
 test.identical( got, expected );

 test.description = 'supplement';
 var l = new wLogger({  output : null });
 l.outputTo( logger, { combining : 'supplement' } );
 var got = ( l.output && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'supplement null';
 var l = new wLogger();
 var got = l.outputTo( null, { combining : 'supplement' } );
 var expected = false;
 test.identical( got, expected );

 /*combining off*/
 test.description = 'combining off';
 var l = new wLogger({  output : null });
 l.outputTo( logger );
 var got = ( l.output && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 if( Config.debug )
 {
   test.description = 'empty call';
   test.shouldThrowError( function()
   {
     logger.outputTo( )
   });

   test.description = 'invalid output type';
   test.shouldThrowError( function()
   {
     logger.outputTo( '1' )
   });

   test.description = 'invalid combining type';
   test.shouldThrowError( function()
   {
     logger.outputTo( console, { combining : 'invalid' } );
   });

   test.description = 'invalid leveling type';
   test.shouldThrowError( function()
   {
     logger.outputTo( console, { leveling : 'invalid' } );
   });

   test.description = 'combining off, outputs not empty';
   test.shouldThrowError( function()
   {
     logger.outputTo( console );
   });

   test.description = 'empty output ';
   test.shouldThrowError( function()
   {
     logger.outputTo( { },{ combining : 'rewrite' } );
   });
 }
}

//

var recursion = function( test )
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

  test.description = 'console->a->b->console';
  test.shouldThrowError( function()
  {
    var a = new wLogger();
    a.inputFrom( console );
  });
}

//

var Proto =
{

  name : '',

  tests :
  {

    outputTo : outputTo,
    recursion : recursion

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
