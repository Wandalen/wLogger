(function _PrinterToString_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  // if( typeof wBase === 'undefined' )
  try
  {
    require( '../../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wLogger' );

}

//

var _ = wTools;
var Parent = wPrinterTop;
var Self = function wPrinterToString( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterToString';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

}

//

function write()
{
  var self = this;

  var o = wPrinterBase.prototype.write.apply( self,arguments );

  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );
  _.assert( _.strIs( o.pure ) );

  self.outputData += o.pure;

  return o;
}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
  outputData : '',
}

var Associates =
{
}

var Restricts =
{
}

// --
// prototype
// --

var Proto =
{

  init : init,

  write : write,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classMake
({
  cls : Self,
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

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
