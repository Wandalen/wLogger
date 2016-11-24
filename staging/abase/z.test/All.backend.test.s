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

  require( 'wTools' );

  try
  {
    require( '../../../../wTesting/staging/abase/object/Testing.debug.s' );
  }
  catch ( err )
  {
    require ( 'wTesting' );
  }

  require( './PrinterBase.test.s' );
  require( './Backend.test.s' );
  require( './Chaining.test.s' );
  require( './Logger.test.s' );
  require( './LoggerToFile.test.s' );
  require( './LoggerToJstructure.test.s' );
  require( './Other.test.s' );

}

var _ = wTools;

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test();

} )( );
