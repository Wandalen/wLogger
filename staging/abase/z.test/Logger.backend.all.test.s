( function _All_backend_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/abase/z.test/All.backend.test.s

*/

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../include/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wLogger' );
  _.include( 'wTesting' );

  require( './Chaining.test.s' );
  require( './Backend.test.s' );
  require( './Logger.test.s' );
  require( './Other.test.s' );

}

var _ = wTools;

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test();

} )( );
