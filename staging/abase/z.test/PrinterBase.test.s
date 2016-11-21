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
  /*rewrite*/
  test.description = 'case1 : rewrite';
  var l = new wLogger();
  l.outputTo( null, { combining : 'rewrite' } );
  var got = [ l.output, l.outputs ];
  var expected = [ null, [] ];
  test.identical( got, expected );

  test.description = 'case2 : rewrite';
  var l = new wLogger();
  l.outputTo( logger, { combining : 'rewrite' } );
  var got = ( l.output === logger && l.outputs.length === 1 );
  var expected = true;
  test.identical( got, expected );

 /*append*/
 test.description = 'case3 : append';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'append' } );
 var got = ( l.output === logger && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'case4 : append';
 var l = new wLogger({ output : null});
 l.outputTo( logger, { combining : 'append' } );
 var got = ( l.output === logger && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'case5: append existing';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'append' } );

 var got =  l.outputTo( logger, { combining : 'append' } );
 var expected = false;
 test.identical( got, expected );

 /*prepend*/
 test.description = 'case5 : prepend';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'prepend' } );
 var got = ( l.outputs[ 0 ].output === logger && l.outputs.length === 2 );
 var expected = true;
 test.identical( got, expected );

 test.description = 'case5 : prepend existing';
 var l = new wLogger();
 l.outputTo( logger, { combining : 'prepend' } );
 var got = l.outputTo( logger, { combining : 'prepend' } );
 var expected = false;
 test.identical( got, expected );

 /*supplement*/
 test.description = 'case6 : supplement';
 var l = new wLogger();
 var got = l.outputTo( logger, { combining : 'supplement' } );
 var expected = false;
 test.identical( got, expected );

 test.description = 'case7 : supplement';
 var l = new wLogger({  output : null });
 l.outputTo( logger, { combining : 'supplement' } );
 var got = ( l.output && l.outputs.length === 1 );
 var expected = true;
 test.identical( got, expected );

 /*combining off*/
 test.description = 'case8 : combining off';
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

var Proto =
{

  name : '',

  tests :
  {

    outputTo : outputTo,

  },

  verbose : 1,

}

//

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
