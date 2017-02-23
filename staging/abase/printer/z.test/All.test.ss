( function _All_test_ss_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/All.backend.test.s

*/

if( typeof module !== 'undefined' )
{

  require( '../printer/Logger.s' );

  var _ = wTools;

  _.include( 'wTesting' );

  require( './Chaining.test.s' );
  require( './Backend.test.ss' );
  require( './Logger.test.s' );
  require( './Other.test.s' );

}

var _ = wTools;

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test();

} )( );
