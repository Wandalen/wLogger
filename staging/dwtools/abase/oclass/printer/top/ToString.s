(function _PrinterToString_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath )/*hhh*/;
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath )/*hhh*/;
  }


  var _ = _global_.wTools;

  _.include( 'wLogger' );

}

//

var _ = _global_.wTools;
var Parent = _.PrinterTop;
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

  var o = _.PrinterBase.prototype.write.apply( self,arguments );

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

_global_[ Self.name ] = _[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.nameShort ] = Self;

})();
