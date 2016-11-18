(function _Logger_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterMid === 'undefined' )
  require( '../PrinterMid.s' )

}

//

var _ = wTools;
var Parent = wPrinterMid;

/**
 * @class wLogger
 */

var Self = function wLogger()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
  output : console,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools.Logger = Self;
if( !_global_.logger || _.mapIs( _global_.logger ) )
_global_.logger = _global_[ 'logger' ] = new Self();

return Self;

})();
