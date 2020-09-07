( function _Backend_test_ss_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../../l9/logger/entry/Logger.s' );
  let _global = _global_;
  let _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTester;
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

let Self =
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

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
