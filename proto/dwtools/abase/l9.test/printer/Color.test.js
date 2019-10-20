( function _Color_test_s_( ) {

'use strict';

//

if( typeof module !== 'undefined' )
{

  require( '../../l9/printer/top/Logger.s' );
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

var _global = _global_;
var _ = _global_.wTools;
var Parent = wTester;

//

var _escaping = function( str )
{
  return _.toStr( str,{ escaping : 1 } );
}

//

function colorConsole( test )
{
  var got;
  var onTransformEnd = function( args ){ got = args.outputForTerminal };

  var logger = new _.Logger( { output : null, onTransformEnd });

  test.case = 'case1';
  var msg = _.color.strFormatForeground( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 0, 0, 0, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case2';
  var msg = _.color.strFormatBackground( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg','color:none;background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case3';
  var msg = _.color.strFormatBackground( _.color.strFormatForeground( 'red text', 'red' ), 'black' );
  logger.log( msg );
  var expected = [ '%cred text','color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case4';
  var msg = _.color.strFormatForeground( 'yellow text' + _.color.strFormatBackground( _.color.strFormatForeground( 'red text', 'red' ), 'black' ), 'yellow')
  logger.log( msg );
  var expected = [ '%cyellow text%cred text','color:rgba( 255, 255, 0, 1 );background:none;', 'color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case5: unknown color';
  var msg = _.color.strFormatForeground( 'msg', 'unknown')
  test.shouldThrowErrorOfAnyKind( () =>
  {
    logger.log( msg );
  })
  // var expected = [ '%cmsg','color:none;background:none;' ];
  // test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case6: hex color';
  var msg = _.color.strFormatForeground( 'msg', 'ff00ff' )
  logger.log( msg );
  var expected = [ '%cmsg','color:rgba( 255, 0, 255, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

}

//

var Self =
{

  name : 'Tools.base.printer.Color.Browser',
  silencing : 1,
  enabled : () => Config.interpreter !== 'njs',

  tests :
  {
    colorConsole,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
