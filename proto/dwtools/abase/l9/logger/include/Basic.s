( function _Basic_s_( )
{

'use strict';

/* Logger */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../dwtools/Tools.s' );

  // _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );
  _.include( 'wEventHandler' );

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

  module[ 'exports' ] = _global_.wTools;
}

})();
