( function _Logger_test_s_( ) {

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
var Parent = wTools.Testing;
var Self = {};

//

var simplest = function( test )
{

  test.description = 'simple1';

  var logger = new wLogger();

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

var Proto =
{

  name : 'Logger',

  tests :
  {

    simplest : simplest,

  },

  /* verbose : 1, */

}

//

_.mapExtend( Self,Proto );
_.Testing.register( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
