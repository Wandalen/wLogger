( function _Basic_s_( )
{

'use strict';

/* Logger */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../wtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );
  _.include( 'wEventHandler' );

  _.include( 'wColor256' ); /* qqq : make the depdendeny optional */

  module[ 'exports' ] = _global_.wTools;
}

})();
