( function _Color_test_s_( )
{

'use strict';

//

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  _.include( 'wTesting' );
  require( '../../l9/logger/entry/Logger.s' );
}

const _global = _global_;
const _ = _global_.wTools;
const Parent = wTester;

//

var _escaping = function( str )
{
  return _.entity.exportString( str,{ escaping : 1 } );
}

//

/* qqq xxx : move. ask */

function colorConsole( test )
{
  var got;
  var onTransformEnd = function( args ) { got = args._outputForTerminal };
  var logger = new _.Logger({ output : null, onTransformEnd });

  test.case = 'case1';
  var msg = _.ct.fg( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg', 'color:rgba( 0, 0, 0, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case2';
  var msg = _.ct.bg( 'msg', 'black' );
  logger.log( msg );
  var expected = [ '%cmsg', 'color:none;background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case3';
  var msg = _.ct.bg( _.ct.fg( 'red text', 'red' ), 'black' );
  logger.log( msg );
  var expected = [ '%cred text', 'color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case4';
  var msg = _.ct.fg( 'yellow text' + _.ct.bg( _.ct.fg( 'red text', 'red' ), 'black' ), 'yellow')
  logger.log( msg );
  var expected = [ '%cyellow text%cred text', 'color:rgba( 255, 255, 0, 1 );background:none;', 'color:rgba( 255, 0, 0, 1 );background:rgba( 0, 0, 0, 1 );' ];
  test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case5: unknown color';
  var msg = _.ct.fg( 'msg', 'unknown' )
  test.shouldThrowErrorOfAnyKind( () =>
  {
    logger.log( msg );
  })
  // var expected = [ '%cmsg','color:none;background:none;' ];
  // test.identical( _escaping( got ), _escaping( expected ) );

  test.case = 'case6: hex color';
  var msg = _.ct.fg( 'msg', 'ff00ff' )
  logger.log( msg );
  var expected = [ '%cmsg', 'color:rgba( 255, 0, 255, 1 );background:none;' ];
  test.identical( _escaping( got ), _escaping( expected ) );

}

//

const Proto =
{

  name : 'Tools.logger.Color.Browser',
  silencing : 1,
  enabled : () => Config.interpreter !== 'njs',

  tests :
  {
    colorConsole,
  },

}

//

const Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
