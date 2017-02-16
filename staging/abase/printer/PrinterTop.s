(function _PrinterTop_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  if( typeof wPrinterTop !== 'undefined' )
  return;

  isBrowser = false;

  if( typeof wPrinterMid === 'undefined' )
  require( './PrinterMid.s' )

  require( './aColoredMixin.s' )

  var _ = wTools;

  _.include( 'wColor' );

}

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

//

var _ = wTools;
var Parent = wPrinterMid;
var Self = function wPrinterTop( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterTop';

//

function init( o )
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
}

// --
// prototype
// --

var Proto =
{

  // routine

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

wPrinterChainingMixin.mixin( Self );
wPrinterColoredMixin.mixin( Self );

//

_.accessor
({
  object : Self.prototype,
  combining : 'rewrite',
  names :
  {
    level : 'level',
    // foregroundColor : 'foregroundColor',
    // backgroundColor : 'backgroundColor',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
