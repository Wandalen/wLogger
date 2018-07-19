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

  var _ = _global_.wTools;

}

//

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterMid;
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

//

function colorFormat( src, format )
{
  var self = this;
  _.assert( arguments.length === 2 );
  if( !self.coloring || !_.color || !_.color.strFormat )
  return src;
  return _.color.strFormat( src, format );
}

//

function colorBg( src, format )
{
  var self = this;
  _.assert( arguments.length === 2 );
  if( !self.coloring || !_.color || !_.color.strFormatBackground )
  return src;
  return _.color.strFormatBackground( src, format );
}

//

function colorFg( src, format )
{
  var self = this;
  _.assert( arguments.length === 2 );
  if( !self.coloring || !_.color || !_.color.strFormatForeground )
  return src;
  return _.color.strFormatForeground( src, format );
}

// --
// relationships
// --

var Composes =
{
  coloring : 0,
}

var Aggregates =
{
}

var Associates =
{
}

// --
// define class
// --

var Proto =
{

  // routine

  init : init,

  colorFormat : colorFormat,
  colorBg : colorBg,
  colorFg : colorFg,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.PrinterChainingMixin.mixin( Self );
_.PrinterColoredMixin.mixin( Self );

//

_.accessor
({
  object : Self.prototype,
  combining : 'rewrite',
  names :
  {
    level : 'level',
  }
});

//

_[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
