( function _Backend_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//
var _global = _global_;
var _ = _global_.wTools;
var Parent = /*_.*/wTester;
var isUnix = process.platform !== 'win32' ? true : false;

//

function simplest( test )
{

  test.case = 'simple1';

  var logger = new _.Logger({ output : console });

  logger.logUp( 'up' );
  logger.log( 'log' );
  logger.log( 'log\nlog' );
  logger.log( 'log','a','b' );
  logger.log( 'log\nlog','a','b' );
  logger.log( 'log\nlog','a\n','b\n' );
  logger.logDown( 'down' );

  test.identical( 1,1 );

}

//

var Self =
{

  name : 'Tools/base/printer/Backend',
  /* verbosity : 1, */
  silencing : 1,

  tests :
  {
    simplest : simplest,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
/*_.*/wTester.test( Self.name );

} )( );
