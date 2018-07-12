(function _Logger_s_() {

'use strict'; 

/*

 - problem !!!
  logger.foregroundColor = 'blue';
  logger.log( 'some\ntext' );

*/

// require
// if( typeof wLogger !== 'undefined' )
// return;

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterTop === 'undefined' )
  require( '../PrinterTop.s' );

}

//

/**
 * @class wLogger
 */

var _global = _global_; var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wLogger( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'Logger';

//

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 | arguments.length === 1 );

  Parent.prototype.init.call( self,o );

}

// --
// relationships
// --

var Composes =
{
  name : '',
}

var Aggregates =
{
}

var Associates =
{
  output : console,
}

var Restricts =
{
}

var Statics =
{
}

// --
// define class
// --

var Proto =
{

  init : init,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_[ Self.nameShort ] = Self;

if( !_global_.logger || _.mapIs( _global_.logger ) )
_global_.logger = _global_[ 'logger' ] = new Self(/* { coloring : 1 } */);

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
