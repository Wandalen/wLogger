( function _Backend_test_ss_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  _.include( 'wTesting' );
  require( '../../l9/logger/entry/Logger.s' );
}

//

const _global = _global_;
const _ = _global_.wTools;
const Parent = wTester;
var isUnix = process.platform !== 'win32';

//

function simplest( test )
{

  test.case = 'simple1';

  var logger = new _.Logger({ output : console });

  logger.logUp( 'up' );
  logger.log( 'log' );
  logger.log( 'log\nlog' );
  logger.log( 'log', 'a', 'b' );
  logger.log( 'log\nlog', 'a', 'b' );
  logger.log( 'log\nlog', 'a\n', 'b\n' );
  logger.logDown( 'down' );

  test.identical( 1, 1 );

}

//

const Proto =
{

  name : 'Tools.logger.Backend',
  /* verbosity : 1, */
  silencing : 1,

  tests :
  {
    simplest,
  },

}

//

const Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
