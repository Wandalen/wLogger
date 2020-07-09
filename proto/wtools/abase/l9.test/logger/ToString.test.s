( function _ToString_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../l9/logger/entry/Logger.s' );
  _.include( 'wTesting' );
}

let _ = _global_.wTools;

// --
// tests
// --

function basic( test )
{

  test.case = 'basic';
  var logger1 = new _.LoggerToString();
  logger1.log( 'abc' );
  logger1.log( 'xyz' );
  var exp = 'abc\nxyz';
  test.identical( logger1.outputData, exp );

  test.case = 'output to loggerToString';
  var logger1 = new _.Logger();
  var logger2 = new _.LoggerToString();
  logger1.outputTo( logger2 );
  logger1.outputTo( console );
  logger1.log( 'abc' );
  logger1.log( 'xyz' );
  var exp = 'abc\nxyz';
  test.identical( logger2.outputData, exp );

}

// --
// declare
// --

var Proto =
{

  name : 'Tools.base.printer.ToString',
  silencing : 1,

  tests :
  {

    basic,

  },

}

//

let Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
