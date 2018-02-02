( function _Logger_test_s_( ) {

'use strict';

/*

to run this test
from the project directory run

npm install
node ./staging/dwtools/abase/z.test/Logger.test.s

*/

if( typeof module !== 'undefined' )
{

  require( '../../printer/top/Logger.s' );

  var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

var _ = _global_.wTools;
var Parent = _.Tester;

//

function experiment( test )
{
  debugger
  var l = new _.Logger({ output : null });
  l.inputFrom( console );
  // l.inputUnchain( console );
  test.identical( 1, 1 );
}

//



//

var Self =
{

  name : 'experiment1',
  silencing : 1,
  // verbosity : 1,
  // silencing : false,

  tests :
  {
    experiment : experiment,
  },

}

//

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
