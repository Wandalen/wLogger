( function _ToString_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../l9/logger/entry/Logger.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;

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

const Proto =
{

  name : 'Tools.logger.ToString',
  silencing : 1,

  tests :
  {

    basic,

  },

}

//

const Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
