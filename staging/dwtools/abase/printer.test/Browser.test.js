( function _Browser_test_s_( ) {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
isBrowser = false;

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

var _ = _global_.wTools;
var Parent = _.Tester;

//

function toStrEscaping( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function simplest( test )
{

  test.description = 'simple1';

  var logger = new _.Logger();

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

var _escaping = function( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function colorConsole( test )
{
  var got;
  var onWrite = function( args ){ console.log(args);got = args.outputForTerminal };


  var logger = new _.Logger( { output : null, onWrite : onWrite });


  test.description = 'case1';
  var msg = _.color.strFormatForeground( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 0, 0, 0, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case2';
  var msg = _.color.strFormatBackground( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:none;background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case3';
  var msg = _.color.strFormatBackground( _.color.strFormatForeground( 'red text', 'red' ), 'black' );
  logger.log( msg );
  var expected = [ '%cred text','color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case4';
  var msg = _.color.strFormatForeground( 'yellow text' + _.color.strFormatBackground( _.color.strFormatForeground( 'red text', 'red' ), 'black' ), 'yellow')
  logger.log( msg );
  var expected = [ '%cyellow text%cred text','color:rgba( 255, 255, 0, 1 );background:none;', 'color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case5: unknown color';
  var msg = _.color.strFormatForeground( 'msg', 'unknown')
  logger.log( msg );
  var expected = [ '%cmsg','color:none;background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.description = 'case6: hex color';
  var msg = _.color.strFormatForeground( 'msg', 'ff00ff' )
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 255, 0, 255, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

}

//

var Self =
{

  name : 'Logger browser test',
  /* verbosity : 1, */
  silencing : 1,

  tests :
  {

    simplest : simplest,
    colorConsole : colorConsole

  },

}

//

if( isBrowser )
Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
