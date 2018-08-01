( function _Browser_test_s_( ) {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
isBrowser = false;

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wTesting' );

}

var _global = _global_; var _ = _global_.wTools;
var Parent = _.Tester;

//

function toStrEscaping( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

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

  test.identical( 1,1);

}

//

var Self =
{

  name : 'Tools/base/printer/Browser',
  /* verbosity : 1, */
  silencing : 1,

  tests :
  {
    simplest : simplest,
  },

}

//

if( isBrowser )
Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
